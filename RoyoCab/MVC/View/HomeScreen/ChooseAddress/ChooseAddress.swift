//
//  ChooseAddress.swift
//  Trava
//
//  Created by Apple on 08/01/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class ChooseAddress: UIView {

    @IBOutlet var viewOuter: UIView!
    @IBOutlet weak var labelLocationNickName: UILabel!
    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var btnPickUpAddress: UIButton!
    @IBOutlet weak var btnDropAddress: UIButton!
    
    var delegate: BookRequestDelegate?
    var address: AddressCab?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let firstTouch = touches.first {
            let hitView = self.hitTest(firstTouch.location(in: self), with: event)
            if hitView === viewOuter {
                removeFromSuperview()
            }
        }
        
    }
    
    
    func showView(address: AddressCab?) {
        
        self.address = address
        setupUI()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
           
            self?.frame = UIScreen.main.bounds
            ez.topMostVC?.view.addSubview(self ?? UIView())
            
            }, completion: { (done) in
                
        })
        
        
        labelLocationName.text = address?.address
        labelLocationNickName.text = address?.addressName
    }
    
    
    
    func setupUI() {
        btnPickUpAddress.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
        btnPickUpAddress.setTitle("PICKUP ADDRESS".localizedString, for: .normal)
        btnDropAddress.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnDropAddress.setTitle("DROPOFF ADDRESS".localizedString, for: .normal)
        //labelLocationName.setAlignment()
    }
    

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        // 1- Pickup, 2- Dropoff
        switch /sender.tag {
        
        case 1:
            delegate?.didChooseAddressFromRecent(place: address, isPickup: true)
            removeFromSuperview()
            
        case 2:
            delegate?.didChooseAddressFromRecent(place: address, isPickup: false)
            removeFromSuperview()
            
        default:
            break
        }
        
    }
}

