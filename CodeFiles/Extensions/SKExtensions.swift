//
//  Extension.swift
//  AgentApp
//
//  Created by Sandeep Kumar on 09/05/19.
//  Copyright © 2019 Mac_Mini17. All rights reserved.
//

import UIKit
import SDWebImage


//MARK:- ======== Extension String ========
extension UIApplication {
    
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
}

//MARK:- ======== Extension Int ========
extension Int {
    var toStringHours: String {
        let hour = self/60
        let min = self%60
        var str = ""
        if hour > 0 && min > 0 {
            if hour == 1 {
                str = "1 " + L11n.hour.string + " \(min) " + L10n.Mins.string
            } else {
                str = "\(hour) " + L10n.Hours.string + " \(min) " + L10n.Mins.string
            }
        } else if hour > 0 && min == 0 {
            if hour == 1 {
                str = "1 " + L11n.hour.string
            } else {
                str = "\(hour) " + L10n.Hours.string
            }
        }  else if hour == 0 && min > 0 {
            str = "\(min) " + L10n.Mins.string
        }
        return str
    }
}

//MARK:- ======== Extension String ========
extension String {
    
    var parseJSONString: Any? {
        
        let data2 = data(using: String.Encoding.utf8)
        do {
            guard let jsonData = data2 else { return nil }
            return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        }catch let error{
            print(error)
            return nil
        }
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

//MARK:- ======== Extension SDWebImage UIButton ========

extension UIButton {
    
//    override open var isHighlighted: Bool {
//        didSet {
//            backgroundColor = UIColor.clear
//        }
//    }
//
    func loadImage(thumbnail: String?, original: String?, placeHolder: UIImage? = #imageLiteral(resourceName: "placeholder_image"), modeType: UIView.ContentMode = .scaleAspectFill)
    {
        let thumbnailUrl = URL(string: /thumbnail?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        let originalUrl = URL(string: /original?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        contentMode = modeType
        clipsToBounds = true
        
        self.sd_setImage(with: thumbnailUrl, for: .normal, placeholderImage: placeHolder, completed: {
            [weak self] (image, error, type, url) in
            guard let self = self else { return }
            
            let placeHolderImg = image ?? placeHolder
            self.sd_setImage(with: originalUrl, for: .normal, placeholderImage: placeHolderImg)
        })
    }
}

//MARK:- ======== Extension SDWebImage UIImageView ========
extension UIImageView {
    
    private func load(thumbnail: URL?, original: URL?, placeHolder: UIImage? = #imageLiteral(resourceName: "placeholder_image"), modeType: UIView.ContentMode = .scaleAspectFill) {
        
        contentMode = modeType
        clipsToBounds = true
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        self.sd_setImage(with: thumbnail, placeholderImage: placeHolder, completed: {
            [weak self] (image, error, type, url) in
            self?.sd_imageIndicator = nil
            if original != nil {
                let placeHolderImg = image ?? placeHolder
                self?.sd_setImage(with: original, placeholderImage: placeHolderImg)
            }
        })
    }
    
    func loadImage(thumbnail: String?, original: String?, placeHolder: UIImage? = #imageLiteral(resourceName: "placeholder_image"), modeType: UIView.ContentMode = .scaleAspectFill)
    {
        var thumbnailUrl = URL(string: /thumbnail?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        var originalUrl = URL(string: /original?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        
        if original == nil, let thunb = thumbnailUrl {
            originalUrl = URL(string: /thumbnail?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))

            let last = "thumb_" + thunb.lastPathComponent
            let newThumb = thumbnail?.replacingOccurrences(of: thunb.lastPathComponent, with: last)
            thumbnailUrl = URL(string: /newThumb?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        }
        load(thumbnail: thumbnailUrl, original: originalUrl, placeHolder: placeHolder, modeType: modeType)
    }
}

//MARK:- ======== Extension String ========
extension String{
    func openWebLink() {
        guard let url = URL(string: self) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
 
    func openCallApp() {
        "tel://\(self)".openWebLink()
    }
}

//MARK:- ======== Extension UIViewController ========
extension UIViewController {
    @IBAction func didTapPop() {
        self.popVC()
    }
    
    @IBAction func didTapDismiss() {
        self.dismissVC(completion: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension UIViewController {
    
    @discardableResult func addChildViewController(withChildViewController childViewController: UIViewController , view: UIView) -> UIViewController {
        // Add Child View Controller
        addChild(childViewController)
        childViewController.beginAppearanceTransition(true, animated: true)
        // Add Child View as Subview
        view.addSubview(childViewController.view)
        // Configure Child View
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        childViewController.didMove(toParent: self)
        return childViewController
    }
    
    @discardableResult func removeChildViewController(withChildViewController childViewController: UIViewController , view: UIView ) -> UIViewController {
        // Notify Child View Controller
        childViewController.willMove(toParent: nil)
        childViewController.beginAppearanceTransition(false, animated: true)
        // Remove Child View From Superview
        childViewController.view.removeFromSuperview()
        // Notify Child View Controller
        childViewController.removeFromParent()
        return childViewController
    }
    
}
