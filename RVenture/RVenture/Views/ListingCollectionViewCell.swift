//
//  ListingCollectionViewCell.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/27/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    @IBOutlet weak var locationPrice: UILabel!
    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    
    //MARK: - Properties
    var listing: Listing? {
        didSet {
            updateViews()
            
        }
    }
    
    //MARK: - Functions
    
    func updateViews() {
        guard let listing = listing,
            let uuid = listing.identifier?.uuidString else { return }
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
        
        locationName.text = listing.listingName
        locationImage.image = listing.image?.toImage()
        locationDescription.text = listing.listingDescription
        locationPrice.text = listing.listingPrice
        dateFromLabel.text = listing.date?.toString(dateFormat: "MM/dd/yyyy")
        dateToLabel.text = listing.dateTo?.toString(dateFormat: "MM/dd/yyyy")
        
        
    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    
}
