//
//  AddListingViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 3/1/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import Foundation

class AddListingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var listingNameText: UITextField!
    
    @IBOutlet weak var listingDescriptionText: UITextField!
    
    @IBOutlet weak var listingPriceText: UITextField!
    @IBOutlet weak var listingLocationText: UITextField!
    @IBOutlet weak var listingDatePicker: UIDatePicker!
    @IBOutlet weak var locationImage: UIImageView!
    
    var listing: Listing? {
        didSet {
            updateViews()
        }
    }
    var listingController: ListingController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonPressed))
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
               guard let userPickedImage = info[.editedImage] as? UIImage else { return }
               locationImage.image = userPickedImage
                
        let moc = CoreDataStack.shared.mainContext
        moc.perform {
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving image: \(error)")
        }
        }
               picker.dismiss(animated: true)
           }
    
//    func saveImage(data: Data) {
//        let imageInstance = locationImage
//       var img = imageInstance?.image?.toData()
//        img = data
//        let moc = CoreDataStack.shared.mainContext
//        moc.performAndWait {
//            do {
//                try moc.save()
//                print("Image is saved")
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
    

    @IBAction func saveListing(_ sender: Any) {
        guard let name = listingNameText.text,
        listingDatePicker.date > Date(),
            let description = listingDescriptionText.text,
            let price = listingPriceText.text,
            !name.isEmpty else { return }
        
        guard let image = locationImage?.image else { return }
        guard let databaseImage = locationImage.image?.toString() else { return }
        let date = listingDatePicker.date
     
        CoreDataStack.shared.mainContext.perform {
            if let listing = self.listing {
                listing.listingName = name
                listing.listingDescription = description
                listing.listingPrice = price
                listing.image = databaseImage
                listing.date = date
                self.listingController.sendListingToServer(listing: listing)
                self.listingController.saveImage(image: image)
            } else {
                let listing = Listing(listingName: name, listingDescription: description, listingPrice: price, date: date, image: image.toString())
                self.listingController.sendListingToServer(listing: listing)
            }
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
    
    
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        if let listing = listing {
            navigationItem.title = listing.listingName
            listingNameText.text = listing.listingName
            listingDescriptionText.text = listing.description
            listingDatePicker.date = listing.date ?? Date()
            listingPriceText.text = listing.listingPrice
            listingDatePicker.datePickerMode = .date
        } else {
            navigationItem.title = "Create Listing"
            listingDatePicker.date = Date(timeIntervalSinceNow: 86400)
        }
    }
    
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

//
//extension AddListingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
//        locationImage.image = userPickedImage
//
//        picker.dismiss(animated: true)
//    }
//
//}
