//
//  CoreDataManager.swift
//  Mover Bol
//
//  Created by Jaydip on 06/05/19.
//  Copyright © 2019 Jaydip Savaliya. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    
    //MARK:- Variable
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var context = persistentContainer.viewContext
    
    //MARK:- Init Funtion
    private init() {}
    
    func save () {
        if context.hasChanges {
            do {
                try context.save()
                print("saved coredata successfully")
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func saveUserData(tblName: String, success: @escaping (_ data: NSManagedObject) -> Void){
        let entity = NSEntityDescription.entity(forEntityName: tblName, in: context)
        let data = NSManagedObject(entity: entity!, insertInto: context)
        success(data)
    }
    
    
    func fetchData(tblName: String, success: @escaping (_ isSuccess: Bool, _ data: Any?) -> Void) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tblName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let data = convertToJSONArray(data: result as! [NSManagedObject])
            success(true,data)
        } catch {
            print("Error while fetching data")
            success(false,nil)
        }
    }
    
    func updateData(tblName: String, kName: String, kValue: String, success: @escaping (_ isSuccess: Bool,_ result:NSManagedObject?) -> Void){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tblName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate.init(format: "\(kName) = %@", "\(kValue)")
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let objToUpdate = result.first as? NSManagedObject else {
                print("No Record Found.")
                return
            }
            print("Update successfully")
            success(true,objToUpdate)
        } catch let error {
            print("error while updating data:\(error)")
            success(false,nil)
        }
    }
    
    func deleteAllData(_ tblName:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tblName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
            print("\(tblName) deleted.")
        } catch let error {
            print("error while delete data:\(error)")
        }
        save()
    }
    
    func deleteSpecificRecord(tblName:String,kName: String,kValue: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tblName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate.init(format: "\(kName) = %@", "\(kValue)")
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let objToDelete = result.first as? NSManagedObject else {
                print("No Record Found.")
                return
            }
            if result.count > 1 {
                for object in result {
                    guard let objectData = object as? NSManagedObject else {continue}
                    context.delete(objectData)
                }
                print("there is \(result.count) record deleted.")
            }else{
                context.delete(objToDelete)
                print("1 record deleted.")
            }
        } catch let error {
            print("error while delete data:\(error)")
        }
        save()
    }
    
    //convert NSManagedObject to json array
    func convertToJSONArray(data: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in data {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
}


extension UIViewController {

    func prepareImageForSaving(image:UIImage) -> Data? {
        // create Data from UIImage
        guard let imageData = image.jpegData(compressionQuality: 1) else {
                // handle failed conversion
                print("jpg error")
                return nil
        }
        return imageData
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
//use of all function

// save data
//            let manager = CoreDataManager.shared
//            CoreDataManager.shared.saveUserData(tblName: "TblSignUp") { (data) in
//                data.setValue(self.userData.profilePic, forKey: "profilepic")
//
//                CoreDataManager.shared.save()
//            }
//

//Fetch data
//CoreDataManager.shared.fetchData(tblName: "TblSignUp") { (isFetch, data) in
//    if isFetch {
//        for obj in data as? [[String:Any]] ?? []{
//            print(obj["name"] as? String ?? "" )
//        }
//    }
//}

// Delete Operation
//      CoreDataManager.shared.deleteAllData(_ tblName:"tblName")

//      CoreDataManager.shared.deleteSpecificRecord(tblName: "TblSignUp", kName: "name", kValue: "Jaydip            savaliya")

// Update Operation

//        CoreDataManager.shared.updateData(tblName: "TblSignUp", kName: "name", kValue: "Jaydip Savaliya") { (isSuccess, result) in
//            if isSuccess {
//                result?.setValue("Jaydip Savaliya", forKey: "name")
//                result?.setValue("8469496658", forKey: "mobileno")
//                CoreDataManager.shared.save()
//            }
//        }
