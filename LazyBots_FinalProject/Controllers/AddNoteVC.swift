//
//  AddNoteVC.swift
//  LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class AddNoteVC: UIViewController , CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
 
    
    
    var dataManager : NSManagedObjectContext!;
    var listArray = [NSManagedObject]();
    var locationManager: CLLocationManager!
    var lat: Double!
    var long: Double!
    var strTitle: String!
    var strDescription: String!
    var timestamp: Int64!
    var pickerData: [String] = [String]()
    var imagePicker = UIImagePickerController()
    var imageData = Data()
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var locationTF: UILabel!
    @IBOutlet weak var descTF: UITextView!
    @IBOutlet weak var AddPhotoBTN: UIButton!
    @IBOutlet weak var RemovePhotoBTN: UIButton!

    @IBOutlet weak var categoryTF: UITextField!
       
       @IBOutlet weak var selectFromList: UIButton!
       
       @IBOutlet weak var categoryPicker: UIPickerView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.RemovePhotoBTN.isHidden =  true
        imageView.isHidden =  true

        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
              dataManager = appDelegate.persistentContainer.viewContext;
              pickerData = ["Work", "Home", "School", "Miscellaneous", "Sports", "Others"]
        
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        categoryPicker.isHidden = true;
        categoryTF.text = "Work"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

           //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
           //tap.cancelsTouchesInView = false

           view.addGestureRecognizer(tap)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        timestamp = Date().currentTimeMillis();

        // Do any additional setup after loading the view.
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        let location = locations.last! as CLLocation

        /* you can use these values*/
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
//        print(self.lat as Any);
//        print(self.long as Any);
//        print(timestamp as Any);
        let geocoder = CLGeocoder()
        var placemark: CLPlacemark?

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
          if error != nil {
//            print("something went horribly wrong")
          }
          if let placemarks = placemarks {
            placemark = placemarks.first
            DispatchQueue.main.async {
//              self.locationTF.text = (placemark?.locality!)
                self.locationTF.text = ""

            }
        }
    }
    }
    
    
    @IBAction func AddBTN(_ sender: UIBarButtonItem) {
         timestamp = Date().currentTimeMillis();
      
        strTitle = titleTF.text;
        strDescription = descTF.text;


        if (strTitle != ""){
            let notesEntity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: dataManager);

            notesEntity.setValue(strTitle, forKey: "title")
            notesEntity.setValue(categoryTF.text, forKey: "category")
            notesEntity.setValue(strDescription, forKey: "desc")
            notesEntity.setValue(timestamp, forKey: "created")

           // print(timestamp)

            notesEntity.setValue(lat, forKey: "latitude")
            notesEntity.setValue(long, forKey: "longitude")
            if !(imageData.isEmpty){
                notesEntity.setValue(imageData, forKey: "imageData")
            }

            do {
                try self.dataManager.save()
                listArray.append(notesEntity);
            } catch {
                print ("Error saving data")
            }
        }else{
           showDialog();
        }

        self.navigationController?.popViewController(animated: true)
       
       }
    
    func showDialog() {
        let alert = UIAlertController(title: "NoteIt", message: "Please add title of the note.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction func Addphoto_BTN(_ sender: UIButton) {
        openDialog();
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//               var imagePicker = UIImagePickerController()
//               imagePicker.delegate = self
//               imagePicker.sourceType = .camera;
//               imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//           }
        
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            print("Button capture")
//            imagePicker.delegate = self
//            imagePicker.sourceType = .savedPhotosAlbum
//            imagePicker.allowsEditing = false
//            present(imagePicker, animated: true, completion: nil)
//        }
    }
    
//    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .photoLibrary;
//            imagePicker.allowsEditing = true
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.isHidden =  false
            self.imageView.image = image
            self.RemovePhotoBTN.isHidden =  false
            self.AddPhotoBTN.isHidden =  true
            imageData = image.pngData()!
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func RemovePhoto_BTN(_ sender: UIButton) {
        self.AddPhotoBTN.isHidden =  false
        self.RemovePhotoBTN.isHidden =  true
        self.imageView.isHidden =  true

    }

    @IBAction func selectCategoryBTN(_ sender: UIButton) {
        print("cat selected")
        self.categoryPicker.isHidden = false;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerData.count
     }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryPicker.isHidden = true;
        categoryTF.text = pickerData[row]
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func openDialog(){
           let alert = UIAlertController(title: "NoteIt!", message: "Pick image from", preferredStyle: .alert)

           

           alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in

                 if UIImagePickerController.isSourceTypeAvailable(.camera) {
                           var imagePicker = UIImagePickerController()
                           imagePicker.delegate = self
                           imagePicker.sourceType = .camera;
                           imagePicker.allowsEditing = false
                        self.present(imagePicker, animated: true, completion: nil)
                       }
           }))
           alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            
              
                     if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                         var imagePicker = UIImagePickerController()
                         imagePicker.delegate = self
                         imagePicker.sourceType = .photoLibrary;
                         imagePicker.allowsEditing = true
                         self.present(imagePicker, animated: true, completion: nil)
                     }
                 
           }))
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           self.present(alert, animated: true)
       }
    
}
