//
//  CarBuffesViewController.swift
//  Knowmoto

//  Created by cbl16 on 02/08/19.
//  Copyright © 2019 Codebbewlabs. All rights reserved.

//Code by Amandeep aman.code-brew@gmai.com

import UIKit

import UIKit
//import AWSS3

struct WalkThroughScreenModel{
    
    var image:UIImage?
    var title:String?
    var subtitle:String?
    
}

// ["LanguageName.English".localizedString , "LanguageName.Urdu".localizedString ,"LanguageName.Arabic".localizedString ,"LanguageName.Chinese".localizedString,"LanguageName.Spanish".localizedString,"LanguageName.French".localizedString,"LanguageName.Dutch".localizedString,"LanguageName.Italian".localizedString,"LanguageName.Japanese".localizedString,"LanguageName.German".localizedString]


let languageArry : [String] = ["LanguageName.English".localizedString  ,"LanguageName.Chinese".localizedString,"LanguageName.Spanish".localizedString,"LanguageName.French".localizedString,"LanguageName.Dutch".localizedString,"LanguageName.Italian".localizedString,"LanguageName.Japanese".localizedString,"LanguageName.German".localizedString,"LanguageName.Arabic".localizedString]

class LandingAndPhoneInputVC: BaseVCCab {
    //MARK:- OUTLETS
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet var txtFieldMobileNo: UITextField!
    @IBOutlet var imgViewCountryCode: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet weak var topConstraintWalkthrough: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintPhoneNumberView: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblheading: UILabel!
    @IBOutlet weak var lblSubtitleOtpWillBeSentTo: UILabel!
    @IBOutlet weak var containerViewWalkthroughs: UIView!
    @IBOutlet weak var containerViewPhoneNumber: UIView!
    @IBOutlet var arrayIndicatorConstraint: [NSLayoutConstraint]!
    @IBOutlet var arrrayIndicatorView: [UIView]!
    @IBOutlet var collectionTable: UICollectionView!

    @IBOutlet weak var lblFlagImage: UILabel!
    @IBOutlet weak var countryButton: UIButton!
    
    //MARK:-PROPERTIES
    
    var HeadingCollectionViewDataSource:CollectionViewDataSourceCab?
    var iso: String?
    private var currentIndicatorWidth:CGFloat = 16.0
    private var indicatorNormalWidth:CGFloat = 8.0
    
    private var isOpenPhoneNumberView:Bool = false
    
  /*  public var arrayWalkThroughModel = [
       
        WalkThroughScreenModel(image: UIImage(named: "ic_illus_1"), title: "Book A Cab", subtitle: "Book a taxi instantly or schedule it according to your needs."),
        WalkThroughScreenModel(image: UIImage(named: "ic_illus_2"), title: "Book A Ride For Your Friend", subtitle: "Book a taxi instantly or schedule it according to your needs."),
        WalkThroughScreenModel(image: UIImage(named: "ic_illus_3"), title: "Pick Up or Delivery", subtitle: "Book a taxi instantly or schedule it according to your needs.")
        
    ]*/
    
    var arrayWalkThroughModel : [Walkthrough]?
    var currentIndex:Int = 0
    
    deinit {
        debugPrint("Deintialized",String(describing: self))
    }
    
    
    //MARK:- LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    
    func countryFlag(countryCode: String) -> String {
      return String(String.UnicodeScalarView(
         countryCode.unicodeScalars.compactMap(
           { UnicodeScalar(127397 + $0.value) })))
    }
    
    
    
