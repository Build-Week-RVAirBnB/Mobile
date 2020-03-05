//
//  Listing+Convenience.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation


struct ListingRepresentation: Codable {
    var identifier: String?
    let name: String
    let description: String
    let price: String
}

//struct ListingRepresentations: Codable {
//    let results: [ListingRepresentation]
//}
