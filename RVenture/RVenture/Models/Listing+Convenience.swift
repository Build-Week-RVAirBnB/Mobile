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
        let listingLocation = listingLocation,
        let listingPhoto = listingPhoto,
        let listingDate = listingDate else { return nil}
        
        return ListingRepresentation(listingName: listingName,
                                     listingDescription: listingDescription,
                                     listingLocation: listingLocation,
                                     listingPrice: listingPrice, listingPhoto: listingPhoto, listingDate: listingDate)
    }
    
    @discardableResult
    convenience init(listingId: UUID = UUID(),
                     listingName: String,
                     listingDescription: String?,
                     listingLocation: String,
                     listingPrice: Double,
                     listingPhoto: String,
                     listingDate: Date,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.listingId = listingId
        self.listingName = listingName
        self.listingDescription = listingDescription
        self.listingPhoto = listingPhoto
        self.listingDate = listingDate
        self.listingLocation = listingLocation
        self.listingPrice = listingPrice
      
    }
    
    @discardableResult
    convenience init?(listingRepresentation: ListingRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let listingId = listingRepresentation.listingId ?? UUID()
        
        self.init(listingId: listingId,
                  listingName: listingRepresentation.listingName,
                  listingDescription: listingRepresentation.listingDescription,
                  listingLocation: listingRepresentation.listingLocation,
                  listingPrice: listingRepresentation.listingPrice,
                  listingPhoto: listingRepresentation.listingPhoto,
                  listingDate: listingRepresentation.listingDate,
                  context: context)
                    
        }
}
