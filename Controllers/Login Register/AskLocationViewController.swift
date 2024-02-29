//
//  AskLocationViewController.swift
//  Sneni
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import CoreLocation

class AskLocationViewController: UIViewController {
    
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet weak var chooseLocation_button: UIButton! {
        didSet{
            chooseLocation_button.backgroundColor = SKAppType.type.color
            chooseLocation_button.isHidden = true
        }
    }
    @IBOutlet weak var backgroundImage_imageView: UIImageView! {
        didSet {
            let locationGif = UIImage.gifImageWithName("location")
            if APIConstants.defaultAgentCode != "lconcierge_0676"{
                backgroundImage_imageView.image = locationGif
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.sharedInstance.startTrackingUser()
        if GDataSingleton.isAskLocationDone == true {
            self.moveToSplashVc()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotFetched), name: NSNotification.Name("LocationNotFetched"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.locationFetched), name: NSNotification.Name("LocationFetched"), object: nil)
        }

    }
    
    @IBAction func chooseLocation_buttonAction(_ sender: Any) {
        
        let vc = NewLocationViewController.getVC(.main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.fromStarting = true
        vc.completionBlock = { data in
            //guard let self = self else { return }
            if LocationSingleton.sharedInstance.searchedAddress != nil {
                self.locationFetched()
            }
            else if let value = data as? Bool,value == true {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
            }
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func locationNotFetched() {
        let lat = AppSettings.shared.defaultAddress?.first?.latitude ?? 17.565603599999999
        let lng = AppSettings.shared.defaultAddress?.first?.longitude ?? 44.2289441
        LocationManager.sharedInstance.currentLocation?.currentLat = lat.toString
        LocationManager.sharedInstance.currentLocation?.currentLng = lng.toString
        
        let location = CLLocation(latitude: lat, longitude: lng)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if let placeMark = placemarks?.first {
                LocationSingleton.sharedInstance.selectedAddress = placeMark
                self.locationFetched()
                //NotificationCenter.default.post(name: NSNotification.Name("LocationFetched"), object: nil)
            }
            else {
                GDataSingleton.isAskLocationDone = false
                self.chooseLocation_button.isHidden = false
            }
        }
       
    }
    
    @objc func locationFetched() {
        GDataSingleton.isAskLocationDone = true
        self.moveToSplashVc()
    }
    
    func moveToSplashVc() {
        let vc = StoryboardScene.Splash.instantiateSplashViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}  

//MARK:- UIViewControllerTransitioningDelegate
extension AskLocationViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
