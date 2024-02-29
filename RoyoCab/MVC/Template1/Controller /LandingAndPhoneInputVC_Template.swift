//
//  CarBuffesViewController.swift
//  Knowmoto

//  Created by cbl16 on 02/08/19.
//  Copyright © 2019 Codebbewlabs. All rights reserved.

//Code by Amandeep aman.code-brew@gmai.com

import UIKit

//import AWSS3
//let languageArry : [String] = ["english".localizedString , "urdu".localizedString ,"arabic".localizedString ,"chinese".localizedString]


class LandingAndPhoneInputVCTemplate1: BaseVCCab {
    //MARK:- OUTLETS
    
    @IBOutlet var txtFieldMobileNo: UITextField!
    @IBOutlet var imgViewCountryCode: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet weak var lblCountryAbbr: UILabel!
    @IBOutlet weak var btnNextTemplate1: UIButton!
    @IBOutlet weak var btnDownArrow: UIButton!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblCreatingAccount: UILabel!
    
    
    //@IBOutlet weak var bottomConstraintPhoneNumberView: NSLayoutConstraint!
    //@IBOutlet weak var viewHeader: UIView!
    //@IBOutlet weak var lblheading: UILabel!
    //@IBOutlet weak var lblSubtitleOtpWillBeSentTo: UILabel!
    //@IBOutlet var arrayIndicatorConstraint: [NSLayoutConstraint]!
    //@IBOutlet var arrrayIndicatorView: [UIView]!
    
    @IBOutlet var collectionTable: UICollectionView!

    
    //MARK:-PROPERTIES
    
    var HeadingCollectionViewDataSource:CollectionViewDataSourceCab?
    var iso: String?
    var isCheck = false
    private var currentIndicatorWidth:CGFloat = 16.0
    private var indicatorNormalWidth:CGFloat = 8.0
    
    private var isOpenPhoneNumberView:Bool = false
    
    public var arrayWalkThroughModel = [
        
        WalkThroughScreenModel(image: UIImage(named: "illustration_walkthrough_1"), title: "Book or Schedule Car Service", subtitle: "Book car service instantly or schedule it according to your needs."),
        WalkThroughScreenModel(image: UIImage(named: "illustration_walkthrough_1"), title: "Book or Schedule Car Service", subtitle: "Book car service instantly or schedule it according to your needs."),
        WalkThroughScreenModel(image: UIImage(named: "illustration_walkthrough_1"), title: "Book or Schedule Car Service", subtitle: "Book car service instantly or schedule it according to your needs.")
        
    ]
    var currentIndex:Int = 0
    
    deinit {
        debugPrint("Deintialized",String(describing: self))
    }
    
    
    //MARK:- LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                switch template {
                case .DeliverSome:
                    
        //            lblCreatingAccount.text = "By logging in,I agree to"
        //            btnTermsCondition.setTitle(" terms and conditions", for: .normal)
                    
                    lblCreatingAccount.attributedText =  Utility.sendAttString([R.font.sfProDisplayRegular(size: 14)!,R.font.sfProDisplayRegular(size: 14)!], colors: [UIColor.black,UIColor(hexString: "#9CCB53") ?? UIColor.black], texts: ["By logging in,I agree to"," terms and conditions"], align: .left)
                    
