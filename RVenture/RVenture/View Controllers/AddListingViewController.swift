//
//  AddListingViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 3/1/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import Firebase

class AddListingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var listingController: ListingController?
    
    var ref: DatabaseReference!
    
    var listing: Listing? {
        didSet {
            updateViews()
        }
    }
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        ref = Database.database().reference()
    }
    
    //MARK: - Functions
    @objc func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = userPickedImage
        
        picker.dismiss(animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        //Saving imageData
    
         guard let name = nameTextField.text,
        let priceString = priceTextField.text,
            let description = descriptionTextField.text,
            !name.isEmpty,
            !priceString.isEmpty,
            datePicker.date > Date(),
            let price = Double(priceString) else { return }
        
//        let description = listing?.descriptions ?? ""
        
        CoreDataStack.shared.mainContext.perform {
            if let listing = self.listing {
                listing.name = name
                listing.price = price
                listing.descriptions = description
                if let imageData = self.imageView.image?.pngData() {
                         DataBaseHelper.shareInstance.saveImage(data: imageData)
                     }
//                listing.date = date
                self.listingController?.sendListingToServer(listing: listing)
                print("sent \(listing) to server")
            } else {
                
                let listing = Listing(name: name, descriptions: description, price: price)
                print("sent \(listing) else to server")
                self.listingController?.sendListingToServer(listing: listing)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func fetchImageButtonTapped(_ sender: UIButton) {
//        let arr = DataBaseHelper.shareInstance.fetchImage()
//
//        if arr.indices.contains(0) {
//            imageView.image = UIImage(data: arr[0].img!)
//        }
//    }
    
    //MARK: - Views
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = listing?.name ?? "Create Listing"
        
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonPressed))
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
