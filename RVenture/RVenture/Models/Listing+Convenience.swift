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
        
        return ListingRepresentation(identifier: identifier?.uuidString ?? "",
                             name: listingName,
                             description: listingDescription ?? "",
                             price: listingPrice ?? "",
                             image: image)
    }
    
    @discardableResult
    convenience init(listingName: String,
                     listingDescription: String,
                     listingPrice: String,
                     identifier: UUID = UUID(),
                     image: Data?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.listingName = listingName
        self.listingDescription = listingDescription
        self.listingPrice = listingPrice
        self.identifier = identifier
    }
    
    @discardableResult
    convenience init?(listingRepresentation: ListingRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifierString = listingRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else {
                return nil
        }
    
        
        self.init(listingName: listingRepresentation.name,
                  listingDescription: listingRepresentation.description,
                  listingPrice: listingRepresentation.price,
                  identifier: identifier,
                  image: listingRepresentation.image,
                  context: context)
    
    }

}

