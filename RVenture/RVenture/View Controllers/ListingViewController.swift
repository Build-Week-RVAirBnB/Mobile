//
//  ListingViewController.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var addListingButton: UIBarButtonItem!
    
    // MARK - Properties
    let listingController = ListingController()
    
    // For UI testing
//    let locationName = ["The Shire", "Olympus Mons", "Gotham City"]
//    let locationImage = [UIImage(named: "resize-1"),UIImage(named: "resize-2"),UIImage(named: "resize-3")]
//    let locationPrice = ["$10/night", "$25/night", "$30/night"]
//    let locationDescription = ["Lots of grass", "Interstellar views", "Dark Knight glamping"]
//
    
    var listings: [Listing] {
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching listings: \(error)")
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // user not logged in
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
        }
    }

    // MARK: - Views
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListingCollectionViewCell
        
        let listing = listings[indexPath.row]
        
        cell.locationName.text = listing.listingName
        cell.locationImage.image = #imageLiteral(resourceName: "resize-4") // change in production
        cell.locationDescription.text = listing.listingDescription
        cell.locationPrice.text = listing.listingPrice
        
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
    
    // MARK: - Functions
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func addNewListingTapped(_ sender: Any) {
    }
    
}

