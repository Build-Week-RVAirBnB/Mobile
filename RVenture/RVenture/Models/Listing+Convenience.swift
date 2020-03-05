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
    convenience init(listingName: String, listingDescription: String, listingPrice: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.listingName = listingName
        self.listingDescription = listingDescription
        self.listingPrice = listingPrice
    }

}