                default : break
                    
                }
        
        lblCreatingAccount.addTapGesture { (_) in
            
            self.acceptTerm()
        }
    }
    
    func countryFlag(countryCode: String) -> String {
      return String(String.UnicodeScalarView(
         countryCode.unicodeScalars.compactMap(
           { UnicodeScalar(127397 + $0.value) })))
    }
    
    private func initialSetup(){
        
        let iso = UDSingleton.shared.appSettings?.appSettings?.iso_code ?? DefaultCountry.ISO.rawValue
        guard let isoAlpha2 = CountryUtility.getISOAlpha2(isoAlpha3: /iso) else { return }
        lblCountryAbbr.text = iso.uppercased()
                   
        if let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist"),
           let arr:[NSDictionary] = NSArray(contentsOfFile: path) as? [NSDictionary]{

           let dict:[[String:AnyObject]] = arr.filter{($0["code"] as! String) == /isoAlpha2} as! [[String : AnyObject]]

           if let val = dict.first {
               let data = val as NSDictionary
               let dialCode = data.value(forKey: "dial_code") as! String
               lblCountryCode.text = dialCode
           }
        }
        
        //Theme Setting...
        btnNextTemplate1.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnCheck.tintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
        btnDownArrow.setButtonWithTintColorSecondary()
        btnTermsAndCondition.setButtonWithTitleColorSecondary()
       
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.setUpUI()
        }
        setupData()
    }

    func setUpUI() {
        
        self.view.backgroundColor = UIColor.white
        //self.setIndicator(selectedIndex: 0)
        //self.configureCollectionView()
        //btnNextAccessoryView.frame = CGRect(x: 0, y: 0, width: /ez.screenWidth, height: 48.0)
        btnNextAccessoryView.isHidden = true
        txtFieldMobileNo.delegate = self
        //txtFieldMobileNo.inputAccessoryView = btnNextAccessoryView
        txtFieldMobileNo.setAlignment()
 
    }
    
    func setupData() {
        
        //lblCountryCode.text = DefaultCountry.countryCode.rawValue
        iso = DefaultCountry.ISO.rawValue
        
        //imgViewCountryCode.image = UIImage(named: /iso?.lowercased())
    }
    
    
    //MARK:- Button actions
    @IBAction func checkBox(_ sender: Any) {
        if isCheck {
            isCheck = false
            btnCheck.setImage(#imageLiteral(resourceName: "ic_checkbox_inactive"), for: .normal)
        } else {
            isCheck = true
            btnCheck.setImage(#imageLiteral(resourceName: "ic_checkbox_active"), for: .normal)
        }
    }
    
    //next action
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        
        let code = /lblCountryCode.text
        let number = /txtFieldMobileNo.text?.trimmed()
        
        if Validations.sharedInstance.validatePhoneNumber(phone: number) {
            if isCheck {
                self.sendOtp(code: code, number: number)
            } else {
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please accept Terms and conditions" , type: .error)
            }
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
    
    
    @objc func acceptTerm(){
        
        guard let termsAndCondition = R.storyboard.mainCab.termsAndConditionsVC() else { return }
        termsAndCondition.strWebLink = APIBasePath.TermsConditions
        termsAndCondition.strNavTitle = "terms_and_conditions".localizedString
        //self.present(termsAndCondition, animated: true, completion: nil)
        self.navigationController?.pushViewController(termsAndCondition, animated: true)
    }
    
    @IBAction func actionTermsAndCondition(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
        
        guard let termsAndCondition = R.storyboard.mainCab.termsAndConditionsVC() else { return }
        termsAndCondition.strWebLink = APIBasePath.TermsConditions
        termsAndCondition.strNavTitle = "terms_and_conditions".localizedString
        //self.present(termsAndCondition, animated: true, completion: nil)
        self.navigationController?.pushViewController(termsAndCondition, animated: true)
    }
    
    
    //MARK:-Configuring Table View
    
    func configureCollectionView(){ //Configuring collection View cell
        
        
        let identifier = String(describing: WalkthroughCollectionViewCell.self)
        
        HeadingCollectionViewDataSource = CollectionViewDataSourceCab(items: [""], collectionView: collectionTable, cellIdentifier: identifier, headerIdentifier: nil, cellHeight: collectionTable.bounds.height, cellWidth: UIScreen.main.bounds.width, configureCellBlock: { (cell, item, indexPath) in
//
//            let _cell = cell as? WalkthroughCollectionViewCell
//            _cell?.model = item
            
        }, aRowSelectedListener: nil, willDisplayCell: nil) { [weak self] (scrollView) in
            
//            guard let indexPath = self?.collectionTable.getVisibleIndexOnScroll() else {return}
//            
//            if self?.currentIndex != indexPath.item{
//                
//                self?.setIndicator(selectedIndex: indexPath.item)
//                
//            }
            
        }
        
        collectionTable.dataSource = HeadingCollectionViewDataSource
        collectionTable.delegate = HeadingCollectionViewDataSource
        collectionTable.reloadData()
    }
    

}

//UItextfield delegates

extension LandingAndPhoneInputVCTemplate1 : UITextFieldDelegate {
    
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

extension LandingAndPhoneInputVCTemplate1: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
      //  imgViewCountryCode.image = UIImage(named:/(detail["code"] as? String)?.lowercased())
        lblCountryAbbr.text = /(detail["code"] as? String)
        lblCountryCode.text = /(detail["dial_code"] as? String)
        
        iso = /(detail["code"] as? String)
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    
    
}

//MARK:- API

extension LandingAndPhoneInputVCTemplate1 {
    
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

extension LandingAndPhoneInputVCTemplate1 {
    
    
    func setIndicator(selectedIndex:Int){
        
        //for (index,_) in self.arrayIndicatorConstraint.enumerated(){
//
//            UIView.animate(withDuration: 0.2) { [unowned self] in
//
//                self.arrayIndicatorConstraint[index].constant = index == selectedIndex ? self.currentIndicatorWidth : self.indicatorNormalWidth
//
//                self.view.viewWithTag(index + 1)?.backgroundColor = index == selectedIndex ? UIColor.black : UIColor.lightGray.withAlphaComponent(0.4)
//
//
//            }
//
//        }
        
        self.currentIndex = selectedIndex
        
        self.view.layoutIfNeeded()
        
    }
    
    func openPhoneNumberView(isOpen:Bool){
        
        if !isOpen{
            self.txtFieldMobileNo.resignFirstResponder()
        }

        self.isOpenPhoneNumberView = isOpen
      //  self.viewHeader.isHidden = !(/self.isOpenPhoneNumberView)
      //  self.lblSubtitleOtpWillBeSentTo.isHidden = !(/self.isOpenPhoneNumberView)
      //  view.layoutIfNeeded()

        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            
            //self?.containerViewWalkthroughs.alpha = /self?.isOpenPhoneNumberView ? 0.0 : 1.0
            
         //   self?.lblheading.font = R.font.sfProTextBold(size: (/self?.isOpenPhoneNumberView) ? 18.0 : 14.0)
            
            
//            let expandedBottomConstraint = ez.screenHeight - (/self?.containerViewPhoneNumber.bounds.height + 0)
//
//            self?.topConstraintWalkthrough.constant = (/self?.isOpenPhoneNumberView) ? -expandedBottomConstraint : 0.0
//
//            let AdjustConstraint = UIDevice.current.iPhoneX ? 37 + 24 : 37
//
//            self?.bottomConstraintPhoneNumberView.constant = (/self?.isOpenPhoneNumberView) ? expandedBottomConstraint - CGFloat(AdjustConstraint) : 0.0
            
            self?.view.layoutIfNeeded()
            
        }) { [weak self] (completion) in
            
            if isOpen{
                
                self?.txtFieldMobileNo.becomeFirstResponder()
                
            }
      
        
        }
        
        
    }
    
}
