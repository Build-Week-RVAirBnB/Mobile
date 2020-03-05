//
//  DatabaseHelper.swift
//  RVenture
//
//  Created by Gerardo Hernandez on 3/4/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import CoreData

//class DataBaseHelper {
//    
//    static let shareInstance = DataBaseHelper()
//    let context = CoreDataStack.shared.container.viewContext
//    let moc = CoreDataStack.shared.container
//    
//    func saveImage(data: Data) {
//        let imageInstance =  Image(context: context)
//        imageInstance.img = data
//            
//        do {
//            try context.save()
//            print("Image is saved")
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func fetchImage() -> [Image] {
//        var fetchingImage = [Image]()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
//        
//        do {
//            fetchingImage = try context.fetch(fetchRequest) as! [Image]
//        } catch {
//            print("Error while fetching the image")
//        }
//        
//        return fetchingImage
//    }
//}

