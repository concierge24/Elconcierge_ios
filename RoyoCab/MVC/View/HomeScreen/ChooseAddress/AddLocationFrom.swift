//
//  AddLocationFrom.swift
//  RoyoRide
//
//  Created by Ankush on 12/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class AddLocationFrom: UIView {

    @IBOutlet var viewOuter: UIView!
    @IBOutlet weak var btnSearchAddress: UIButton!
    @IBOutlet weak var btnSelectFromMap: UIButton!
    
    
    var delegate: BookRequestDelegate?
    var address: AddressCab?
    var addLocationButtonTag: Int!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let firstTouch = touches.first {
            let hitView = self.hitTest(firstTouch.location(in: self), with: event)
            if hitView === viewOuter {
                removeFromSuperview()
            }
        }
        
    }
    
    
    func showView(locationButtonTag: Int) {
        
        addLocationButtonTag = locationButtonTag
        
        setupUI()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
           
            self?.frame = UIScreen.main.bounds
            ez.topMostVC?.view.addSubview(self ?? UIView())
            
            }, completion: { (done) in
                
        })
                
    }
    
    
    
    func setupUI() {
           btnSearchAddress.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
           btnSelectFromMap.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
       }
    

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        // 1- Search Address, 2- Select from Map
        switch /sender.tag {
        
        case 1:
            delegate?.didAddLocationFrom(buttonTag: addLocationButtonTag, isFromSearch: true)
            removeFromSuperview()
            
        case 2:
            delegate?.didAddLocationFrom(buttonTag: addLocationButtonTag, isFromSearch: false)
            removeFromSuperview()
            
        default:
            break
        }
        
    }
}


