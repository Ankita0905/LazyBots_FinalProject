//
//  MapVCViewController.swift
// LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class MapVCViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
     var dataManager : NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    var items: [Note] = [];
    var annonationCollection = [MKAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.delegate = self
//            let zoomArea = MKCoordinateRegion(center:
//        self.mapView.userLocation.coordinate, span:
//                  MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//              self.mapView.setRegion(zoomArea, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        dataManager = appDelegate.persistentContainer.viewContext;
        
         
        fetchData();
      
    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
//    {
//        let zoomArea = MKCoordinateRegion(center:
//        self.mapView.userLocation.coordinate, span:
//            MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//        self.mapView.setRegion(zoomArea, animated: true)
//    }
     func fetchData() {
             let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes");
                        do {
                            let result = try dataManager.fetch(request);
                            print(result.count)
                                listArray = result as! [NSManagedObject]
                                print(listArray.count)
                                for item in listArray {
                                    let noteModal = Note();
                                    
                                noteModal.titleName = item.value(forKey: "title") as! String
                                noteModal.description = item.value(forKey: "desc") as! String
                                noteModal.lat = item.value(forKey: "latitude") as! Double
                                noteModal.long = item.value(forKey: "longitude") as! Double
                                items.append(noteModal)
                            }
                        } catch {
//                            print("Failed")
                        }
        
        for (index, i) in items.enumerated() {
        
//            if (index == items.count-1){
                print(index)
                print(i.lat)
                print(i.long)
                let location = CLLocation(latitude: i.lat, longitude: i.long)
                let myAnnotation = MKPointAnnotation()
                myAnnotation.coordinate = location.coordinate
                myAnnotation.title = " \(i.titleName) "
                annonationCollection.append(myAnnotation);
                self.mapView.addAnnotation(myAnnotation)
//                mapView.showAnnotations(mapView.annotations, animated: true)
//            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//         fetchData();
//       guard let annotation = annotation as? Artwork else { return nil }

       // 3
       let identifier = "marker"
       var view: MKMarkerAnnotationView
       // 4
       if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
         as? MKMarkerAnnotationView {

        dequeuedView.annotation = annonationCollection as! MKAnnotation;
         view = dequeuedView
       } else {
         // 5
         view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
         view.canShowCallout = true
//         view.calloutOffset = CGPoint(x: -5, y: 5)
         view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
       }
       return view
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
