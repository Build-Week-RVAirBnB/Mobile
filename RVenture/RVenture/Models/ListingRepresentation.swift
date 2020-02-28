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
    
    @discardableResult
    convenience init(listId: UUID = UUID(),
                     listName: String,
                     listDescription: String?,
                     listPrice: Double,
                     listPhoto: String,
                     listDates: Date,
                     listBookings: UUID,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.listId = listId
        self.listName = listName
        self.listDescription = listDescription
        self.listPhoto = listPhoto
        self.listDates = listDates
      
    }
    
    @discardableResult
    convenience init?(listingRepresentation: ListingRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(listId: listingRepresentation.listId,
                  listName: listingRepresentation.listName,
                  listDescription: listingRepresentation.listDescription,
                  listPrice: listingRepresentation.listPrice,
                  listPhoto: listingRepresentation.listPhoto,
                  listDates: listingRepresentation.listDates,
                  listBookings: listingRepresentation.listId,
                  context: context)
                    
        }
}
