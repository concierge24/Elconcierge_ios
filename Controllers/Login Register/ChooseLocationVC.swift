//
//  ChooseLocationVC.swift
//  Sneni
//
//  Created by Mac_Mini17 on 18/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ChooseLocationVC: SplashViewController {
    
    @IBOutlet weak var btnLocFromMap: UIButton! {
        didSet {
            let objTxt = NSAttributedString(string: "Choose location from map", attributes: [
                NSAttributedString.Key.foregroundColor:SKAppType.type.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue
                ])
            btnLocFromMap.setAttributedTitle(objTxt, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}


//extension SplashViewController{
//    
//    
//    func addAnnotations(coords: CLLocationCoordinate2D){
//        
//        
//        let location:CLLocationCoordinate2D = coords
//        
//        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
//        
//        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
//        self.mapView.setRegion(region, animated: true)
//        let annotationPin = AnnotationPin(title: "", coordinate: location, subtitle: "");
//        mapView.addAnnotation(annotationPin);
//        
//    }
//}
