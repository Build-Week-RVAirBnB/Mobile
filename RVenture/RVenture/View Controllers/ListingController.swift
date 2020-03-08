//
//  ListingController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//
//
import UIKit
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case decodingError
}

// Testing URL for database
//let baseURL = URL(string: "https://rventure-a96cc.firebaseio.com/")!
let baseURL = URL(string: "https://rventure-a96cc.firebaseio.com/")!

class ListingController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchListingsFromServer()
    }
    
    
    static let shared = ListingController()
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveImage(image: UIImage) -> String? {
        let date = String( Date.timeIntervalSinceReferenceDate )
        let imageName = date.replacingOccurrences(of: ".", with: "-") + ".png"
        
        if let imageData = image.pngData() {
            do {
                let filePath = documentsPath.appendingPathComponent(imageName)
                
                try imageData.write(to: filePath)
                
                print("\(imageName) was saved.")
                
                return imageName
            } catch let error as NSError {
                print("\(imageName) could not be saved: \(error)")
                
                return nil
            }
            
        } else {
            print("Could not convert UIImage to png data.")
            
            return nil
        }
    }
    
    func fetchImage(imageName: String) -> UIImage? {
        let imagePath = documentsPath.appendingPathComponent(imageName).path

        guard fileManager.fileExists(atPath: imagePath) else {
            print("Image does not exist at path: \(imagePath)")

            return nil
        }

        if let imageData = UIImage(contentsOfFile: imagePath) {
            return imageData
        } else {
            print("UIImage could not be created.")

            return nil
        }
    }

    func deleteImage(imageName: String) {
        let imagePath = documentsPath.appendingPathComponent(imageName)

        guard fileManager.fileExists(atPath: imagePath.path) else {
            print("Image does not exist at path: \(imagePath)")

            return
        }

        do {
            try fileManager.removeItem(at: imagePath)

            print("\(imageName) was deleted.")
        } catch let error as NSError {
            print("Could not delete \(imageName): \(error)")
        }
    }
    
    func fetchListingsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("listings").appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil else {
                print("Error fetching listings: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                print("No data returned by datatask")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do {
                let listingRepresentations = Array(try JSONDecoder().decode([String: ListingRepresentation].self, from: data).values)
                try self.updateListings(with: listingRepresentations)
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding listing representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }
    
    func sendListingToServer(listing: Listing, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = listing.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent("listings").appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = listing.listingRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            listing.identifier = uuid
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding tasks: \(listing): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("Error PUTting task to server")
                DispatchQueue.main.async {
                    completion(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    
    
    func updateListings(with representations: [ListingRepresentation]) throws {
        let listingsWithID = representations.filter { $0.identifier != nil}
        let identifiersToFetch = listingsWithID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, listingsWithID))
        var listingsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingListings = try context.fetch(fetchRequest)
            for listing in existingListings {
                guard let id = listing.identifier,
                    let representation = representationsByID[id] else {
                        continue }
                self.update(listing: listing, with: representation)
                listingsToCreate.removeValue(forKey: id)
            }
            for representation in listingsToCreate.values {
                Listing(listingRepresentation: representation, context: context)
            }
        } catch {
            print("Error fetching listing for UUIDs: \(error)")
        }
        
        try self.saveToPersistentStore()
    }
    
    
    
    // MARK: - Private Functions
    
    private func update(listing: Listing, with representation: ListingRepresentation) {
        listing.listingName = representation.name
        listing.listingDescription = representation.description
        listing.listingPrice = representation.price
        listing.image = representation.image
        listing.date = representation.date
        listing.dateTo = representation.dateTo
    }
    
    private func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }

    
    //CRUD:
    func createListing(name: String, description: String?, price: String?, date: Date?, dateTo: Date?, image: String?, identifier: UUID = UUID()) {
        guard let date = date,
           let dateTo = dateTo,
           let description = description,
            let image = image,
            let price = price else { return }
            
            let _ = Listing(listingName: name, listingDescription: description, listingPrice: price, date: date, dateTo: dateTo, image: image)
        
    }
    
    func createListing(from listingRepresentation: ListingRepresentation) {
        let name = listingRepresentation.name
        let date = listingRepresentation.date
        let description = listingRepresentation.description
        let price = listingRepresentation.price
        let identifier = listingRepresentation.identifier ?? UUID()
        let image = listingRepresentation.image
        
        createListing(name: name, description: description, price: price, date: date, dateTo: date, image: image, identifier: identifier)
    }
    
}
