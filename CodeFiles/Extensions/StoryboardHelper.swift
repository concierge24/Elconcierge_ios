//
//  StoryboardHelper.swift
//  Sneni
//
//  Created by Sandeep Kumar on 22/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

enum Stortyboad: String {
    case splash = "Splash"
    case main = "Main"
    case options = "Options"
    case order = "Order"
    case register = "Register"
    case laundry = "Laundry"
    case tracking = "Tracking"
    case bot = "Bot"
    case doctorHome = "DoctorHome"
    case moreScreen = "MoreScreen"
    case payment = "Payment"
    case mixedHome = "MixedHome"

    
    var stortBoard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
}

extension NSObject {
    class var identifier: String {
        return String(describing: self)
    }
}

//MARK:- ======== ViewController Identifiers ========
extension UIView
{
    static func getNib() -> Self {
        
        func instanceFromNib<T: UIView>() -> T {
            guard let vc = UINib(nibName: T.identifier, bundle: nil).instantiate(withOwner: nil, options: nil).last as? T else {
                fatalError("'\(T.identifier)' NIB is Not exist")
            }
            return vc
        }
        return instanceFromNib()
    }
}

//MARK:- ======== ViewController Identifiers ========
extension UIViewController {
    
    static func getVC(_ storyBoard: Stortyboad) -> Self {
        
        func instanceFromNib<T: UIViewController>(_ storyBoard: Stortyboad) -> T {
            guard let vc = controller(storyBoard: storyBoard, controller: T.identifier) as? T else {
                fatalError("'\(storyBoard.rawValue)' : '\(T.identifier)' is Not exist")
            }
            return vc
        }
        return instanceFromNib(storyBoard)
    }
    
    static func controller(storyBoard: Stortyboad, controller: String) -> UIViewController {
        let storyBoard = storyBoard.stortBoard
        let vc = storyBoard.instantiateViewController(withIdentifier: controller)
        return vc
    }
}

@objc enum ActionProtocolosType: Int {
    case viewAll = 0
    case tap
}

@objc protocol ActionProtocolos: NSObjectProtocol {
    
    @objc optional func didTap(action: ActionProtocolosType, cell: Any)
    
}
