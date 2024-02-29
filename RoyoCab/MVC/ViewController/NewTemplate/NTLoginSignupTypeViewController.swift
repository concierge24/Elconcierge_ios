//
//  NTLoginSignupTypeViewController.swift
//  RoyoRide
//
//  Created by Ankush on 14/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import AuthenticationServices

class NTLoginSignupTypeViewController: UIViewController {
    
    //MARK:- Enum
    enum ScreenType: String {
        case login
        case signup
    }
    
    //MARK:- Outlet
    @IBOutlet var collectionTable: UICollectionView!
    @IBOutlet var arrayIndicatorConstraint: [NSLayoutConstraint]!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAlreadyAccount: UILabel!
    
    @IBOutlet weak var buttonPhoneEmail: UIButton!
    @IBOutlet weak var buttonLoginSignup: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var continueWithAppleButtonStack: UIStackView!
    
    @IBOutlet weak var stackViewTerms: UIStackView!
    
    //MARK:- Properties
    var HeadingCollectionViewDataSource:CollectionViewDataSourceCab?
    var arrayWalkThroughModel : [Walkthrough]?
    
    var currentIndex:Int = 0
    var screenType: ScreenType = .login
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        
        
    }
}

//MARK:- Function

extension NTLoginSignupTypeViewController {
    
    fileprivate func initialSetup() {
        arrayWalkThroughModel = UDSingleton.shared.appSettings?.walk_through
        setUpUI()
        
        if #available(iOS 13.0, *) {
            setupAppleSigninButton()
            callAppleSignInHandler()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    fileprivate func setupAppleSigninButton() {
//        AppleSignIn.shared.setUpSignInAppleButton(stackView: continueWithAppleButtonStack)
    }
    
    fileprivate func callAppleSignInHandler() {
        
//        AppleSignIn.shared.didCompletedSignIn = {[weak self] (user) in
//            debugPrint(user.id ?? "", user.email ?? "", user.firstName ?? "", user.lastName ?? "", user.password ?? "")
//
//            self?.checkUserExist(social_key: user.id, login_as: LoginSignupType.Apple)
//        }
    }
    
    fileprivate func setUpUI() {
        
        buttonLoginSignup.setButtonWithTitleColorTheme()
        
        self.setIndicator(selectedIndex: 0)
        self.configureCollectionView()
        
        // App Name
        labelTitle.text = (screenType == .login ? "loginTo".localizedString : "Signupfor".localizedString)  + " " + "AppName".localizedString
        labelAlreadyAccount.text = screenType == .login ? "haveNoAccount".localizedString : "haveAlreadyAccount".localizedString
        
        let buttontitle = (screenType == .login ? "login".localizedString : "signup".localizedString ) + " " + "withPhoneEmail".localizedString
        buttonPhoneEmail.setTitle(buttontitle, for: .normal)
        
        let btnTitle = screenType == .login ? "signup".localizedString : "login".localizedString
        buttonLoginSignup.setTitle(btnTitle, for: .normal)
        
        stackViewTerms.isHidden = screenType == .login
        buttonCancel.isHidden = screenType == .login
        
    }
    
    fileprivate func configureCollectionView(){ //Configuring collection View cell
        
        
        let identifier = String(describing: WalkthroughCollectionViewCell.self)
        
        HeadingCollectionViewDataSource = CollectionViewDataSourceCab(items: arrayWalkThroughModel, collectionView: collectionTable, cellIdentifier: identifier, headerIdentifier: nil, cellHeight: collectionTable.bounds.height, cellWidth: UIScreen.main.bounds.width, configureCellBlock: { (cell, item, indexPath) in
            
            let _cell = cell as? WalkthroughCollectionViewCell
            _cell?.model = item
            
        }, aRowSelectedListener: nil, willDisplayCell: nil) { [weak self] (scrollView) in
            
            guard let indexPath = self?.collectionTable.getVisibleIndexOnScroll() else {return}
            
            if self?.currentIndex != indexPath.item {
                
                self?.setIndicator(selectedIndex: indexPath.item)
                
            }
            
        }
        
        collectionTable.dataSource = HeadingCollectionViewDataSource
        collectionTable.delegate = HeadingCollectionViewDataSource
        collectionTable.reloadData()
    }
    
    func setIndicator(selectedIndex:Int){
        
        for (index,_) in self.arrayIndicatorConstraint.enumerated(){
            
            UIView.animate(withDuration: 0.2) { [unowned self] in
                
                //  self.arrayIndicatorConstraint[index].constant = index == selectedIndex ? self.currentIndicatorWidth : self.indicatorNormalWidth
                
                if index == selectedIndex {
                    self.view.viewWithTag(index + 101)?.backgroundColor = .white
                    // self.view.viewWithTag(index + 1)?.setThemeBackground()
                } else {
                    self.view.viewWithTag(index + 101)?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
                }
                
                // self.view.viewWithTag(index + 1)?.backgroundColor = index == selectedIndex ? R.color.appPurple() : UIColor.lightGray.withAlphaComponent(0.4)
                
                
            }
            
        }
        
        self.currentIndex = selectedIndex
        
        self.view.layoutIfNeeded()
        
    }
    
}


//MARK:- Button Selector

extension NTLoginSignupTypeViewController {
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        // 1 - cancel, 2- QuestionMark, 3- PhoneEmail, 4- Facebook, 5- Google, 6- Apple, 7- Institution Account, 8- Terms, 9- Privacy, 10- LoginSignup
        
