//
//  GooglePlaceDataSource.swift
//  Buraq24
//
//  Created by MANINDER on 03/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

import GooglePlaces
import SwiftyJSON


typealias  responseAPI = (_ response : [GMSAutocompletePrediction]) -> ()
typealias  responsePlaceDetailsAPI = (_ response : GMSPlace?) -> ()
typealias  ResponseAutoComplete = (_ response : GMSPlace?) -> ()


class GooglePlaceDataSource: NSObject {
    
    var responseListener : responseAPI?
    var searchTextField : UITextField?
    var responseAutoComplete: ResponseAutoComplete?
    
    static let sharedInstance = GooglePlaceDataSource()
    
    init (txtField: UITextField? ,resListener: responseAPI?) {
        
        super.init()
        
        searchTextField = txtField
        searchTextField?.addTarget(self, action:  #selector(getPlaces), for: .editingChanged)
        
       responseListener = resListener
    }
    
    override init() {
        super.init()
    }
    
    @objc func getPlaces() {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "in|country:lk|country:nz"

        GMSPlacesClient.shared().autocompleteQuery(/(searchTextField?.text), bounds: nil, filter: filter) { [weak self](results, error) -> Void in
            if let newResults = results {
                self?.responseListener!(newResults)
            }else{
                debugPrint(error?.localizedDescription)
                self?.responseListener!([GMSAutocompletePrediction]())
            }
        }
    }
    
    class func placeDetails(placeID: String , responseListener: @escaping responsePlaceDetailsAPI) {
        
        GMSPlacesClient.shared().lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
        //    print("Place address \(place.formattedAddress)")
            responseListener(place)
            

        })
        
        
    }
    
    func showAutocomplete(completion: @escaping ResponseAutoComplete) {
        
        responseAutoComplete = completion
        
        let autocompleteController = GMSAutocompleteViewController()
        
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        //filter.country = "CA"
        filter.country = Locale.current.regionCode //UDSingleton.shared.userData?.userDetails?.user?.currentCountryCode //"in|country:lk|country:nz"
        autocompleteController.autocompleteFilter = filter
        ez.topMostVC?.present(autocompleteController, animated: true, completion: {
            if let searchBar = (autocompleteController.view.subviews
            .flatMap { $0.subviews }
            .flatMap { $0.subviews }
            .flatMap { $0.subviews }
            .filter { $0 == $0 as? UISearchBar}).first as? UISearchBar {
                     searchBar.placeholder = "Search"
             }
        })
    }
}



extension GooglePlaceDataSource : GMSAutocompleteViewControllerDelegate {
    
    //MARK:- GMSAutocompleteViewControllerDelegate
    
        // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
           
        ez.topMostVC?.dismiss(animated: true, completion: nil)
            
        if let block = self.responseAutoComplete {
            block(place)
        }
        
    }
        
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
        
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        ez.topMostVC?.dismiss(animated: true, completion: nil)
    }
        
        // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
        
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
