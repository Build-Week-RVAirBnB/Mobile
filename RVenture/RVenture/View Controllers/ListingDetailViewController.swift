//
//  ListingDetailViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData



class ListingDetailViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    @IBOutlet weak var locationPrice: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    
     var listingController: ListingController?
    
    var listing: Listing? {
        didSet {
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
        
        func updateViews() {
            guard isViewLoaded else { return }
                title = listing?.listingName ?? "RVenture"
            locationImage.image = listing?.image?.toImage() ?? #imageLiteral(resourceName: "resize-2")
                locationName.text = listing?.listingName ?? "RVenture"
                locationDescription.text = listing?.listingDescription ?? "Start your RVenture"
                locationPrice.text = listing?.listingPrice ?? "Afforable alternative"
                datesLabel.text = "\(listing?.date ?? Date()) - \(listing?.dateTo ?? Date())"
    }
}
