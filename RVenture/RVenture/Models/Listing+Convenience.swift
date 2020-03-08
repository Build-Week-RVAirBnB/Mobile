//
//  ListingRepresentation.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import CoreData

extension Listing {
    
    var listingRepresentation: ListingRepresentation? {
        guard let listingName = listingName,
        let image = image else {
            return nil
        }
        
        return ListingRepresentation(identifier: identifier,
                                     name: listingName,
                                     description: listingDescription ?? "",
                                     price: listingPrice ?? "",
                                     date: date,
                                     image: image)
        
//        return ListingRepresentation(identifier: identifier?.uuidString ?? "",
//                             name: listingName,
//                             description: listingDescription ?? "",
//                             price: listingPrice ?? "",
//                             image: image)
    }
    
    @discardableResult
    convenience init(listingName: String,
                     listingDescription: String,
                     listingPrice: String,
                     identifier: UUID = UUID(),
                     date: Date?,
                     image: String?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.listingName = listingName
        self.listingDescription = listingDescription
        self.listingPrice = listingPrice
        self.identifier = identifier
        self.date = date
        self.image = image
    }
    
    @discardableResult
    convenience init?(listingRepresentation: ListingRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let identifier = listingRepresentation.identifier ?? UUID()
        let date = listingRepresentation.date ?? Date()
    
        
        self.init(listingName: listingRepresentation.name,
                  listingDescription: listingRepresentation.description,
                  listingPrice: listingRepresentation.price,
                  identifier: identifier,
                  date: date,
                  image: listingRepresentation.image,
                  context: context)
    
    }

}

