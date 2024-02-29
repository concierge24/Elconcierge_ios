//
//  AppDelegate.swift
//  Clikat
//
//  Created by Night Reaper on 14/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManager
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import Fabric
import EZSwiftExtensions
import SwiftyJSON
//import Crashlytics
import YYWebImage
import AVFoundation
import Flurry_iOS_SDK
import Adjust
import UserNotifications
import Firebase
import FirebaseMessaging
import Messages
import NotificationCenter
import UserNotificationsUI
import Stripe
import Braintree
import BraintreeDropIn
import SupportSDK
import ZendeskCoreSDK
import Alamofire

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var mainStoryboard: UIStoryboard?
    //    var appSettings : AppSettings? = GDataSingleton.sharedInstance.appSettingsData
     let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    lazy var coreDataStack = CoreDataStack()
    let DEFAULTS_KEY = "uniqueId"
    
    let adjust = Adjust()
    
    var soundURL: URL?
    var soundID: SystemSoundID = 0
    var pushSound : AVAudioPlayer?
    let gcmMessageIDKey = "gcm.message_id"
    
    //MARK: - Constants
    var brainTreeUrlScheme:String {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                
                if let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
                    let urlTypes = dict["CFBundleURLTypes"] as? [[String:Any]],
                    let brainTreeScheme = urlTypes.first(where: { /($0["CFBundleURLName"] as? String) == "brainTree" }) {
                    debugPrint(/(brainTreeScheme["CFBundleURLSchemes"] as? [String])?.first)
                    
                    return /(brainTreeScheme["CFBundleURLSchemes"] as? [String])?.first
                }
            }
            return ""
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        GMSPlacesClient.provideAPIKey("AIzaSyAuYtVRakCKH7ktGw5KPlF6MMxr92TfMZM")
        GMSServices.provideAPIKey("AIzaSyAuYtVRakCKH7ktGw5KPlF6MMxr92TfMZM")   // GoogleApiKey AIzaSyCNAdSEpIbtSy2rkdGpKqwZMaOv4_WUpJ4
        GMSPlacesClient.openSourceLicenseInfo()
        GMSServices.openSourceLicenseInfo()
        royoCabInitAppDelegate()
        
        CoreLogger.enabled = true
        CoreLogger.logLevel = .verbose

        L102Localizer.DoTheMagic()
        //MARK: - BrainTree
        
        BTAppSwitch.setReturnURLScheme(brainTreeUrlScheme)
        
        window?.rootViewController = Stortyboad.splash.stortBoard.instantiateInitialViewController()
        //        self.onload()
        
        //        self.webserviceGetSettings()
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            UNUserNotificationCenter.current().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        //MARK: - Reachability
        
        UIApplication.shared.registerForRemoteNotifications()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //      DBManager.sharedManager.deleteAllData("Cart")
        
        if let pushNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
            GDataSingleton.sharedInstance.pushDict = pushNotification
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.scheme != FBUrlScheme {
            ez.runThisAfterDelay(seconds: 1, after: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UrlSchemeNotification), object: nil, userInfo:url.fragments)
            })
        }
        
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if let incomingURL = userActivity.webpageURL {
            let handleLink = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL, completion: { (dynamicLink, error) in
                if let dynamicLink = dynamicLink{
                    print("Your Dynamic Link parameter: \(dynamicLink)")
                    self.handleDynamicLink(dynamicLink)
                } else {
                    self.showAlert(title: "Alert!", message: "Link is not wokring right now, please retry.")
                }
            })
            return handleLink
        }
        return false
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(brainTreeUrlScheme) == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleDynamicLink(dynamicLink)
            return true
        } else {
            return ApplicationDelegate.shared.application(app,open: url,
                                                          sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                          annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
       
    }
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        if let dynamicUrl = dynamicLink.url {
            guard let uniqueId = dynamicUrl.queryParameters?["uniqueId"] else {return}
            self.checkIdExists(id: uniqueId)
        }
    }
    
    private func checkIdExists(id: String) {
        guard let uniqueStr = UserDefaults.standard.value(forKey: DEFAULTS_KEY) as? String else {
            self.saveUniqueId(id)
            return
        }
        
        // self.saveUniqueId(id)
        
        if id != uniqueStr {
            self.saveUniqueId(id)
        } else {
            self.webserviceGetSettings()
        }
    }
    
    func moveHere() {
        window?.rootViewController = Stortyboad.splash.stortBoard.instantiateInitialViewController()
    }
    
    private func saveUniqueId(_ value: String) {
        self.logout()
        UserDefaults.standard.set(value, forKey: DEFAULTS_KEY)
        self.getAgentSecretKey(uniqueId: value)
    }
    
    

    
    func getAgentSecretKey(uniqueId: String) {
        
        APIManager.sharedInstance.showLoader()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.getSecretKey(uniqueId: uniqueId)) { (response) in
            APIManager.sharedInstance.hideLoader()
            
            switch response {
            case .Success(_):
                self.webserviceGetSettings()
            default: break
                
            }
        }
    }
    
    func onload(language: String = Localize.currentLanguage()) {
        //        window = UIWindow(frame: UIScreen.main.bounds)
        if L102Language.isRTL {
            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance()
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        window?.backgroundColor = UIColor.white
        switchViewControllers(language: language)
        
        IQKeyboardManager.shared().isEnabled = true
        
        // IQKeyboardManager.shared().disabledDistanceHandlingClasses.add(ChatBotChatVC.self)
        
        window?.makeKeyAndVisible()

        
        LocationManager.sharedInstance.startTrackingUser()
        //LocationManager.sharedInstance.fireObserver()
        GMSPlacesClient.provideAPIKey("AIzaSyDFfLXKDcENGjXYyM_ekHDHeEncJR0rqRw")
        GMSServices.provideAPIKey("AIzaSyDFfLXKDcENGjXYyM_ekHDHeEncJR0rqRw")//GoogleApiKey  AIzaSyCNAdSEpIbtSy2rkdGpKqwZMaOv4_WUpJ4
        GMSPlacesClient.openSourceLicenseInfo()
        GMSServices.openSourceLicenseInfo()
        
        Flurry.startSession("8XK9KF9J73KM3VSFDQNK")
        
        
        
        if let appId = FeatureType.ChatService.getService(name: "Zendesk", key: "appId"),
        let clientId = FeatureType.ChatService.getService(name: "Zendesk", key: "clientId"),
            let zendeskUrl = FeatureType.ChatService.getService(name: "Zendesk", key: "zendeskUrl") {
            GDataSingleton.sharedInstance.zendeskEnabled = true
            Zendesk.initialize(appId: appId,
            clientId: clientId,
            zendeskUrl: zendeskUrl)
        
            if let value = GDataSingleton.sharedInstance.loggedInUser {
                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.User.rawValue)
                let ident = Identity.createAnonymous(name: /value.firstName, email: value.email)//Identity.createJwt(token: /value.token)
                Zendesk.instance?.setIdentity(ident)
                Support.initialize(withZendesk: Zendesk.instance)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.User.rawValue)
                let ident = Identity.createAnonymous()
                Zendesk.instance?.setIdentity(ident)
                Support.initialize(withZendesk: Zendesk.instance)
            }
        }
        
        //Adjust
        let config = ADJConfig(appToken: "33g56qjx73k0", environment: ADJEnvironmentProduction)
        adjust.appDidLaunch(config)
        
        AdjustEvent.AppLaunch.sendEvent()
        //Push Notifications
        
        guard let obj = GDataSingleton.sharedInstance.pushDict else { return }
        handlePushNavigation(pushDict: JSON(obj))
        
    }
    
    func logout() {
        BrainTreeManager.sharedInstance.clearClientToken()
        LocationSingleton.sharedInstance.scheduledOrders = "0"
        GDataSingleton.sharedInstance.loggedInUser = nil
        
        let cache = YYWebImageManager.shared().cache
        cache?.diskCache.removeAllObjects()
        cache?.memoryCache.removeAllObjects()
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    func showAlert(title: String,message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func webserviceGetSettings()  {
        
        let objR = API.GetSettings(FormatAPIParameters.GetSetting.formatParameters())
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            switch response{
            case APIResponse.Success(let object):
                
                guard let object = object as? AppSettings else { return }
                GDataSingleton.sharedInstance.appSettingsData = object
                ButtonThemeColor.shared.reset()
                //reset language to english when app opened using deep linking
                
                if Localize.currentLanguage() != "" {
                    self.onload(language: Localize.currentLanguage())
                }else {
                    self.onload(language: "en")
                }
            default :
                break
            }
        }
        
    }
    
    func switchViewControllers(language: String = L102Language.currentAppleLanguage()){
        self.setUpLanguage()
        if AppSettings.shared.appThemeData?.login_template == true && !GDataSingleton.sharedInstance.isLoggedIn {
            let vc = StoryboardScene.Register.instantiateLoginViewController()
            (vc as? LoginViewController)?.delegate = self
            (vc as? SignupSelectionVC)?.delegate = self
            window?.rootViewController = vc
            return
        }
        if language == "ar" {
            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance()
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        //Localize.currentLanguage() = language
        
       // Localize.setCurrentLanguage(language: language)
        let mixedHomeVC = MixedHomeVC.getVC(.mixedHome)
        let navigationVc = UINavigationController(rootViewController: mixedHomeVC)
        navigationVc.isNavigationBarHidden = true
        window?.rootViewController = navigationVc


    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        GDataSingleton.sharedInstance.showRatingPopUp = "1"
        coreDataStack.saveMainContext()
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        GDataSingleton.sharedInstance.deviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

//MARK:- LoginViewControllerDelegate
extension AppDelegate: LoginViewControllerDelegate {
    
    func userSuccessfullyLoggedIn(withUser user : User?) {
        DispatchQueue.main.async {
            self.switchViewControllers()
        }
    }
    
    func userFailedLoggedIn() {
        
    }
}


extension URL {
    var fragments: [String: String] {
        var results = [String: String]()
        if let pairs : [String]? = self.query?.components(separatedBy: "&"), (pairs ?? []).count > 0  {
            for pair: String in pairs ?? [] {
                if let keyValue = pair.components(separatedBy : "=") as [String]?, keyValue.count > 1{
                    results.updateValue(keyValue[1], forKey: keyValue[0])
                }
            }
            
        }
        return results
    }
}

enum AdjustEvent : String{
    
    case CategoryDetail = "apml81"
    case Reorder = "cnidc2"
    case Cart = "12tj4g"
    case DeepLink = "hnph1c"
    case ScheduleOrder = "k45hcz"
    case ProductDetail = "qf73yl"
    case AppLaunch = "6152w6"
    case Home = "5c4vvl"
    case LiveSupport = "snq5oe"
    case Promotions = "5q3kb0"
    case CompareProducts = "ccaf0v"
    case Favourites = "wnou78"
    case PendingOrders = "wfffh8"
    case ScheduledOrders = "gwo6r2"
    case TrackOrder = "3aag52"
    case RateOrder = "splkev"
    case LoyaltyPoints = "z27cqv"
    case OrderDetail = "uih164"
    case LoyaltyPointsOrder = "efsxes"
    
    case Login = "5ulx30"
    case Delivery = "ltfjve"
    case Order = "i390ad"
    case Purchase = "rcjjeu"
    case SignUp = "lqdpiu"
    
    func sendEvent(){
        
        let event = ADJEvent(eventToken: self.rawValue)
        (UIApplication.shared.delegate as? AppDelegate)?.adjust.trackEvent(event)
        
    }
    
    func sendEvent(revenue : Double?){
        
        let event = ADJEvent(eventToken: self.rawValue)
        event?.setRevenue(/revenue, currency: Constants.currencyName)
        (UIApplication.shared.delegate as? AppDelegate)?.adjust.trackEvent(event)
        
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        GDataSingleton.sharedInstance.fcmToken = fcmToken
        updateFCMToken()
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
    
    func updateFCMToken()  {
       
       if GDataSingleton.sharedInstance.fcmToken == nil {
           return
       }
       if !GDataSingleton.sharedInstance.isLoggedIn{
           return
       }
        let objR = API.updateFCMToken
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: false, withApi: objR) {(response) in
            switch response {
            case APIResponse.Success(let object):
                print(object)
                break
            default :
                break
            }
        }
    }
}
extension L102Localizer {
    class func changeNotificationLanguage(languageId : String?){
        if GDataSingleton.sharedInstance.isLoggedIn {
            APIManager.sharedInstance.opertationWithRequest(withApi: API.NotificationLanguage(FormatAPIParameters.NotificationLanguage(languageId: languageId).formatParameters())) { (response) in
                
               // UtilityFunctions.showSweetAlert(title: L10n.Success.string, message: L10n.NotificationLanguageChangedSuccessfully.string, style: AlertStyle.Success, success: {}, cancel: {})
                
            }
        }
    }
}
