//
//  ListingController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import Firebase

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
let baseURL = URL(string: "https://rventure-a96cc.firebaseio.com/")!

class ListingController {
    
    typealias CompletionHandler = (Error?) -> Void
    // For UI testing ; update with CoreData entity
    let locationName = ["The Shire", "Olympus Mons", "Gotham City"]
    let locationImage = [UIImage(named: "resize-1"),UIImage(named: "resize-2"),UIImage(named: "resize-3")]
    let locationPrice = ["$10/night", "$25/night", "$30/night"]
    let locationDescription = ["Lots of grass", "Interstellar views", "Dark Knight glamping"]
    
    // MARK: - Properties

   
    
    var searchedListings: [ListingRepresentation] = []
    
    init() {
        fetchListingsFromServer()
    }
    
    func searchForListing(with searchTerm: String, completion: @escaping (Error?) -> Void) {
           
           var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
           
        //TODO: QUERY PARAMETERS From backend
////           let queryParameters = ["query": searchTerm,
////                                  "api_key": apiKey]
//
//           components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
//
           guard let requestURL = components?.url else {
               completion(NSError())
               return
           }
           
           URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
               
               if let error = error {
                   NSLog("Error searching for movie with search term \(searchTerm): \(error)")
                   completion(error)
                   return
               }
               
               guard let data = data else {
                   NSLog("No data returned from data task")
                   completion(NSError())
                   return
               }
               
               do {
                let listingRepresentations = try JSONDecoder().decode(ListingRepresentations.self, from: data).results
                   self.searchedListings = listingRepresentations
                   completion(nil)
               } catch {
                   NSLog("Error decoding JSON data: \(error)")
                   completion(error)
               }
           }.resume()
       }
    
    func fetchListingsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("Listing").appendingPathComponent("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil else {
                print("Error fetching listings: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            let context = CoreDataStack.shared.container.newBackgroundContext()
            context.perform {
                do {
                    let listingRepresentations = Array(try JSONDecoder().decode([Data : ListingRepresentation].self, from: data).values)
                    try self.updateListings(with: listingRepresentations)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } catch {
                    print("Error deocding list representations: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }.resume()
    }
    
    func updateListings(with representations: [ListingRepresentation]) throws {
        let listingsWithID = representations.filter { $0.identifier != nil}
        let identifiersToFetch = listingsWithID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, listingsWithID))
        
        var listingsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "listId IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let allListings = try context.fetch(Listing.fetchRequest()) as? [Listing]
                let listingsToDelete = allListings!.filter {
                    !identifiersToFetch.contains($0.identifier!) }
                
                for listing in listingsToDelete {
                    context.delete(listing)
                }
                
                let existingListings = try context.fetch(fetchRequest)
                
                for listing in existingListings {
                    guard let id = listing.identifier,
                        let representation = representationsByID[id] else { continue }
                    
                    self.update(listing: listing, with: representation)
                    listingsToCreate.removeValue(forKey: id)
                }
                for representation in listingsToCreate.values {
                    Listing(listingRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching task for UUIDs: \(error)")
            }
        }
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            print("Error saving to database")
        }
    }
    
    func sendListingToServer(listing: Listing, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = listing.identifier ?? UUID()
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                guard var representation = listing.listingRepresentation else {
                    completion(NSError())
                    return
                }
                representation.identifier = uuid
                listing.identifier = uuid
                //update the main context bc we are on theUI
                try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
                request.httpBody = try JSONEncoder().encode(representation)
            } catch {
                print("Error encoding task \(listing): \(error)")
                completion(error)
                return
            }
        }
        //background thread
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("Error PUTting listing to server: \(error!)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
        
    }
    
    
    func deleteListingFromServer(_ listing: Listing, completion: @escaping CompletionHandler = { _ in }) {
        
        CoreDataStack.shared.mainContext.perform {
            guard let uuid = listing.identifier else {
                completion(NSError())
                return
            }
            
            let requestURL = baseURL.appendingPathComponent("Listing").appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = HTTPMethod.delete.rawValue
            
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                guard error == nil else {
                    print("Error deleting listing: \(error!)")
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
    }
    
    //MARK: - CRUD
    
    private func update(listing: Listing, with representation: ListingRepresentation) {
        listing.name = representation.name
        listing.date = representation.date
        listing.descriptions = representation.descriptions
        listing.price = representation.price
        listing.identifier = representation.identifier
        
    }
    
    
    func createListing(name: String, date: Date?, description: String?, price: Double, identifier: UUID) {
        
        guard let date = date else { return }
        
        let _ = Listing(name: name, descriptions: description, price: price, date: date)
        
    }
    
    func createListing(from listingRepresentation: ListingRepresentation) {
        let name = listingRepresentation.name
        let date = listingRepresentation.date
        let descriptions = listingRepresentation.descriptions ?? ""
        let price = listingRepresentation.price
        let identifier = listingRepresentation.identifier ?? UUID()
       createListing(name: name, date: date, description: descriptions, price: price, identifier: identifier)
    }
    
    
    func delete(_ listing: Listing) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(listing)
        deleteListingFromServer(listing)
    }

}
