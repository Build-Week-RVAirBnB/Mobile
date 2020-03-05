//
//  AddListingViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 3/1/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

class AddListingViewController: UIViewController {

    @IBOutlet weak var listingNameText: UITextField!
    
    @IBOutlet weak var listingDescriptionText: UITextField!
    
    @IBOutlet weak var listingPriceText: UITextField!
    @IBOutlet weak var listingLocationText: UITextField!
    @IBOutlet weak var listingDatePicker: UIDatePicker!
    @IBOutlet weak var locationImage: UIImageView!
    
    var listing: Listing?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveListing(_ sender: Any) {
        guard let name = listingNameText.text,
            !name.isEmpty else { return }
        let description = listingDescriptionText.text
        let price = listingPriceText.text
        let location = listingLocationText.text
        
        // Create new listing
        let _ = Listing(listingName: name, listingDescription: description!, listingPrice: price!)
   
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving Listing: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
