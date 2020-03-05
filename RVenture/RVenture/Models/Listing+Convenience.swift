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
        
        return ListingRepresentation(name: name,
                                     descriptions: description,
                                     price: price, date: date)
    }
    
    @discardableResult
    convenience init(name: String,
                     descriptions: String?,
                     price: Double,
                     identifier: UUID = UUID(),
                     date: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.descriptions = descriptions
        self.date = date
        self.price = price
      
    }
    
    @discardableResult
    convenience init?(listingRepresentation: ListingRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let identifier = listingRepresentation.identifier ?? UUID()
        
        let listingDate = listingRepresentation.date ?? Date()
        
        self.init(name: listingRepresentation.name,
                  descriptions: listingRepresentation.descriptions,
                  price: listingRepresentation.price,
                  identifier: identifier,
                  date: listingDate,
                  context: context)
                    
        }
}