    private func initialSetup(){
        
       /* if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.clear
        } */
        
        arrayWalkThroughModel = UDSingleton.shared.appSettings?.walk_through
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            
            self?.setUpUI()
            
        }
        setupData()
    }

    func setUpUI() {
        
        lblSubtitleOtpWillBeSentTo.text = "LandingVC.OtpWillBeSent".localizedString
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .DeliverSome:
           print("Deliver Some")
            break
          
        case .GoMove:
            lblSubtitleOtpWillBeSentTo.text = "A verification code will be sent to your cellphone."
          break
        default:
          print("Default")
            
        }
        
        
        self.view.backgroundColor = UIColor.white
        btnPhoneNumber.setButtonWithBorderColorSecondary()
        countryButton.setButtonWithBorderColorSecondary()
        btnNextAccessoryView.frame = CGRect(x: 0, y: 0, width: /ez.screenWidth, height: 48.0)
        btnNextAccessoryView.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
        self.setIndicator(selectedIndex: 0)
        self.configureCollectionView()
        btnNextAccessoryView.setTitle("LandingVC.Proceed".localizedString, for: .normal)
        txtFieldMobileNo.delegate = self
        txtFieldMobileNo.inputAccessoryView = btnNextAccessoryView
        txtFieldMobileNo.setAlignment()
 
    }
    
    func setupData() {
                
        iso =  UDSingleton.shared.appSettings?.appSettings?.iso_code ?? DefaultCountry.ISO.rawValue
        
        if iso?.count == 2 {
            imgViewCountryCode.image = UIImage(named: "\(/iso?.lowercased()).png")
            
            if let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist"),
                 let arr:[NSDictionary] = NSArray(contentsOfFile: path) as? [NSDictionary]{

                 let dict:[[String:AnyObject]] = arr.filter{($0["code"] as! String) == /iso} as! [[String : AnyObject]]

                 if let val = dict.first {
                     let data = val as NSDictionary
                     let dialCode = data.value(forKey: "dial_code") as! String
                     lblCountryCode.text = dialCode
                 }
             }
            
            lblFlagImage.text = countryFlag(countryCode: /iso?.lowercased())
            
            
        } else {
            guard let isoAlpha2 = CountryUtility.getISOAlpha2(isoAlpha3: /iso) else { return }
                   imgViewCountryCode.image = UIImage(named: "\(isoAlpha2.lowercased()).png")
                   if let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist"),
                       let arr:[NSDictionary] = NSArray(contentsOfFile: path) as? [NSDictionary]{

                       let dict:[[String:AnyObject]] = arr.filter{($0["code"] as! String) == /isoAlpha2} as! [[String : AnyObject]]

                       if let val = dict.first {
                           let data = val as NSDictionary
                           let dialCode = data.value(forKey: "dial_code") as! String
                           lblCountryCode.text = dialCode
                       }
                   }
            
            lblFlagImage.text = countryFlag(countryCode: isoAlpha2)
        }
        
       
        
        
        imgViewCountryCode.isHidden = false
        lblFlagImage.isHidden  = true
        
    }
    
    
    //MARK:- Button actions
    
    //next action
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        
        let code = /lblCountryCode.text
        let number = /txtFieldMobileNo.text?.trimmed()
        
        if Validations.sharedInstance.validatePhoneNumber(phone: number) {
            
            self.sendOtp(code: code, number: number)
            
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        
        isOpenPhoneNumberView = !isOpenPhoneNumberView
        self.openPhoneNumberView(isOpen: isOpenPhoneNumberView)
       
    }
    
    
    @IBAction func didBeginEditingPhoneNumber(_ sender: UITextField) {
        
        if !isOpenPhoneNumberView{
            
            self.openPhoneNumberView(isOpen: true)
            
        }
       
    }
    
    @IBAction func actionBtnCountryCode(_ sender: UIButton) {
        
        guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
        countryPicker.delegate = self
        self.presentVC(countryPicker)
    }
    
    
    //MARK:-Configuring Table View
    
    func configureCollectionView(){ //Configuring collection View cell
        
        
        let identifier = String(describing: WalkthroughCollectionViewCell.self)
        
        HeadingCollectionViewDataSource = CollectionViewDataSourceCab(items: arrayWalkThroughModel, collectionView: collectionTable, cellIdentifier: identifier, headerIdentifier: nil, cellHeight: collectionTable.bounds.height, cellWidth: UIScreen.main.bounds.width, configureCellBlock: { (cell, item, indexPath) in
            
            let _cell = cell as? WalkthroughCollectionViewCell
            _cell?.model = item
            
        }, aRowSelectedListener: nil, willDisplayCell: nil) { [weak self] (scrollView) in
            
            guard let indexPath = self?.collectionTable.getVisibleIndexOnScroll() else {return}
            
            if self?.currentIndex != indexPath.item{
                
                self?.setIndicator(selectedIndex: indexPath.item)
                
            }
            
        }
        
        collectionTable.dataSource = HeadingCollectionViewDataSource
        collectionTable.delegate = HeadingCollectionViewDataSource
        collectionTable.reloadData()
    }
    

}

