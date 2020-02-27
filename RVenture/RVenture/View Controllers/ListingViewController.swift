//
//  ListingViewController.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

class ListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK - Properties
    // For UI testing
    let locationName = ["The Shire", "Olympis Mons", "Gotham City"]
    let locationImage = [UIImage(named: "resize-1"),UIImage(named: "resize-2"),UIImage(named: "resize-3")]
    let locationPrice = ["$10/night", "$25/night", "$30/night"]
    let locationDescription = ["Lots of grass", "Interstellar views", "Dark Knight glamping"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Views
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListingCollectionViewCell
        cell.locationName.text = locationName[indexPath.row]
        cell.locationImage.image = locationImage[indexPath.row]
        cell.locationDescription.text = locationDescription[indexPath.row]
        cell.locationPrice.text = locationPrice[indexPath.row]
        
        // Set Listing card border and drop shadow
        cell.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
        
    }
    


}

