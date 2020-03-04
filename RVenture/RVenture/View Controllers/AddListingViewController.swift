//
//  AddListingViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 3/1/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

class AddListingViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet weak var listingNameText: UITextField!
    @IBOutlet weak var listingDescriptionText: UITextField!
    @IBOutlet weak var listingPriceText: UITextField!
    @IBOutlet weak var listingLocationText: UITextField!
    @IBOutlet weak var listingDatePicker: UIDatePicker!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var fetchImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var listingController: ListingController?
    
    var listing: Listing? {
        didSet {
            updateViews()
            
             navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonPressed))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
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

    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
      //Saving imageData
        if let imageData = imageView.image?.pngData() {
                  DataBaseHelper.shareInstance.saveImage(data: imageData)
              }
        
        guard let name = listingNameText.text,
            let description = listingDescriptionText.text,
            let priceString = listingPriceText.text,
            let location = listingLocationText.text,
            !name.isEmpty,
            !description.isEmpty,
            !priceString.isEmpty,
            !location.isEmpty,
            let image = listingImage.image,
        
            let price = Double(priceString) else { return }
            
            let date = listingDatePicker.date
        
        
        
         CoreDataStack.shared.mainContext.perform {
            if let listing = self.listing {
                listing.name = name
                listing.price = price
                listing.descriptions = description
                self.listingController?.sendListingToServer(listing: listing)
        } else {
            
                let listing = Listing(name: name, descriptions: description, price: price, date: date)
                self.listingController?.sendListingToServer(listing: listing)
        }
        }
        
    navigationController?.popViewController(animated: true)
        
    }
    @IBAction func fetchImageButtonTapped(_ sender: UIButton) {
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = listing?.name ?? "Create Listing"
        
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
