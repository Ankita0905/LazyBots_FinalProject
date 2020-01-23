//
//  Notes.swift
//  LazyBots_FinalProject
//
//  Created by Ankita Jain on 2020-01-22.
//  Copyright © 2020 Ankita Jain. All rights reserved.
//

import Foundation

class Note{
    
    var titleName : String;
    var description : String;
    var createdAt : Int64;
    var lat : Double;
    var long : Double;
    var categoryName : String;
    var imageData: Data;
    
    init() {
      
        self.titleName = String();
        self.description = String();
        self.categoryName = String();
        
        self.lat = Double();
        self.long = Double();
        self.createdAt = Int64();
        self.imageData = Data();
    }
    
}

