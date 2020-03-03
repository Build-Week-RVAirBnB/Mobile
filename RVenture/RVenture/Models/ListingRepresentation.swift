//
//  Listing+Convenience.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation


struct ListingRepresentation: Equatable, Codable {
    var listingId: UUID?
    let listingName: String
    let listingDescription: String?
    let listingLocation: String
    let listingPrice: Double
    let listingPhoto: String
    let listingDate: Date
    
}

struct ListingRepresentations: Codable {
    let results: [ListingRepresentation]
}
