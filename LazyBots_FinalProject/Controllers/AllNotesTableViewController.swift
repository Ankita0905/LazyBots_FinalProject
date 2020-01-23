//
//  AllNotesTableViewController.swift
// LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import UIKit
import CoreData
class AllNotesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var allNotesTV: UITableView!
    
     var dataManager : NSManagedObjectContext!
     var listArray = [NSManagedObject]()
        
     var items: [Note] = [];
     @IBOutlet weak var searchBar: UISearchBar!
    
     var issearch=false;
     var searcharray : [Note] = [];
    
    override func viewDidLoad() {
             super.viewDidLoad()
//        self.allNotesTV.rowHeight = 150
           self.allNotesTV.delegate = self;
           self.allNotesTV.dataSource = self;
        
        self.searchBar.delegate = self;
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//
//                 //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
//                 //tap.cancelsTouchesInView = false
//
//                 view.addGestureRecognizer(tap)
        
        let   appDelegate = UIApplication.shared.delegate as! AppDelegate;
              dataManager = appDelegate.persistentContainer.viewContext;
           self.navigationController?.navigationBar.topItem?.title = "Your Title"
        
//        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
//            self.YOURLABEL.center = CGPoint(x: 0 - self.YOURLABEL.bounds.size.width / 2, y: self.YOURLABEL.center.y)
//        }, completion:  { _ in })
           
         }
   
    override func viewWillAppear(_ animated: Bool) {
        print("view will")
        items = []
        searcharray = []
         self.fetchData()
        self.allNotesTV.reloadData()
    }
    
    
      // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             let   appdelegate = UIApplication.shared.delegate as! AppDelegate;
                                  
                        let context = appdelegate.persistentContainer.viewContext
                        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
           
            
            do
            {
                let x = try context.fetch(fetchRequest)
                let result = x as! [Notes]
                
                print("deleting \(result[indexPath.row])")
                context.delete(result[indexPath.row])
                //print(zotes)
                print(indexPath.row )
                do
                {
                   try context.save()
                }
                catch{
                    
                    //Something shit has already happened.
                }
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                
            }
            catch
            {
                
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    
    func fetchData() {
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes");
                    do {
                        let result = try dataManager.fetch(request);
                        print(result.count)
                            listArray = result as! [NSManagedObject]
                            print(listArray.count)
                            for item in listArray {
                                let nota = Note();
                                
                                nota.titleName = item.value(forKey: "title") as! String
                                nota.description = item.value(forKey: "desc") as! String
                                
                                nota.categoryName = item.value(forKey: "category") as! String
                                
                            
                                nota.createdAt = item.value(forKey: "created") as! Int64
                                
                                
                                nota.lat = item.value(forKey: "latitude") as! Double
                                nota.long = item.value(forKey: "longitude") as! Double
                                if let imageData = item.value(forKey: "imageData") as? Data{
                                   nota.imageData = imageData
                                }
                                items.append(nota)
                        }
                    } catch {
        
                        print("Failed")
                    }
        
        
//    let fetchRequest : NSFetchRequest<NSFetchRequestResult> =
//    NSFetchRequest(entityName: "Notes")
//    do {
//    let result = try dataManager.fetch(fetchRequest)
//    listArray = result as! [NSManagedObject]
//    print(listArray.count)
//    for item in listArray {
//    let product = item.value(forKey: "title") as! String
//
//    items.append(product)
//
//    }
//    } catch {
//    print ("Error retrieving data")
//    }
    }

    
    
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let filtered = items.filter { $0.titleName.lowercased().contains(searchText.lowercased())}
                
        if filtered.count>0
        {
            searcharray  = filtered;
            issearch = true;
        }
        else
        {
            issearch = false;
        }
        self.allNotesTV.reloadData();
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true;
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if issearch
       {  return searcharray.count;
       }else{
          return items.count;
        }
      
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! NotesCell

        if issearch
    {
//      cell.titleLabel?.text =   " \(self.searcharray[indexPath.row].titleName)"
//        cell.titleLabel?.text = " ".self.searcharray[indexPath.row].titleName;
//               cell.descLabel?.text = " ".self.searcharray[indexPath.row].description;
               
//               cell.categoryLabel?.text = " ".self.searcharray[indexPath.row].categoryName;
               cell.titleLabel?.text =   "  \(self.searcharray[indexPath.row].titleName)";
               cell.descLabel?.text =   "  \(self.searcharray[indexPath.row].description)";
               cell.categoryLabel?.text =   "  \(self.searcharray[indexPath.row].categoryName)";
        
        
        
               let unixTimestamp = self.searcharray[indexPath.row].createdAt/1000;
               let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp));
              
           
               let dateFormatter = DateFormatter()
               dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
               dateFormatter.locale = NSLocale.current
               dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
               let strDate = dateFormatter.string(from: date)
                   
               cell.dateLabel?.text = strDate;
        
        }
    else{
            cell.titleLabel?.text =   "  \(self.items[indexPath.row].titleName)";
            cell.descLabel?.text =   "  \(self.items[indexPath.row].description)";
            cell.categoryLabel?.text =   "  \(self.items[indexPath.row].categoryName)";
        
//        cell.titleLabel?.text = self.items[indexPath.row].titleName;
//        cell.descLabel?.text = self.items[indexPath.row].description;
        
//        cell.categoryLabel?.text = self.items[indexPath.row].categoryName;
        
            let unixTimestamp = self.items[indexPath.row].createdAt/1000;
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp));
       
    
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
            
        cell.dateLabel?.text = strDate;
//        cell.descLabel?.text = "description data"
        }
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if issearch == false{
             view.endEditing(true)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewNotesVC") as? ViewNotesVC
            vc?.items = [items[indexPath.row]]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 240
       }
    
    
    
   
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle) {
//        if editingStyle == .delete {
//           print("Deleted")
//
//        }
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath], with: .middle)
//            tableView.endUpdates()
//        }
//    }
    
    
    @objc func dismissKeyboard() {
           //Causes the view (or one of its embedded text fields) to resign the first responder status.
           view.endEditing(true)
       }
  

}
