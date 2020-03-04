//
//  Listing+Convenience.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation


struct ListingRepresentation: Equatable, Codable {
    let name: String
    let descriptions: String?
    let price: Double
    var identifier: UUID?
    let date: Date?
    
}

struct ListingRepresentations: Codable {
    let results: [ListingRepresentation]
}
