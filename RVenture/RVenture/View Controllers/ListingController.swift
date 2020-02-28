//
//  ListingController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

// Testing URL for database
let baseURL = URL(string: "https://rventure-a96cc.firebaseio.com/")!

class ListingController {
    typealias CompletionHandler = (Error?) -> Void
    // For UI testing ; update with CoreData entity
    let locationName = ["The Shire", "Olympus Mons", "Gotham City"]
    let locationImage = [UIImage(named: "resize-1"),UIImage(named: "resize-2"),UIImage(named: "resize-3")]
    let locationPrice = ["$10/night", "$25/night", "$30/night"]
    let locationDescription = ["Lots of grass", "Interstellar views", "Dark Knight glamping"]
    
}
