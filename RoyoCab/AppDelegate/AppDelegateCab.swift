//
//  AppDelegate.swift
//  Buraq24
//
//  Created by Maninder on 30/07/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManager
import GoogleMaps
import GooglePlaces
import SideMenu
import Firebase
import UserNotifications
import Fabric
import Crashlytics
import Firebase
import FirebaseMessaging

//@UIApplicationMain

extension AppDelegate {
        
    func royoCabInitAppDelegate() {
        setUpLanguage()
        //setUpApiKeys()
        
        //IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        IQKeyboardManager.shared().isEnabled = true
        
        //LocationManagerCab.shared.updateUserLocation()
        
//        Messaging.messaging().delegate = self
        
        self.listenForReachability()
        
        //FirebaseApp.configure()
        //registerForPushNotifications()
        //clearNotifications()
        
       // onLoad()
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
    }
    
    func listenForReachability() {
        self.reachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            switch status {
            case .notReachable, .unknown: break
                
              //  NotificationCenter.default.post(name: Notification.Name(rawValue:LocalNotifications.InternetDisconnected.rawValue), object: nil)
                
            //Show error state
            case .reachable(_): break
             //   NotificationCenter.default.post(name: Notification.Name(rawValue:LocalNotifications.InternetConnected.rawValue), object: nil)
                //Hide error state
            }
        }
        
        self.reachabilityManager?.startListening()
    }
   
    func applicationWillEnterForeground(_ application: UIApplication) {
        clearNotifications()
        
        let userInfo = UDSingleton.shared
        if (userInfo.userData != nil) {
            
         //   NotificationCenter.default.post(name: Notification.Name(rawValue: LocalNotifications.AppInForground.rawValue), object: nil)
        }
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        clearNotifications()
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
//    }
    
//    // MARK: - Core Data stack
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        let container = NSPersistentContainer(name: "Buraq24")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//    
//    // MARK: - Core Data Saving support
//    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
}

