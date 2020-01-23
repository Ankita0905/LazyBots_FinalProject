//
//  ViewController.swift
//  LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

     @IBOutlet weak var userNameTF: UITextField!
        @IBOutlet weak var subitButton: UIButton!
        
        @IBOutlet weak var dataLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            var timeOfDay: String{
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            if hour >= 5 && hour < 12{
                return "Morning"
            } else{
                if hour >= 12 && hour < 17{
                    return "Afternoon"
                }else{
                    if hour >= 17 && hour < 21{
                        return "Evening"
                    }else{
                        return "Night"
                    }
                }
            }
            }
            
            self.dataLabel.isHidden = true
            
            let defaults = UserDefaults.standard
            
            if defaults.object(forKey: Contants.userName) != nil {
                self.subitButton.isHidden = true
                self.userNameTF.isHidden = true
                
                self.dataLabel.text = "Hello, \(defaults.string(forKey: Contants.userName) ?? "") Good \(timeOfDay)"
                self.dataLabel.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.performSegue(withIdentifier: "nextSegue", sender: self)
                }
            }else{
                
            }
            // Do any additional setup after loading the view.
        
           
        }
        @IBAction func submit(_ sender: UIButton) {
            let userName = userNameTF.text;
            let defaults = UserDefaults.standard
            defaults.set(userName, forKey: Contants.userName);
        }
        

        

    }



