//
//  ListingViewController.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 2/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CoreData

class ListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var addListingButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK - Properties
    private let listingController = ListingController()
    private var blockOperations: [BlockOperation] = []

    lazy var fetchedResultsController: NSFetchedResultsController<Listing> = {
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "listingName", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "listingName",
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
          collectionView.refreshControl = refreshControl

        // user not logged in
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
        }
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        listingController.fetchListingsFromServer { (_) in
            refreshControl.endRefreshing()
        }
    }

    // MARK: - Views
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListingCollectionViewCell
        
        let listing = fetchedResultsController.object(at: indexPath)
        
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
            let selectedIndexPath = sender as? NSIndexPath
            let detailVC = segue.destination as? ListingDetailViewController
        }
        
        if let addVC = segue.destination as? AddListingViewController {
            addVC.listingController = listingController
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

extension ListingViewController: NSFetchedResultsControllerDelegate {
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            
        if type == NSFetchedResultsChangeType.insert {
                print("Insert Object: \(newIndexPath)")
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.insertItems(at: [(newIndexPath! as IndexPath)])
                        }
                    })
                )
            }
        else if type == NSFetchedResultsChangeType.update {
                print("Update Object: \(indexPath)")
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.reloadItems(at: [(indexPath! as IndexPath)])
                        }
                    })
                )
            }
        else if type == NSFetchedResultsChangeType.move {
                print("Move Object: \(indexPath)")
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.moveItem(at: indexPath! as IndexPath, to: newIndexPath! as IndexPath)
                        }
                    })
                )
            }
        else if type == NSFetchedResultsChangeType.delete {
                print("Delete Object: \(indexPath)")
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.deleteItems(at: [(indexPath! as IndexPath)])
                        }
                    })
                )
            }
        }

    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
            
        if type == NSFetchedResultsChangeType.insert {
                print("Insert Section: \(sectionIndex)")
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    })
                )
            }
        else if type == NSFetchedResultsChangeType.update {
                print("Update Section: \(sectionIndex)")
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    })
                )
            }
        else if type == NSFetchedResultsChangeType.delete {
                print("Delete Section: \(sectionIndex)")
                
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    })
                )
            }
        }

    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
            collectionView!.performBatchUpdates({ () -> Void in
                for operation: BlockOperation in self.blockOperations {
                    operation.start()
                }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepingCapacity: false)
            })
        }

}
