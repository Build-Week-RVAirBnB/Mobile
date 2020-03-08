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
    @IBOutlet weak var listingPriceText: UITextField!
    @IBOutlet weak var listingDescriptionTextView: UITextView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    
    var listing: Listing? {
        didSet {
            updateViews()
        }
    }
    var listingController: ListingController!
    
    private var fromDatePicker: UIDatePicker?
    private var toDatePicker: UIDatePicker?
   
    var dateFormatter: DateFormatter {
           let formatter = DateFormatter()
            formatter.dateFormat = .some("MM/dd/yyyy")
           return formatter
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
       
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
    

    @IBAction func saveListing(_ sender: Any) {
        guard let name = listingNameText.text,
            let fromDate = fromDatePicker?.date,
            let dateTo = toDatePicker?.date,
            let description = listingDescriptionTextView.text,
            let price = listingPriceText.text,
            !name.isEmpty else { return }
        guard let image = locationImage?.image else { return }
        guard let databaseImage = locationImage.image?.toString() else { return }
        
        let date = fromDate
        let dateTolisting = dateTo

        CoreDataStack.shared.mainContext.perform {
            if let listing = self.listing {
                listing.listingName = name
//                listing.listingDescription = description
                listing.listingPrice = price
                listing.image = databaseImage
//                listing.date = date
                self.listingController.sendListingToServer(listing: listing)
                self.listingController.saveImage(image: image)
            } else {
                let listing = Listing(listingName: name, listingDescription: description, listingPrice: price, date: date, dateTo: dateTolisting, image: image.toString())
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
            listingDescriptionTextView.text = listing.description
            fromDateTextField.text = listing.date?.toString(dateFormat: "MM/dd/yyyy")
            toDateTextField.text = listing.dateTo?.toString(dateFormat: "MM/dd/yyyy")
        } else {
            navigationItem.title = "Create Listing"


        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonPressed))
        
        fromDatePicker = UIDatePicker()
        fromDatePicker?.datePickerMode = .date
        //24hrs from now
        fromDatePicker?.date = Date(timeIntervalSinceNow: 86400)
        fromDatePicker?.addTarget(self, action: #selector(fromDateChanged(fromDatePicker:)), for: .valueChanged)
        fromDateTextField.inputView = fromDatePicker
        
        toDatePicker = UIDatePicker()
        toDatePicker?.datePickerMode = .date
         fromDatePicker?.date = Date(timeIntervalSinceNow: 86400)
        toDatePicker?.addTarget(self, action: #selector(toDateChanged(toDatePicker:)), for: .valueChanged)
        toDateTextField.inputView = toDatePicker
        
        let toolBar = UIToolbar()
                 toolBar.barStyle = UIBarStyle.default
                 toolBar.isTranslucent = true
                 toolBar.tintColor = #colorLiteral(red: 0.224999994, green: 0.3549999893, blue: 1, alpha: 1)
                 toolBar.sizeToFit()


                 let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
                 toolBar.setItems([doneButton], animated: true)


                 toolBar.isUserInteractionEnabled = true
                   
           fromDateTextField.inputAccessoryView = toolBar
           toDateTextField.inputAccessoryView = toolBar
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddListingViewController.viewTapped(gestureRecognizer:)))
//        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func fromDateChanged(fromDatePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        fromDateTextField.text = dateFormatter.string(from: fromDatePicker.date)
//        view.endEditing(true)
        
    }
    @objc func toDateChanged(toDatePicker: UIDatePicker) {
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MM/dd/yyyy"
           toDateTextField.text = dateFormatter.string(from: toDatePicker.date)
//           view.endEditing(true)
           
       }
    
}


extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension String {
    func toDate(withFormat format: String = "MM/dd/yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure()
        }
        return date
    }

}
extension Date {
    func toString(dateFormat format : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
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
