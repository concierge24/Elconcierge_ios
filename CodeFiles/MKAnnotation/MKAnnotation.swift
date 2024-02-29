//
//  MKAnnotation.swift
//  Sneni
//
//  Created by Mac_Mini17 on 28/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class AnnotationPin: NSObject,MKAnnotation {
    
    var title : String?
    var subTit : String?
    var coordinate : CLLocationCoordinate2D
    
    init(title:String,coordinate : CLLocationCoordinate2D,subtitle:String){
        
        self.title = title;
        self.coordinate = coordinate;
        self.subTit = subtitle;
        
    }
    
}
