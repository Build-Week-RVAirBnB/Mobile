//
//  ListingDetailViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

protocol ListingsDetailViewControllerDelegate: class {
    func fetchData()
}

class ListingDetailViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    @IBOutlet weak var locationPrice: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    
     var listingController: ListingController?
    
    weak var delegate: ListingsDetailViewControllerDelegate?
    
    var listing: Listing? {
        didSet {
            updateViews()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        delegate?.fetchData()
    }
        
        func updateViews() {
            guard isViewLoaded else { return }
            if let listing = listing {
                title = listing.listingName
                locationImage.image = listing.image?.toImage()
                locationName.text = listing.listingName
                locationDescription.text = listing.listingDescription
                locationPrice.text = listing.listingPrice
                datesLabel.text = "\(listing.date ?? Date()) - \(listing.dateTo ?? Date())"
            } else {
                title = listing?.listingName ?? "RVenture"
                locationName.text = "Idaho, USA"
                locationDescription.text = "Your ultimate getaway"
                locationPrice.text = "Afforable alternative"
                datesLabel.text = "Start your RVenture"
            }
    }
}
