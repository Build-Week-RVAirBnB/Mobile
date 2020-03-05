//
//  Listing+Convenience.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct ListingRepresentation: Equatable, Codable {
    let name: String
    let description: String?
    let price: Double
    var identifier: UUID
    let date: Date?
    let imagePath: String?
    
    init(name: String, description: String?, price: Double, identifier: UUID = UUID(), date: Date? = Date(), imagePath: String?) {
         self.name = name
         self.description = description
         self.price = price
         self.identifier = identifier
         self.date = date
         self.imagePath = imagePath
         
     }
     
     init(snapshot: DataSnapshot) {
         let snapShotValue = snapshot.value as! [String: AnyObject]
         name = snapShotValue["name"] as! String
         description = snapShotValue["description"] as! String
         price = snapShotValue["price"] as! Double
         identifier = snapShotValue["identifier"] as! UUID
         date = snapShotValue["date"] as! Date
         imagePath = snapShotValue["imagePath"] as! String
         
    }
         func toAnyObject() -> Any {
             return [
                 "name": name,
                 "description": description,
                 "price": price,
                 "identifier": identifier,
                 "date": date,
                 "imagePath": imagePath
             ]
     }
    
    
}

struct ListingRepresentations: Codable {
    let results: [ListingRepresentation]
}

