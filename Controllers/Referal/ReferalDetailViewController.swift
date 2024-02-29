//
//  ReferalDetailViewController.swift
//  Sneni
//
//  Created by Gagandeep Singh on 17/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class ReferalDetailViewController: UIViewController {
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnBack: ThemeButton! {
        didSet{
            btnBack.imageView?.mirrorTransform()
        }
    }
    @IBOutlet weak var btnRefer: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnreferred: UIButton!
    @IBOutlet weak var viewReferSelected: UIView!
    @IBOutlet weak var viewReferred: UIView!
    
    //MARK::- PROPERIES
    var referVc: ReferalViewController?
    var referredUsersVc: ReferredUsersViewController?
    
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK::- FUNCTIONS
    
    func updateUI(){
        btnRefer.backgroundColor = SKAppType.type.color
        btnreferred.backgroundColor = SKAppType.type.color
        instantiateVC()
    }
    
    func instantiateVC(){
        let storyboard = UIStoryboard(name: "Referal", bundle: nil)
        referVc =  storyboard.instantiateViewController(withIdentifier: "ReferalViewController") as? ReferalViewController
        
        referredUsersVc = storyboard.instantiateViewController(withIdentifier: "ReferredUsersViewController") as? ReferredUsersViewController
        addChild()
        
    }
    
    func addChild(){
        self.addChildViewController(withChildViewController: referVc ?? UIViewController() , view: viewContainer)
        self.addChildViewController(withChildViewController: referredUsersVc ?? UIViewController() , view: viewContainer)
        referredUsersVc?.view.isHidden = true
    }
    
    
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionReferred(_ sender: UIButton) {
        viewReferSelected.isHidden = true
        viewReferred.isHidden = false
        referredUsersVc?.view.isHidden = false
        referVc?.view.isHidden = true
    }
    
    @IBAction func btnActionRefer(_ sender: UIButton) {
        viewReferSelected.isHidden = false
        viewReferred.isHidden = true
        referredUsersVc?.view.isHidden = true
        referVc?.view.isHidden = false
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.popVC()
    }
    
    
}
