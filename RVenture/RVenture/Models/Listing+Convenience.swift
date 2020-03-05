//
//  ListingRepresentation.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Listing {
    
    var listingRepresentation: ListingRepresentation? {
        guard let name = name,
        let description = descriptions else { return nil}
        let imagePath = ""
        return ListingRepresentation(name: name, description: description, price: price, imagePath: imagePath)
    }
    
    @discardableResult
    convenience init(name: String,
                     descriptions: String?,
                     price: Double,
                     identifier: UUID = UUID(),
                     date: Date = Date(),
                     image: String?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.descriptions = descriptions
        self.date = date
        self.price = price
        self.image = image
      
    }
    
    @discardableResult
    convenience init?(listingRepresentation: ListingRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let listingDate = listingRepresentation.date ?? Date()
        let image = listingRepresentation.imagePath ?? ""
        
        self.init(name: listingRepresentation.name,
                  descriptions: listingRepresentation.description,
                  price: listingRepresentation.price,
                  identifier: listingRepresentation.identifier,
                  date: listingDate,
                  image: image,
                  context: context)
                    
        }
}