//UItextfield delegates

extension LandingAndPhoneInputVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        if  string == numberFiltered {
            if text == "" && string == "0" {
                return false
            }
            let newLength = text.length + string.length - range.length
            return newLength <= 15
        } else {
            return false
        }
    }
}

//MARK: - Country Picker Delegates

extension LandingAndPhoneInputVC: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        imgViewCountryCode.image = UIImage(named:/(detail["code"] as? String)?.lowercased())
        lblCountryCode.text = /(detail["dial_code"] as? String)
        
        imgViewCountryCode.isHidden = false
               lblFlagImage.isHidden  = true
        
        iso = /(detail["code"] as? String)
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    

    
}

//MARK:- API

extension LandingAndPhoneInputVC {
    
    func sendOtp(code:String, number:String) {
        
        let sendOTP = LoginEndpoint.sendOtp(countryCode: code, phoneNum: number, iso: iso)
        sendOTP.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let model = data as? SendOtp else { return }
                model.countryCode = code
                model.mobileNumber = number
                model.iso = self?.iso
                
                guard let vc = R.storyboard.mainCab.otpvC() else{return}
                vc.sendOTP = model
                self?.pushVC(vc)
                
                break
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
}

//MARK:- Common functions

extension LandingAndPhoneInputVC {
    
    
    func setIndicator(selectedIndex:Int){
        
        for (index,_) in self.arrayIndicatorConstraint.enumerated(){
            
            UIView.animate(withDuration: 0.2) { [unowned self] in
                
                self.arrayIndicatorConstraint[index].constant = index == selectedIndex ? self.currentIndicatorWidth : self.indicatorNormalWidth
                                
                if index == selectedIndex {
                    self.view.viewWithTag(index + 1)?.setViewBackgroundColorTheme()
                } else {
                   self.view.viewWithTag(index + 1)?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                }
                
               // self.view.viewWithTag(index + 1)?.backgroundColor = index == selectedIndex ? R.color.appPurple() : UIColor.lightGray.withAlphaComponent(0.4)
                
                
            }
            
        }
        
        self.currentIndex = selectedIndex
        
        self.view.layoutIfNeeded()
        
    }
    
    func openPhoneNumberView(isOpen:Bool){
        if isOpen {
            self.countryButton.isUserInteractionEnabled = true
        }else{
            self.countryButton.isUserInteractionEnabled = true
        }
        if !isOpen{
            self.txtFieldMobileNo.resignFirstResponder()
        }
        self.btnPhoneNumber.isUserInteractionEnabled = !isOpen
        self.isOpenPhoneNumberView = isOpen
        self.viewHeader.isHidden = !(/self.isOpenPhoneNumberView)
        self.lblSubtitleOtpWillBeSentTo.isHidden = !(/self.isOpenPhoneNumberView)
      //  view.layoutIfNeeded()

        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            
            self?.containerViewWalkthroughs.alpha = /self?.isOpenPhoneNumberView ? 0.0 : 1.0
            
            self?.lblheading.font = R.font.sfProTextBold(size: (/self?.isOpenPhoneNumberView) ? 18.0 : 14.0)
            
            
            let expandedBottomConstraint = ez.screenHeight - (/self?.containerViewPhoneNumber.bounds.height + /self?.viewHeader.bounds.height)
            
            self?.topConstraintWalkthrough.constant = (/self?.isOpenPhoneNumberView) ? -expandedBottomConstraint : 0.0
            
            let AdjustConstraint = UIDevice.current.iPhoneX ? 37 + 24 : 37
            
            self?.bottomConstraintPhoneNumberView.constant = (/self?.isOpenPhoneNumberView) ? expandedBottomConstraint - CGFloat(AdjustConstraint) : 0.0
            
            self?.view.layoutIfNeeded()
            
        }) { [weak self] (completion) in
            
            if isOpen{
                
                self?.txtFieldMobileNo.becomeFirstResponder()
                
            }
      
        
        }
        
        
    }
    
}
