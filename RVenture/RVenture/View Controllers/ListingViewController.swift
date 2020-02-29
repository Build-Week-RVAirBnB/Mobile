//
//  ListingViewController.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import Firebase

class ListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK - Properties
    let listingController = ListingController()
    
    // For UI testing
    let locationName = ["The Shire", "Olympus Mons", "Gotham City"]
    let locationImage = [UIImage(named: "resize-1"),UIImage(named: "resize-2"),UIImage(named: "resize-3")]
    let locationPrice = ["$10/night", "$25/night", "$30/night"]
    let locationDescription = ["Lots of grass", "Interstellar views", "Dark Knight glamping"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let ref = Database.database().reference(fromURL: "https://rventure-a96cc.firebaseio.com/")
//        ref.updateChildValues(["value": 123123])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
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
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.50
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let detailVC = segue.destination as? ListingDetailViewController else { return }
            
            if let detailVC = segue.destination as? ListingDetailViewController {
                detailVC.listingController = listingController
                
            }
        }
    }
    
    // MARK: -Functions
    
    @objc func handleLogout() {
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }

}

