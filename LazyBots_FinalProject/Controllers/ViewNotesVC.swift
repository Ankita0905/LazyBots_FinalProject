//
//  ViewNotesVC.swift
//  LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import UIKit
import CoreLocation

class ViewNotesVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var notesImg: UIImageView!
    var items: [Note] = [];

    @IBOutlet weak var cityLBL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        "  \(self.items[indexPath.row].titleName)"
//        titleLbl.text = items[0].titleName
         titleLbl.text = "Title:  \(items[0].titleName)"
        categoryLbl.text = "Category:  \(items[0].categoryName)"
        descLbl.text = "Description:  \(items[0].description)"
        
        cityLBL.text = "";
        if let imageData = items[0].imageData as? Data{
           let img = UIImage(data:imageData)
            notesImg.image = img
        }
            
 let location = CLLocation(latitude: items[0].lat, longitude: items[0].long)
//                /* you can use these values*/
//                
//        //        print(self.lat as Any);
//        //        print(self.long as Any);
//        //        print(timestamp as Any);
                let geocoder = CLGeocoder()
                var placemark: CLPlacemark?
//
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                  if error != nil {
        //            print("something went horribly wrong")
                  }
                  if let placemarks = placemarks {
                    placemark = placemarks.first
                    DispatchQueue.main.async {
        //              self.locationTF.text = (placemark?.locality!)
                        self.cityLBL.text = " City: \(placemark?.locality!)"

                    }
                }
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
