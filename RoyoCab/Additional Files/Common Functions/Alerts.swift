//
//  Alerts.swift
//  Grintafy
//
//  Created by Sierra 4 on 14/07/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import ISMessages

typealias AlertBlock = (_ success: AlertTag) -> ()


enum Alert : String {
    
    case success = "Success"
    case oops = "Oops"
    case login = "Login Successfull"
    case alert = "Alert"
    case ok = "Ok"
    case cancel = "Cancel"
    case error = "Error"
    case logout = "Are you sure you want to Logout?"
    case confirm = "Confirm"
    
    func getLocalised() -> String {
        
        switch self {
        case .success:  return "Success"
            
        case .oops: return "Oops"
            
        case .login: return "Login Successfull"
            
        case .alert: return "Alert"
            
        case .ok: return "Ok"
            
        case .cancel: return "Cancel"
            
        case .error: return "Error"
            
        case .logout: return "Are you sure you want to Logout?"
            
        case .confirm: return "Confirm"
       
        }
    }
}

enum AlertTag {
    
    case done
    case yes
    case no
}

class Alerts: NSObject {
    
    static let shared = Alerts()
    
    //MARK: - Show ISMessages Alert
    func show(alert title : Alert , message : String , type : ISAlertType){
        
        ISMessages.showCardAlert(withTitle: title.rawValue, message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .top, didHide: nil)
    }
    
    func show(alert title : String , message : String , type : ISAlertType){
        
        Toast.show(text: message, type: .error,changeBackground: true)
        
//        ISMessages.showCardAlert(withTitle: title , message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .top, didHide: nil)
    }
    
    func showOnTop(alert title : String , message : String , type : ISAlertType){
        
        ISMessages.showCardAlert(withTitle: title , message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .top, didHide: nil)
    }
    
    
    func showAlertView(alert Title: String , message: String , buttonTitles : [String] , viewController : UIViewController){
        
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: buttonTitles[0]  , style: UIAlertAction.Style.default , handler: { action in
            
            switch action.style{
                
            case .default:
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        if buttonTitles.count != 1 {
            alert.addAction(UIAlertAction(title: buttonTitles[1]  , style: UIAlertAction.Style.cancel , handler: nil))
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
