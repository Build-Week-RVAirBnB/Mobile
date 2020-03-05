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
    fileprivate func writeListingToDatabase(_ listingRepresention: ListingRepresentation) {
        
        ref.child("listings").child(listingRepresention.identifier.uuidString).setValue(listingRepresention.toAnyObject())
        
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
        let image = imageView.image?.toString()
        let imageString = image
        let date = datePicker.date
        let firesbase = ListingRepresentation(name: name, description: description, price: price, date: date, imagePath: storageImagePath)
        
        self.writeListingToDatabase(firesbase)
        CoreDataStack.shared.mainContext.perform {
            if let listing = self.listing {
                listing.name = name
                listing.price = price
                listing.descriptions = description
                listing.date = date
                listing.image = image
                self.listingController?.sendListingToServer(listing: listing)
            } else {
                let listing = Listing(name: name, descriptions: description, price: price, image: image)
                self.listingController?.sendListingToServer(listing: listing)
            }
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Image Selection
    
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
extension AddListingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let imageData = imageSelected.pngData() else {
            print("Could not get Image PNG Representation")
            return
    }
    // 2. Create a unique image path for image. In the case I am using the googleAppId of my account appended to the interval between 00:00:00 UTC on 1 January 2001 and the current date and time as an Integer and then I append .jpg. You can use whatever you prefer as long as it ends up unique.
        let identifier = listing?.identifier?.uuidString ?? UUID().uuidString

    // 3. Set up metadata with appropriate content type
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    // 4. Show activity indicator
    showNetworkActivityIndicator = true

    // 5. Start upload task
        storageUploadTask = storageRef.child(identifier).putData(imageData, metadata: metadata) { (_, error) in
        // 6. Hide activity indicator because uploading is done with or without an error
        self.showNetworkActivityIndicator = false

        guard error == nil else {
            print("Error uploading: \(error!)")
            return
        }
        self.uploadSuccess(identifier, imageSelected)
    }
}
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
}

}
    
extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
