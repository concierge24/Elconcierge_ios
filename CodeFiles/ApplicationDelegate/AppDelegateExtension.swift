//
//  AppDelegateExtension.swift
//  Clikat
//
//  Created by cblmacmini on 8/28/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON
import EZSwiftExtensions
//import LNNotificationsUI
import UserNotifications

extension AppDelegate{
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        guard let dict = userInfo as? [String: Any] else{return}
        if /(dict["type"] as? String) == "chat"{
            let storyboard = UIStoryboard(name: "Chats", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "ChatHeadVC") as? ChatHeadVC else { return }
            let agnt = CblUser()
            agnt.name = /(dict["sender_name"] as? String)
            agnt.image = /(dict["sender_image"] as? String)
            agnt.agent_created_id = /(dict["sender_image"] as? String)
            vc.agent = agnt
            vc.agentId = /(dict["agent_created_id"] as? String)
            vc.orderId = /(dict["order_id"] as? String)
            UIApplication.topViewController()?.pushVC(vc)
        }else{
            if let orderId = dict["orderId"] as? String {
                self.refreshViewController(orderId: orderId)
            }
        }
        
        
        //handlePush(userInfo: dict)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        guard let dict = userInfo as? [String: Any] else{return}
        
        if let type = dict["type"] as? String{
            if type == "chat"{
                let orderId = dict["orderId"] as? String
                let agent_created_id = dict["agent_created_id"] as? String
                if UserData.share.currentConversationId == orderId && UserData.share.currentAgentId == agent_created_id{
                    completionHandler([])
                }else {
                    completionHandler([.alert,.badge,.sound])
                }
            }
            else if type == "request" {
                refreshRequests()
            }
        }else{
            if let orderId = dict["orderId"] as? String {
                self.refreshViewController(orderId: orderId)
            }
            completionHandler([.alert,.badge,.sound])
        }
        
        
        
    }
    
    func refreshRequests() {
        if let baseVc = window?.rootViewController as? LeftNavigationViewController {
                   if let vc = ez.topMostVC as? PrescriptionRequestsVC {
                       vc.reloadData()
                   } else {
                       //self.setBaseVc(navigationVc: baseVc, orderId: orderId)
                   }
               }
    }
    
    func refreshViewController(orderId: String?) {
        
        if let baseVc = window?.rootViewController as? LeftNavigationViewController {
            if let vc = ez.topMostVC as? OrderDetailController {
                vc.getOrderDetails(orderId: orderId ?? "")
            } else {
                self.setBaseVc(navigationVc: baseVc, orderId: orderId)
            }
        } else {
            let navigationVc = StoryboardScene.Main.instantiateLeftNavigationViewController()
            window?.rootViewController = navigationVc
            self.setBaseVc(navigationVc: navigationVc, orderId: orderId)
        }
        
        
        //        else if let vc = ez.topMostVC as? OrderHistoryViewController {
        //            if vc.bottomView_leadingConstraint.constant == vc.pending_button.frame.x {
        //                vc.upcomingOrders()
        //            } else if vc.bottomView_leadingConstraint.constant == vc.completed_button.frame.x {
        //                vc.webService()
        //            }
        //        }
    }
    
    func setBaseVc(navigationVc: UINavigationController,orderId:String?) {
        
        if let homeVc = navigationVc.viewControllers.first as? MainTabBarViewController {
            let index = homeVc.viewControllers?.firstIndex(where: {$0 is OrderHistoryViewController}) ?? 2
            homeVc.selectedIndex = index
            guard let topVc = homeVc.viewControllers?[index] as? OrderHistoryViewController else {return}
            let VC = StoryboardScene.Order.instantiateOrderDetailController()
            let order = OrderDetails(orderId: orderId ?? "")
            VC.type = .OrderUpcoming
            VC.orderDetails = order
            topVc.pushVC(VC)
        }
    }
    
    func handlePush(userInfo : [String : Any]?){
        guard let dict = userInfo else { return }
        let json = JSON(dict)
        if UIApplication.shared.applicationState == .active {
            HDNotificationView.show(with: UIImage(asset: Asset.Ic_notification), title: "Royo Customer", message: userInfo?["message"] as? String, isAutoHide: true) { [weak self] in
                self?.pushSound?.stop()
                HDNotificationView.hide()
                self?.handlePushNavigation(pushDict: json)
            }
            
            if let filePath = Bundle.main.path(forResource: "push", ofType: "mp3"){
                soundURL = URL(fileURLWithPath: filePath)
                do {
                    let sound = try AVAudioPlayer(contentsOf: soundURL!)
                    pushSound = sound
                    sound.play()
                } catch {
                    // couldn't load file :(
                }
            }
        }else {
            handlePushNavigation(pushDict: json)
        }
    }
    
    func handlePushNavigation(pushDict : JSON?) {
        
        if pushDict?["orderId"].stringValue == "" { return }
        GDataSingleton.sharedInstance.pushDict = nil
        let vc = StoryboardScene.Main.instantiateMainTabBarController()
        let index = vc.viewControllers?.firstIndex(where: {$0 is OrderHistoryViewController}) ?? 2
        vc.selectedIndex = index
        guard let topVc = vc.viewControllers?[index] as? OrderHistoryViewController else {return}
        
        let VC = StoryboardScene.Order.instantiateOrderDetailController()
        let order = OrderDetails(orderId: pushDict?["orderId"].stringValue)
        VC.type = .OrderUpcoming
        VC.orderDetails = order
        topVc.pushVC(VC)
        
        //        if Localize.currentLanguage() == Languages.Arabic {
        //            let navigationVc = StoryboardScene.Main.instantiateRightNavigationViewController()
        //            navigationVc.viewControllers = [VC]
        //            window?.rootViewController = navigationVc
        //            return
        //        }
        //        let navigationVc = StoryboardScene.Main.instantiateLeftNavigationViewController()
        //        navigationVc.viewControllers = [VC]
        //        window?.rootViewController = navigationVc
    }
}
