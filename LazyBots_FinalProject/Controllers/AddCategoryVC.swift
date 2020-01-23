//
//  AddCategoryVC.swift
// LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddCategoryVC : UIViewController {

    @IBOutlet weak var categoryTitleTF: UITextField!
    
    var dataManager : NSManagedObjectContext!;
    var listArray = [NSManagedObject]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        dataManager = appDelegate.persistentContainer.viewContext;
    }
    
    @IBAction func addCategoryBTN(_ sender: UIButton) {
        let catEntity = NSEntityDescription.insertNewObject(forEntityName: "Category", into: dataManager);
        
            catEntity.setValue(categoryTitleTF.text!, forKey: "categoryName")
            catEntity.setValue(categoryTitleTF.text!, forKey: "categoryName")
            catEntity.setValue(1, forKey: "catergoryID")
            
        do {
        try self.dataManager.save()
            listArray.append(catEntity);
        } catch {
        print ("Error saving data")
            }
        categoryTitleTF.text?.removeAll();
    }
    
//        @IBAction func showCategoryName(_ sender: UIButton) {
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category");
//
//            do {
//                let result = try dataManager.fetch(request);
//                for data in result as! [NSManagedObject] {
//                    print(data.value(forKey: "categoryName") as! String);
//
//                    catlistL.text = data.value(forKey: "categoryName") as! String;
//              }
//
//            } catch {
//
//                print("Failed")
//            }
//
//        }
//    }

}


