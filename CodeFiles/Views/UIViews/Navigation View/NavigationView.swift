//
//  NavigationView.swift
//  Sneni
//
//  Created by Sandeep Kumar on 27/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class AppStatusView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = SKAppType.type.headerColor
    }
}

class ElementLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = SKAppType.type.elementColor
    }
}

class ElementGreyLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = SKAppType.type.grayTextColor
    }
}

class NavLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = SKAppType.type.headerTextColor
    }
}

class NavButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = SKAppType.type.headerTextColor
        self.setTitleColor(SKAppType.type.headerTextColor, for: .normal)
    }
}

class NavigationView: ThemeView {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var btnMenu: SKThemeButton?
    @IBOutlet weak var btnCart: SKThemeButton?
    @IBOutlet weak var btnBack: SKThemeButton?
    @IBOutlet weak var btnArea: UIButton? {
        didSet{
               let header = SKAppType.type.headerTextColor
                btnArea?.setTitleColor(header ?? UIColor.darkGray, for: .normal)
                btnArea?.tintColor = header ?? .gray
        }
    }
    @IBOutlet weak var btnAreaArrow: ThemeImgView?{
        didSet{
             let header = SKAppType.type.headerTextColor
              btnAreaArrow?.tintColor = header
              lblLoc?.textColor = header
        }
    }

    @IBOutlet weak var lblLoc: UILabel?{
        didSet{
            if let headerColor = AppSettings.shared.appThemeData?.header_text_color {
                let header = UIColor(hexString: headerColor)
                lblLoc?.textColor = header
                lblLoc?.text = "Location".localized()
            }
        }
    }
    @IBOutlet weak var btnSearch: SKThemeButton?{
        didSet{
            btnSearch?.isHidden =  AppSettings.shared.isSingleVendor ? true : false
            if let headerColor = AppSettings.shared.appThemeData?.header_text_color {
                let header = UIColor(hexString: headerColor)
                btnSearch?.setTitleColor(header ?? UIColor.darkGray, for: .normal)
                btnSearch?.tintColor = header ?? .gray
            }
        }
    }
    @IBOutlet weak var imgLogoCenter: UIImageView?
    
    @IBOutlet weak var imgLogo: UIImageView? {
        didSet {
            //imgLogo?.layer.cornerRadius = imgLogo?.frame.width ?? 0.0/2
            //imgLogo?.isHidden = GDataSingleton.sharedInstance.isSingleVendor ? false : true
           // imgLogo?.isHidden = true
        }
    }
    @IBOutlet weak var stackLoc: UIStackView?

//        {
//        didSet {
//            stackLoc?.isHidden = false
//        }
//    }
    //MARK:- ======== Variables ========
    var isFirst = false
    
    lazy var viewStatusBack: UIView = {
        let view = UIView(frame: .init(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height))
        //view.backgroundColor = SKAppType.type.color
        return view
    }()
    
    //MARK:- ======== LifeCycle ========
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isFirst {
            isFirst = true
            initalSetup()
        }
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapSubmit(_ sender: Any) {
        
    }
    
    @objc func logoTapped() {
        if DBManager.sharedManager.isCartEmpty() {
                  DBManager.sharedManager.cleanCart()
                  AppDelegate.shared().switchViewControllers()
              }else {
                  UtilityFunctions.showSweetAlert(title : L10n.AreYouSure.string, message: "Going back will clear you cart", success: { [weak self] in
                      DBManager.sharedManager.cleanCart()
                      DispatchQueue.main.async {
                          AppDelegate.shared().switchViewControllers()
                      }
                      }, cancel: {
                  })
              }
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
     //Nitin
        if (SKAppType.type == .home || SKAppType.type == .eCom /*|| SKAppType.type == .gym*/) {
            //[btnMenu, btnBack, btnCart, btnArea].forEach({ $0?.imgColorId = "White";  $0?.imgSelectedColorId = "White"; $0?.titleColorId = "White"; $0?.titleSelectedColorId = "White" })
            //header_text_color

        }
        
        let header = SKAppType.type.headerTextColor
        [btnMenu, btnBack, btnCart, btnArea].forEach({
            $0?.setTitleColor(header, for: .normal)
            $0?.tintColor = header
        })
         //[lblLoc].forEach({ $0?.textColor = .white })
         
         btnAreaArrow?.setImageColor(color: SKAppType.type.headerTextColor)
         
         shadowOpacity = 0.0
         
         addSubview(viewStatusBack)
         backgroundColor = SKAppType.type.headerColor
        
        
        
        if APIConstants.defaultAgentCode == "spicemaster_0134" {
            stackLoc?.isHidden = true
            imgLogo?.isHidden = true
            imgLogoCenter?.isHidden = false
            if let logo = AppSettings.shared.appThemeData?.logo_url {
                 imgLogoCenter?.loadImage(thumbnail:logo, original: nil, modeType: .scaleAspectFit)
            }
        }
        else {
            imgLogoCenter?.isHidden = true
            imgLogo?.isHidden = false
            imgLogo?.image = UIImage(named: "back_home")
            imgLogo?.layer.cornerRadius = 0
            imgLogo?.isUserInteractionEnabled = true
            imgLogo?.addTapGesture(action: { [weak self] (tapGes) in
                self?.logoTapped()
            })
//            if let logo = AppSettings.shared.appThemeData?.logo_url {
//                imgLogo?.loadImage(thumbnail:logo, original: nil, modeType: .scaleAspectFit)
//            }
        }
        
    }
}
