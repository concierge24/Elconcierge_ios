import Foundation
import SwiftMessages

class Toast {
    
  class func show(text: String?,type: Theme,changeBackground:Bool = false){
    let view = MessageView.viewFromNib(layout: .messageView)
    
    // Theme message elements with the warning style.
    view.configureTheme(type)
//    let isUserLoggedIn = UserSingleton.shared.loggedInUser?.data?.accessToken != nil
    
    view.configureTheme(backgroundColor: changeBackground ? UIColor.colorDefaultBlack : UIColor.white, foregroundColor:changeBackground ? UIColor.white : UIColor.colorDefaultBlack)
    view.preferredHeight = 80
//    view.titleLabel?.font = R.font.sfProTextBold(size: 16)
//    view.bodyLabel?.font = R.font.sfProTextRegular(size: 14)
    
    view.button?.isHidden = true
    
    let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
    switch template {
    case .Delivery20:
        view.configureContent(title:type == Theme.error ? "Validation.Alert2".localizedString : "Validation.Success".localizedString, body: /text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK") { (button) in
             SwiftMessages.hide()
           }
        break
        
    default:
        view.configureContent(title:type == Theme.error ? "Validation.Alert".localizedString : "Validation.Success".localizedString, body: /text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK") { (button) in
             SwiftMessages.hide()
           }
    }
    
   
    
    SwiftMessages.defaultConfig.presentationStyle = .top
    
    SwiftMessages.defaultConfig.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue))
    
    // Disable the default auto-hiding behavior.
    SwiftMessages.defaultConfig.duration = .automatic
    
    // Dim the background like a popover view. Hide when the background is tapped.
    //SwiftMessages.defaultConfig.dimMode = .gray(interactive: true)
    SwiftMessages.defaultConfig.dimMode = .none
    
    // Disable the interactive pan-to-hide gesture.
    SwiftMessages.defaultConfig.interactiveHide = true
    
    // Specify a status bar style to if the message is displayed directly under the status bar.
    SwiftMessages.defaultConfig.preferredStatusBarStyle = .default
    // Show message with default config.
    SwiftMessages.show(view: view)
    
    // Customize config using the default as a base.
    var config = SwiftMessages.defaultConfig
    config.duration = .forever
    
    // Show the message.
    SwiftMessages.show(config: config, view: view)
  }
}
