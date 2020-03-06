//
//  AddListingViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 3/1/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import Foundation

class AddListingViewController: UIViewController {

    @IBOutlet weak var listingNameText: UITextField!
    
    @IBOutlet weak var listingDescriptionText: UITextField!
    
    @IBOutlet weak var listingPriceText: UITextField!
    @IBOutlet weak var listingLocationText: UITextField!
    @IBOutlet weak var listingDatePicker: UIDatePicker!
    @IBOutlet weak var locationImage: UIImageView!
    
    var listing: Listing?
    var listingController: ListingController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonPressed))
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveListing(_ sender: Any) {
        guard let name = listingNameText.text, 
            !name.isEmpty else { return }
        let description = listingDescriptionText.text
        let price = listingPriceText.text
        let location = listingLocationText.text
        let image = locationImage.image?.toString()
        
        if let listing = listing {
            listing.listingName = name
            listing.listingDescription = description
            listing.listingPrice = price
            listingController.sendListingToServer(listing: listing)
        } else {
            let listing = Listing(listingName: name, listingDescription: description!, listingPrice: price!, image: image)
            listingController.sendListingToServer(listing: listing)
        }
        
        // Create new listing

   
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving Listing: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension AddListingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        locationImage.image = userPickedImage
        picker.dismiss(animated: true)
    }
    
}
