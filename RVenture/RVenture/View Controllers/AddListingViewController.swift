//
//  AddListingViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 3/1/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class AddListingViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var listingController: ListingController?
    fileprivate var picker = UIImagePickerController()
    fileprivate var ref: DatabaseReference!
    fileprivate var storageImagePath = ""
    fileprivate var storageRef: StorageReference!
    fileprivate var storageUploadTask: StorageUploadTask!
    
    var listing: Listing? {
        didSet {
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
       storageRef = Storage.storage().reference()
        ref = Database.database().reference()
        

        picker.delegate = self
    }
    
    //Setup for activity indicator to to be shown when uploading image
     fileprivate var showNetworkActivityIndicator = false {
         didSet {
             UIApplication.shared.isNetworkActivityIndicatorVisible = showNetworkActivityIndicator
         }
     }
    
    
    //MARK: - Views
        private func updateViews() {
            guard isViewLoaded else { return }
            title = listing?.name ?? "Create Listing"
            datePicker.date = Date()
            datePicker.datePickerMode = .date
           
        }
    
    //MARK: - Functions
    
    fileprivate func writeListingToDatabase(_ listing: ListingRepresentation) {
        ref.child("listings").child(listing.identifier.uuidString).setValue(listing.toAnyObject())
        
    }
    
    fileprivate func uploadSuccess(_ storagePath: String, _ storageImage: UIImage) {
        
        //update the listing image view with the selected image
        imageView.image = storageImage
        //Updated global varibale for the storage path for the selected image
        storageImagePath = storagePath
        //Enable savebutton and change its color
        saveButton.isEnabled = true
        saveButton.backgroundColor = .green
        
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
        let date = datePicker.date
        
        let listing = ListingRepresentation(name: name, description: description, price: price, date: date, imagePath: storageImagePath)
        
        writeListingToDatabase(listing)
        
         navigationController?.popViewController(animated: true)
        
//        let description = listing?.descriptions ?? ""
        
        CoreDataStack.shared.mainContext.perform {
            if let listing = self.listing {
                listing.name = name
                listing.price = price
                listing.descriptions = description
                listing.date = date
//                listing.date = date
        self.listingController?.sendListingToServer(listing: listing)
            } else {
                let listing = Listing(name: name, descriptions: description, price: price)
                self.listingController?.sendListingToServer(listing: listing)
            }
        }
        
    }
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                   picker.sourceType = .camera
               } else {
                   picker.sourceType = .photoLibrary
               }
               present(picker, animated: true, completion: nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingToParent {
            showNetworkActivityIndicator = false
            storageUploadTask?.cancel()
        }
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddListingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.5) else {
                print("Could not get Image JPEG Representation")
                return}
                
                let imagePath = "\(listing?.identifier ?? UUID()).jpg"
                
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                
                self.showNetworkActivityIndicator = true
                
                storageUploadTask = storageRef.child(imagePath).putData(imageData, metadata: metaData) { (_, error) in
                
                    self.showNetworkActivityIndicator = false
                    
                guard error == nil else {
                    print("Error uploading image: \(error!)")
                    return
                }
                
                    self.uploadSuccess(imagePath, image)
            }
        }
        
        func imagePickerContollerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
}
