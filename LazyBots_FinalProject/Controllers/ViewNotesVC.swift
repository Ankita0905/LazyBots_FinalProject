//
//  ViewNotesVC.swift
//  LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewNotesVC: UIViewController, AVAudioPlayerDelegate  {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var notesImg: UIImageView!
      @IBOutlet weak var play_btn_ref: UIButton!
    var items: [Note] = [];
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
   // var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false

    
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
                
            }
            if let placemarks = placemarks {
                placemark = placemarks.first
                if let locality = placemark?.locality {
                    
                    DispatchQueue.main.async {
                        //              self.locationTF.text = (placemark?.locality!)
                        self.cityLBL.text = " City: \(locality)"
                        
                    }
                }
                
            }
        }
    }
    func prepare_play()
    {
        do
        {
            let url = URL(string : items[0].audioString)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    @IBAction func play_recording(_ sender: Any)
       {
           if(isPlaying)
           {
               audioPlayer.stop()
              // record_btn_ref.isEnabled = true
               play_btn_ref.setTitle("Play", for: .normal)
               isPlaying = false
           }
           else
           {
             let url = URL(string : items[0].audioString)
            print(" hello : \(items[0].audioString)\n\n\n\n\n\n\n")
            if FileManager.default.fileExists(atPath: url!.path)
               {
                 //  record_btn_ref.isEnabled = false
                   play_btn_ref.setTitle("pause", for: .normal)
                   prepare_play()
                   audioPlayer.play()
                   isPlaying = true
               }
               else
               {
                   display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
               }
           }
       }
       
      
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
       {
           let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
           ac.addAction(UIAlertAction(title: action_title, style: .default)
           {
               (result : UIAlertAction) -> Void in
           _ = self.navigationController?.popViewController(animated: true)
           })
           present(ac, animated: true)
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