//extension AppDelegate {
//    
//    func registerForPushNotifications() {
//        
//        
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//                (granted, error) in
//                
//                guard granted else { return }
//                self.getNotificationSettings()
//            }
//            
//        } else {
//            
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            ez.runThisInMainThread {
//                UIApplication.shared.registerUserNotificationSettings(settings)
//            }
//        }
//    }
//    
//    func getNotificationSettings() {
//        
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            guard settings.authorizationStatus == .authorized else { return }
//            ez.runThisInMainThread {
//                
//                UIApplication.shared.registerForRemoteNotifications()
//                
//            }
//        }
//    }
//    
//    func unregisterForpushNotification() {
//        ez.runThisInMainThread {
//            
//            UIApplication.shared.unregisterForRemoteNotifications()
//            
//        }
//    }
//    
//    
//    func application(_ application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        
//        //        InstanceID.instanceID().instanceID { (result, error) in
//        //            if let error = error {
//        //                debugPrint("Error fetching remote instange ID: \(error)")
//        //            } else if let result = result {
//        //                debugPrint(result.token)
//        //                UserDefaultsManager.fcmId = result.token
//        //            }
//        //        }
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        
//        debugPrint("Failed to register: \(error)")
//    }
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        
//        UserDefaultsManager.fcmId = fcmToken
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        
//        debugPrint(userInfo)
//    }
//    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        
//        if let payload  = notification.request.content.userInfo  as? [String : Any] {
//            
//            guard let type = payload["type"] as? String else { return }
//            
//            switch type {
//                
//            case RemoteNotificationType.DriverAccepted.rawValue:
//                NotificationCenter.default.post(name: Notification.Name(rawValue:RemoteNotificationType.DriverAccepted.rawValue), object: nil)
//                completionHandler(
//                    [UNNotificationPresentationOptions.sound,
//                     UNNotificationPresentationOptions.badge])
//                
//            default:
//                break
//            }
//        }
//        
//        //        let type = dic.value(forKey: "type") as? String
//        //
//        //        let future = dic.value(forKey: "future") as? String
//        //        let user_detail_id = dic.value(forKey: "user_detail_id") as? String
//        //        let google = dic.value(forKey: "google.c.a.e") as? String
//        //        let user_id = dic.value(forKey: "user_id") as? String
//        //        let aps = dic.value(forKey: "aps") as? NSDictionary
//        //        let gcmMessageId = dic.value(forKey: "gcm.message_id") as? String
//        //        debugPrint(eventType)
//        
//       // completionHandler([.alert, .sound])
//        NSLog("Userinfo %@",notification.request.content.userInfo);
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//        
//        // Print message ID.
//        //        if let messageID = userInfo[gcmMessageIDKey] {
//        //            debugPrint("Message ID: \(messageID)")
//        //        }
//        
//        // Print full message.
//        
//        debugPrint(userInfo )
//    }
//    
//}
extension AppDelegate {
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func setUpApiKeys() {
        //google api setup
        GMSServices.provideAPIKey(APIBasePath.googleApiKey)
        GMSPlacesClient.provideAPIKey(APIBasePath.googleApiKey)
    }
    
    
    
    func clearNotifications() {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
        }
    }
    
    
    func setUpLanguage() {
        
        var code = 1
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            code = intVal
        }else {
            // let language = Bundle.main.preferredLocalizations.first
        }
        
        if let languageArray = UDSingleton.shared.appSettings?.languages{
            
            var languageCode = UserDefaultsManager.languageCode ?? "en"
            
            if languageCode == "zh" || languageCode == "zh-Hans"{
                
                languageCode  = "zh"
            }
            
            code = languageArray.first(where: {$0.language_code?.lowercased() == languageCode})?.language_id ?? 1
            
        }
       // LanguageFile.shared.setLanguage(languageID: code)
        LanguageFile.shared.setLanguage(languageID: code,languageCode: UserDefaultsManager.languageCode ?? "en")
    }
    
    func setHomeAsRootVC() {
        /*
        let index = GDataSingleton.sharedInstance.selectedServiceIndex

        if let userData = UDSingleton.shared.userData {
           var services = userData.services
            if index == 1 {
                guard let objS = services?.filter({$0.serviceCategoryId == 10}).first else {return}
                userData.services = services
            }
            else if index == 0 {
               guard let objS = services?.filter({$0.serviceCategoryId == 4}).first else {return}
               userData.services = services
           }  else if index == 2 {
                guard let objS = services?.filter({$0.serviceCategoryId == 7}).first else {return}
                userData.services = services
            }

           // services.filter
            UDSingleton.shared.userData = userData
        }
        */
        guard let vc = R.storyboard.bookService.homeVC() else { return }
        let navigation = UINavigationController(rootViewController: vc)
        navigation.isNavigationBarHidden = true
        self.window?.rootViewController = navigation
        UIViewController().stopAnimating()
    }
    
    func setWalkThroughAsRootVC() {
        
        guard let vc = R.storyboard.mainCab.landingAndPhoneInputVC() else { return }
        let navigation = UINavigationController(rootViewController: vc)
        navigation.isNavigationBarHidden = true
        self.window?.rootViewController = navigation
        UIViewController().stopAnimating()
    }
    
    func setLoginAsRootVC() {
        switchViewControllers()
//        guard let vc = R.storyboard.mainCab.landingAndPhoneInputVC() else { return }
//
//        if  let navigation = self.window?.rootViewController as? UINavigationController {
//            navigation.navigationBar.isTranslucent = false
//            navigation.navigationBar.isHidden = true
//            navigation.navigationBar.barTintColor = UIColor.clear
//            navigation.isNavigationBarHidden = true
//            navigation.viewControllers[0] = vc
//            self.window?.rootViewController = navigation
//        }else  {
//            let navigation = UINavigationController(rootViewController: vc)
//            navigation.navigationBar.isTranslucent = false
//            navigation.navigationBar.isHidden = true
//            navigation.navigationBar.barTintColor = UIColor.clear
//            self.window?.rootViewController = navigation
//        }
//
        UIViewController().stopAnimating()
    }
    
    var appDelegate : AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
//
//    func onLoad() {
//        let userInfo = UDSingleton.shared
//        if (userInfo.userData != nil) {
//            setHomeAsRootVC()
//        }else if userInfo.isOnBoardingDone {
//            setLoginAsRootVC()
//            //  setHomeAsRootVC()
//        }
//    }
//
    
}

