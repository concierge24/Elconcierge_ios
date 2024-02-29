//
//  GoogleAutoComplete.swift
//  Wethaq
//
//  Created by OSX on 21/02/18.
//  Copyright © 2018 codebrew. All rights reserved.
//

import UIKit
import GooglePlaces

typealias LocationSelected = (_ place: GMSPlace) -> ()
typealias Cancelled = () -> ()

class GoogleAutoCompleteDelegate: NSObject, GMSAutocompleteViewControllerDelegate {
    
    //MARK: - Variables
    var placePickerVC: GMSAutocompleteViewController?
    var locationSelected: LocationSelected?
    var cancelled:Cancelled?
    
    
    init(placePickerVC: GMSAutocompleteViewController) {
        
        self.placePickerVC = placePickerVC
        
    }
    
    //MARK: - Show AutoComplete
    func show(selectedLocation: @escaping LocationSelected, cancelled: @escaping Cancelled){
      
        self.locationSelected = selectedLocation
        self.cancelled = cancelled
    }
    
    //MARK: - Selection Action
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      self.placePickerVC?.dismissVC(completion: nil)
      if let selected = self.locationSelected {
        selected(place)
      }
        
    }
    
    //MARK: - Cancelled Action
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        if let cancelled = self.cancelled {
            cancelled()
        }
        placePickerVC?.dismissVC(completion: nil)
    }
    
    //MARK: - Failed
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint("Error: " , error.localizedDescription)
    }
}