        switch sender.tag {
        case 1:
            popVC()
            
        case 2:
            debugPrint("Question")
            
        case 3:
            switch screenType {
                
            case .login:
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntLoginViewController() else {return}
                pushVC(vc)
                
            case .signup:
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntSignupViewController() else {return}
                pushVC(vc)
            }
            
        case 4:
            debugPrint("Facebook")
//            FBLogin.shared.login {[weak self] (userData) in
//
//                debugPrint(userData as Any)
//                self?.checkUserExist(social_key: userData?.id, login_as: LoginSignupType.Facebook)
//            }
            
        case 5:
            debugPrint("Google")
//            GoogleSignIn.shared.openGoogleSigin {[weak self] (userData) in
//                
//                debugPrint(userData as Any)
//                self?.checkUserExist(social_key: userData?.id, login_as: LoginSignupType.Gmail)
//            }
            
        case 6:
            debugPrint("Apple")
            
            
        case 7:
            switch screenType {
                
            case .login:
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntLoginViewController() else {return}
                vc.screenType = .emailInstitution
                pushVC(vc)
                
            case .signup:
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntSignupInstitutionViewController() else {return}
                pushVC(vc)
            }
            
        case 8:
            debugPrint("Terms")
            
        case 9:
            debugPrint("Privacy")
            
        case 10:
            debugPrint("LoginSignup")
            
            switch screenType {
                
            case .login:
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntLoginSignupTypeViewController() else {return}
                vc.screenType = .signup
                pushVC(vc)
                
            case .signup:
                popVC()
            }
            
        default:
            break
        }
    }
}


//MARK:- API

extension NTLoginSignupTypeViewController {
    
    func socialLogin(social_key: String?, login_as: LoginSignupType?) {
        
        guard let accountType = login_as else {return}
        
        let socialLogin = LoginEndpoint.socailLogin(social_key: social_key, login_as: accountType.rawValue)
        
        socialLogin.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) { (response) in
            switch response {
                
            case .success(let data):
                
               guard let model = data as? LoginDetail else { return }
               
               UDSingleton.shared.userData = model
               let appDelegate = UIApplication.shared.delegate as? AppDelegate
               appDelegate?.setHomeAsRootVC()
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
    
    func checkUserExist(social_key: String?, login_as: LoginSignupType?) {
        
        guard let accountType = login_as else {return}
        
        let checkUserExist = LoginEndpoint.checkuserExists(social_key: social_key, login_as: accountType.rawValue)
        
        checkUserExist.request( header: [:]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                debugPrint(data as Any)
                
                guard let model = data as? CheckUserExistModel else { return }
                
                if /model.AppDetail?.userExists {
                    
                    self?.socialLogin(social_key: social_key, login_as: login_as)
                    
                } else {
                    guard let vc = R.storyboard.newTemplateLoginSignUp.ntAddPhoneNumberViewController() else {return}
                    vc.signup_as = accountType
                    vc.socialId = social_key
                    self?.pushVC(vc)
                }
                             
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
}
