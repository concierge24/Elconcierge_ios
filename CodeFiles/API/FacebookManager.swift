//
//  FacebookManager.swift
//  Clikat
//
//  Created by cblmacmini on 4/27/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

typealias FacebookCallback = (_ facebook : Facebook) -> ()

class FacebookManager: NSObject {
    
    var viewController : UIViewController?
    let permissions = ["public_profile","email"]
    
    var facebookCallback : FacebookCallback?
    
    static let sharedManager: FacebookManager = { FacebookManager() }()
    
    
    override init() {
        super.init()
    }
    
    
    func configureLoginManager(sender : UIViewController, success : @escaping FacebookCallback){
        
        facebookCallback = success
        self.viewController = sender
        let loginManager = LoginManager()
//        FBSDKAccessToken.cl
        loginManager.logOut()
        loginManager.logIn(permissions: permissions, from: viewController) { (result, error) in
            weak var weakSelf = self
            if let err = error {
                print(err.localizedDescription)
            }else if result?.isCancelled == true{
                print("Cancelled")
            }else{
                weakSelf?.sendGraphRequest()
            }
        }
    }
    
    
    func sendGraphRequest(){
        
        GraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,picture.type(large),email"]).start { (connection, result, error) in
            
            if let err = error {
                print(err.localizedDescription)
            }else if let block = self.facebookCallback {
             
                let fbProfile = Facebook(result: result)
                block(fbProfile)
                
            }
        }
    }
}

class Facebook : NSObject {
    
    var fbId : String?
    var firstName : String?
    var lastName : String?
    var imageUrl : String?
    var email : String?
    
    init(result : Any?) {
        super.init()
        guard let fbResult = result as? [String:Any] else { return }
        
        fbId = AccessToken.current?.userID
        
        firstName = fbResult["first_name"] as? String
        lastName = fbResult["last_name"] as? String
        imageUrl = ((fbResult["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
        email = fbResult["email"] as? String
        
        //Nitin
//        if email == nil || email?.trimmed().length == 0 {
//            email = /firstName + "@facebook.com"
//        }
    }
    
    override init() {
        super.init()
    }
}



