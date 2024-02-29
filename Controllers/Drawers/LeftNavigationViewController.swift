//
//  DrawerLeftViewController.swift
//  Clikat
//
//  Created by Night Reaper on 15/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import ENSwiftSideMenu

class LeftNavigationViewController : ENSideMenuNavigationController {
    
    //MARK:- Variables
    var overLayView = UIView(frame: UIScreen.main.bounds)
    var menuViewControllerLeft : UIViewController?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //  let homeVC =  /GDataSingleton.sharedInstance.app_type == 1 ? StoryboardScene.Main.instantiateHomeViewController() : StoryboardScene.Main.instantiateEcommerceHomeViewController()
        
        if /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom{
            //Nitin

            let home = StoryboardScene.Main.instantiateMainTabBarController()
            self.viewControllers = [home]

        } else {
            let homeVC = StoryboardScene.Main.instantiateEcommerceHomeViewController()
            self.viewControllers = [homeVC]
            
            overLayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.22)
            let tap = UITapGestureRecognizer(target: self, action: #selector(LeftNavigationViewController.handleTap(sender:)))
            overLayView.addGestureRecognizer(tap)
    
            let leftDrawerVc = StoryboardScene.Main.instantiateDrawerMenuViewController()
            menuViewControllerLeft = leftDrawerVc
            sideMenu = ENSideMenu(sourceView: self.view, menuViewController: leftDrawerVc, menuPosition:.left)
    
            sideMenu?.menuWidth = (ScreenSize.SCREEN_WIDTH * 4.0)/5.0 // optional, default is 160
            sideMenu?.delegate = self
            sideMenu?.bouncingEnabled = false
            view.bringSubviewToFront(navigationBar)

        }

    }
    
    @objc func handleTap(sender : UITapGestureRecognizer){
        toggleSideMenuView()
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}

// MARK: - ENSideMenu Delegate
extension LeftNavigationViewController : ENSideMenuDelegate{
    
    func sideMenuWillOpen() {
        view.endEditing(true)
        if let VC = menuViewControllerLeft as? DrawerMenuViewController {
            VC.updateUI()
        }
        UIView.animate(withDuration: 0.3) {
            weak var weakSelf : LeftNavigationViewController? = self
            weakSelf?.topViewController?.view.addSubview(self.overLayView)
        }
    }
    
    func sideMenuWillClose(){
        UIView.animate(withDuration: 0.4) {
            weak var weakSelf : LeftNavigationViewController? = self
            weakSelf?.overLayView.removeFromSuperview()
        }
    }
    
    func sideMenuDidOpen(){}
    func sideMenuDidClose(){}

    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    

//    func sideMenuWillOpen() {
//        view.endEditing(true)
//        if let VC = menuViewControllerLeft as? DrawerMenuViewController {
//            VC.updateUI()
//        }
//        UIView.animate(withDuration: 0.3) {
//            weak var weakSelf : LeftNavigationViewController? = self
//            weakSelf?.topViewController?.view.addSubview(self.overLayView)
//        }
//    }
//
//    func sideMenuWillClose() {
//
//        UIView.animate(withDuration: 0.4) {
//            weak var weakSelf : LeftNavigationViewController? = self
//            weakSelf?.overLayView.removeFromSuperview()
//        }
//    }
}




