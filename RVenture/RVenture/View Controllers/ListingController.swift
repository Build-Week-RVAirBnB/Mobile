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
let baseURL = URL(string: "https://rventure-listings.firebaseio.com/")!

class ListingController {

    typealias CompletionHandler = (Error?) -> Void

    init() {
        fetchListingsFromServer()
    }
    
    // MARK: - Fetch
    func fetchListingsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
    
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
    
    // MARK:- Update
    
    func updateListings(with representations: [ListingRepresentation]) throws {
        let listingsWithID = representations.filter { $0.identifier != nil}
        let identifiersToFetch = listingsWithID.compactMap { UUID(uuidString: $0.identifier!)}
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
    }
    
    private func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }

}
