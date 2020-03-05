//
//  Listing+CoreDataProperties.swift
//  
//
//  Created by Joshua Rutkowski on 3/4/20.
//
//

import Foundation
import CoreData


extension Listing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Listing> {
        return NSFetchRequest<Listing>(entityName: "Listing")
    }

    @NSManaged public var listingName: String
    @NSManaged public var listingDescription: String
    @NSManaged public var listingPrice: String
}
