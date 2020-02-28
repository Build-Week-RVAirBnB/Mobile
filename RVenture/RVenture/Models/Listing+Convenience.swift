//
//  Listing+Convenience.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation

struct ListingRepresentation: Equatable, Codable {
    let listId: UUID = UUID()
    let listName: String
    let listDescription: String?
    let listPrice: Double
    let listPhoto: String
    let listDates: Date
    let listBookings: [UUID?]
    
}

struct ListingRepresentations: Codable {
    let results: [ListingRepresentation]
}
