//
//  OrderPricing.swift
//  Buraq24
//
//  Created by MANINDER on 27/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit


class OrderPricing: UIView {
    
    //MARK:- Outlets
    //MARK:-
    @IBOutlet var lblBrandName: UILabel!
    @IBOutlet var lblOrderDetails: UILabel!
    @IBOutlet var lblFinalPrice: UILabel!
    
    @IBOutlet weak var txtInfoTotal: UILabel!
    @IBOutlet var btnBookService: UIButton!
    
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet var imgViewPaymentType: UIImageView!
    @IBOutlet var imgViewPromoCodeType: UIImageView!

    @IBOutlet weak var lblCreatedHeading: UILabel!
    @IBOutlet weak var paymentSelectionStack: UIStackView!
    @IBOutlet weak var buttonApplyPromo: UIButton!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblPromoCodeType: UILabel!
    
    @IBOutlet weak var labelSeatCapacity: UILabel!
    
    @IBOutlet weak var textFieldPromo: UITextField!
    @IBOutlet weak var imageViewVehicle: UIImageView!
    @IBOutlet weak var labelCreditPoints: UILabel!
    
    @IBOutlet weak var buttonCreditCard: UIButton!
    
    @IBOutlet weak var creditPointView: UIStackView!
    @IBOutlet weak var paymentStack:UIStackView!
    @IBOutlet weak var buttonCash: UIButton!
    @IBOutlet weak var switchCreditPoints: UISwitch!
    
    @IBOutlet weak var goMovePricingView: UIView!
    @IBOutlet weak var heightCreditConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var genderStack: UIStackView!
    @IBOutlet weak var carpoolStack: UIStackView!
    
    @IBOutlet weak var lblNewPrice: UILabel!
    @IBOutlet weak var lblNewCurrency: UILabel!

    @IBOutlet weak var sepView: UIView!
    
    
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var lblSeatCOunt: UILabel!
    @IBOutlet weak var lblTotalPassengerAmount: UILabel!
    @IBOutlet weak var lblTotalPassenger: UILabel!
    @IBOutlet weak var viewPoolAmount: UIView!
    @IBOutlet weak var viewPoolSwitch: UIStackView!
    

    
    var viewSuper : UIView?
    
    //MARK:- Properties
    //MARK:-
    
    var isAdded : Bool = false
    var request : ServiceRequest = ServiceRequest()
    var modalPackages: TravelPackages?
    var frameHeight : CGFloat = 350
    var delegate : BookRequestDelegate?
    var CalculatedPriceBeforePromo: Float?
    var selectedPackageProduct: ProductCab?
    var isAppliedPromo: Bool = false
    var couponID: Int?
    var couponCode:String?
    var gender = "Male"
    var paymentMode: PaymentType = .Cash
    var minimumAmount = 0
    var walletAmount = 0
    var selectedPoolSeat = 1{
        
        didSet{
            
            calculatePoolPrice()
        }
    }
    
    //MARK:- Actions
    //MARK:-
    
    @IBAction func actionBtnBookPressed(_ sender: UIButton) {
        
        
        if /request.isPool{
            
            request.numberOfRiders = "\(selectedPoolSeat)"
        }
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .GoMove:
            
            if /request.selectedCard?.lastDigit == "" {
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please select card to proceed.".localizedString , type: .error )
            } else {
                guard let vc = R.storyboard.bookService.confirmBookingVC() else {return}
                   vc.modalPresentationStyle = .overCurrentContext
                   vc.confirmationStatus = {[weak self] (status) in
                       
                       if status{
                           
                           DispatchQueue.main.async {
                               
                               self?.request.finalPrice = self?.lblFinalPrice.text
                               self?.request.distance_price_fixed = String(/self?.selectedPackageProduct?.distance_price_fixed)
                               self?.request.price_per_min = String(/self?.selectedPackageProduct?.price_per_min)
                               self?.request.time_fixed_price = String(/self?.selectedPackageProduct?.time_fixed_price)
                               self?.request.price_per_km = String(/self?.selectedPackageProduct?.price_per_km)
                               self?.request.coupon_id = self?.couponID
                            self?.request.coupon_code = self?.couponCode
                               self?.request.gender = self?.gender
                               if let request = self?.request{
                                   self?.delegate?.didClickConfirmBooking(request: request)
                               }
                           }
                       }
                       
                   }
                   (ez.topMostVC as? HomeVC)?.presentVC(vc, false)
            }
            
            
        default:
            request.finalPrice = lblFinalPrice.text
            request.distance_price_fixed = String(/selectedPackageProduct?.distance_price_fixed)
            request.price_per_min = String(/selectedPackageProduct?.price_per_min)
            request.time_fixed_price = String(/selectedPackageProduct?.time_fixed_price)
            request.price_per_km = String(/selectedPackageProduct?.price_per_km)
            request.coupon_id = couponID
            request.coupon_code = couponCode
            request.gender = gender
            request.paymentMode = paymentMode
            
            delegate?.didClickConfirmBooking(request: request)
        }
        
        
//        if /request.serviceSelected?.serviceCategoryId != 1 {
//           alertBoxOk(message:"work_in_progress".localizedString , title: "AppName".localizedString, ok: {
//            })
//            return
//        }else{
        
       // self.delegate?.didClickConfirmBooking(finalPrice: lblFinalPrice.text, selectedPackageProduct: self.selectedPackageProduct)
        
        
         // Ankush Temp commented   minimizeOrderPricingView()
        
    // Ankush Temp Commented self.delegate?.didSelectNext(type: .SubmitOrder) // Need to handle
       // }
        
    }
    
    @IBAction func switchCarPoolAction(_ sender: UISwitch) {
        
        request.booking_type = sender.isOn ? "CarPool" : ""
        request.isPool = sender.isOn
        viewPoolAmount.isHidden = !sender.isOn
        
        if !sender.isOn{
             selectedPoolSeat = 1
            
        }
        
        sender.isOn ? calculatePriceForPoolBooking() : calculatePriceForNormalBooking()
    }
    
    @IBAction func btnDecreaseAction(_ sender: Any) {
        
        if selectedPoolSeat > 1{
            
            selectedPoolSeat -= 1
        }
        
        calculatePriceForPoolBooking()
        
        
    }
    
 
    
    @IBAction func btnIncreaseAction(_ sender: Any) {
        
        if selectedPoolSeat < (/request.selectedProduct?.seating_capacity){
              
              selectedPoolSeat += 1
          }
        
         calculatePriceForPoolBooking()
    }
    
    
     func calculatePoolPrice(){
         
         lblSeatCOunt.text = "\(selectedPoolSeat)"
     }
    
    @IBAction func actionBtnPaymentType(_ sender: UIButton) {
        
        // 1- Credit card, 2- Cash
        
        
        switch sender.tag {
            
        case 1:
            
            buttonCreditCard.setButtonWithTitleAndBorderColorSecondary()
            buttonCreditCard.setButtonWithTintColorSecondary()
            
            buttonCash.layer.borderColor = UIColor.lightGray.cgColor
            buttonCash.tintColor =  UIColor.lightGray
            buttonCash.setTitleColor(.lightGray, for: .normal)
            
            let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
                        
            switch paymentGateway {
            case .paystack,.payku,.braintree:
                print("Not navigate to card list..")
                break
                
            default:
                guard let vc = R.storyboard.sideMenu.cardListViewController() else {return}
                vc.delegate = ez.topMostVC as? HomeVC
                (ez.topMostVC as? HomeVC)?.pushVC(vc)
            }
            
            request.paymentMode = .Card
            paymentMode = .Card
            
           /* buttonCreditCard.layer.borderColor = R.color.appNewRedBorder()?.cgColor
            buttonCreditCard.setImage(R.image.ic_card_active(), for: .normal)
            buttonCreditCard.setTitleColor(R.color.appPurple(), for: .normal)
            
            buttonCash.layer.borderColor = UIColor.lightGray.cgColor
            buttonCash.setImage(R.image.ic_cash_inactive(), for: .normal)
            buttonCash.setTitleColor(.lightGray, for: .normal)
            
            request.paymentMode = .Card */
            
        case 2:
            
            buttonCash.setButtonWithTitleAndBorderColorSecondary()
            buttonCash.setButtonWithTintColorSecondary()
                               
           //buttonCash.layer.borderColor = R.color.appNewRedBorder()?.cgColor
           //buttonCash.setImage(R.image.ic_cash_active(), for: .normal)
           //buttonCash.setTitleColor(R.color.appPurple(), for: .normal)
                      
           buttonCreditCard.layer.borderColor = UIColor.lightGray.cgColor
           buttonCreditCard.tintColor =  UIColor.lightGray
           buttonCreditCard.setTitleColor(.lightGray, for: .normal)
           buttonCreditCard.setTitle("Credit Card".localizedString , for: .normal)
            
           delegate?.didPaymentModeChanged(paymentMode: .Cash, selectedCard: nil)
            
           request.paymentMode = .Cash
           paymentMode = .Cash
            
          /*  buttonCash.layer.borderColor = R.color.appNewRedBorder()?.cgColor
            buttonCash.setImage(R.image.ic_cash_active(), for: .normal)
            buttonCash.setTitleColor(R.color.appPurple(), for: .normal)
                       
            buttonCreditCard.layer.borderColor = UIColor.lightGray.cgColor
            buttonCreditCard.setImage(R.image.ic_card_inactive(), for: .normal)
            buttonCreditCard.setTitleColor(.lightGray, for: .normal)
            
            request.paymentMode = .Cash
            request.selectedCard = nil */
            
        default:
            break
        }
        
    }
    
    @IBAction func actionBtnPromoCodePressed(_ sender: UIButton) {

        if isAppliedPromo {
            textFieldPromo.text = nil
            couponID = nil
            couponCode = nil
            buttonApplyPromo.setTitle("APPLY PROMO CODE".localizedString, for: .normal)
            buttonApplyPromo.setTitleColor(R.color.appPurple(), for: .normal)
            
            isAppliedPromo = false
            lblFinalPrice.text =  String(/CalculatedPriceBeforePromo).getTwoDecimalFloat()
             lblNewPrice.text =  String(/CalculatedPriceBeforePromo).getTwoDecimalFloat()
            
        } else {
            guard let vc = R.storyboard.bookService.promoCodeViewController() else {return}
                   vc.modalPresentationStyle = .overFullScreen
                   vc.delegate = (ez.topMostVC as? HomeVC)
                   (ez.topMostVC as? HomeVC)?.presentVC(vc)
        }
        
       
        
      //  self.delegate?.didSelectNext(type: .Payment)

       // Alerts.shared.show(alert: "AppName".localizedString, message: "coming_soon".localizedString , type: .error )
    }
    
    @IBAction func buttonInfoClicked(_ sender: Any) {
        
        guard let vc = R.storyboard.bookService.fareBreakdownViewController() else {return}
        vc.product = request.selectedProduct
        (ez.topMostVC as? HomeVC)?.presentVC(vc)
        
    }
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        
        if sender.isOn {
           
            if Bool(/UDSingleton.shared.appSettings?.appSettings?.is_wallet) ?? false {
                if walletAmount < minimumAmount {
                    alertBoxOk(message: "Your balance is less than minimum required amount, you may not be able to book ride".localizedString, title: "AppName".localizedString, ok: {})
                } else {
                    request.paymentMode = .Wallet
                    paymentMode = .Wallet
                    self.paymentStack.isHidden = true
                   // self.frame.size.height = frameHeight - 54
                    self.sepView.isHidden = true
                }
               
                
            } else {
                if request.paymentMode == .Cash {
                       alertBoxOk(message: "can't_use_credit_point".localizedString, title: "AppName".localizedString, ok: {})
                       switchCreditPoints.setOn(false, animated: true)
                       return
                   }
                   
                   
                   if sender.isOn {
                       request.credit_point_used = labelCreditPoints.text
                   } else {
                       request.credit_point_used = nil
                   }
            }
            
        } else {
            self.paymentStack.isHidden = false
           // self.frame.size.height = frameHeight
             self.sepView.isHidden = false
        }
                
    }
    
    
    @IBAction func gnderSelectionSementType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
           {
           case 0:
               gender = "Male"
           case 1:
               gender = "Female"
           default:
               break
           }
        
    }
    
    
    //MARK:- Functions
    
    func minimizeOrderPricingView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            }, completion: { (done) in
        })
    }
    
    func maximizeOrderPricingView() {
        
        let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
        switch paymentGateway {
        case .razorpay:
            paymentMode = .Card
            break
        default:
            break
        }
        
       
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        lblCurrency.text = (/UDSingleton.shared.appSettings?.appSettings?.currency)
        let isPool = /request.selectedProduct?.pool == "true" ? true : false
        viewPoolSwitch.isHidden = !isPool
        switch template {
        case .DeliverSome:
            genderStack.isHidden = true
            heightCreditConstraint.constant = 0
            creditPointView.isHidden = true
            goMovePricingView.isHidden = true
           // frameHeight =  UIDevice.current.iPhoneX ? 300 + 34  : 300
            frameHeight =  isPool ? (UIDevice.current.iPhoneX ? 420 + 34  : 420) : (UIDevice.current.iPhoneX ? 300 + 34  : 300)
            break
            
        case .GoMove:
             //carpoolStack.isHidden = true
             buttonCreditCard.setButtonWithTitleAndBorderColorSecondary()
             buttonCreditCard.setButtonWithTintColorSecondary()
             buttonCash.isHidden = true
             genderStack.isHidden = true
             goMovePricingView.isHidden = false
            // frameHeight =  UIDevice.current.iPhoneX ? 350 + 34  : 350
             frameHeight =  isPool ? (UIDevice.current.iPhoneX ? 350 + 34  : 350) :  (UIDevice.current.iPhoneX ? 350 + 34  : 350)
             
             break
            
        default:
            genderStack.isHidden = false
            goMovePricingView.isHidden = true
            creditPointView.isHidden = false
           // frameHeight =  UIDevice.current.iPhoneX ? 380 + 34  : 380
            frameHeight =  isPool ? (UIDevice.current.iPhoneX ? 450 + 34  : 450) : (UIDevice.current.iPhoneX ? 380 + 34  : 380)
            break
        }
        
        
         lblNewCurrency.text = /UDSingleton.shared.appSettings?.appSettings?.currency
        
        if modalPackages != nil {
            frameHeight = frameHeight - 26 // Height of promo StackView
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
           
         // Ankush   self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.frameHeight , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.frameHeight + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
                
        })
    }
    
    func setupUI() {
        
//        let gatewayType = /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id
//                   
//       switch gatewayType {
//       case GatewayType.Paystack.rawValue:
//        paymentSelectionStack.isHidden = true
//        break
//           
//       default:
//          paymentSelectionStack.isHidden = false
//       }
        
        textFieldPromo.placeholder = "Promo code".localizedString
        btnBookService.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        buttonCash.setButtonWithTitleAndBorderColorSecondary()
        buttonCash.setButtonWithTintColorSecondary()
        
        buttonCreditCard.setButtonBorderTitleAndTintColor()
        buttonCash.setButtonBorderTitleAndTintColor()
       // buttonCreditCard.setButtonWithTintColorSecondary()
        
        buttonApplyPromo.setButtonWithTitleColorSecondary()
        switchCreditPoints.setSwitchTintColorSecondary()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentController.setTitleTextAttributes(titleTextAttributes, for: .selected)
        if #available(iOS 13.0, *) {
            segmentController.selectedSegmentTintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
        } else {
            // Fallback on earlier versions
        }
               
               switch request.paymentMode {
               case .Card:
                   
                    buttonCreditCard.setButtonWithTitleAndBorderColorSecondary()
                    buttonCreditCard.setButtonWithTintColorSecondary()
                
                   //buttonCreditCard.layer.borderColor = R.color.appNewRedBorder()?.cgColor
                   //buttonCreditCard.setImage(R.image.ic_card_active(), for: .normal)
                   //buttonCreditCard.setTitleColor(R.color.appPurple(), for: .normal)
                   
                   buttonCash.layer.borderColor = UIColor.lightGray.cgColor
                   buttonCash.tintColor =  UIColor.lightGray
                   buttonCash.setTitleColor(.lightGray, for: .normal)
                   
                  
                   
                case .Cash:
                   
                    buttonCash.setButtonWithTitleAndBorderColorSecondary()
                    buttonCash.setButtonWithTintColorSecondary()
                    
                    //buttonCash.layer.borderColor = R.color.appNewRedBorder()?.cgColor
                    //buttonCash.setImage(R.image.ic_cash_active(), for: .normal)
                    //buttonCash.setTitleColor(R.color.appPurple(), for: .normal)
                    let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                    switch template {
                    case .GoMove:
                       buttonCreditCard.setButtonWithTitleAndBorderColorSecondary()
                       buttonCreditCard.setButtonWithTintColorSecondary()
                        break
                        
                    default:
                        buttonCreditCard.layer.borderColor = UIColor.lightGray.cgColor
                        buttonCreditCard.tintColor =  UIColor.lightGray
                        buttonCreditCard.setTitleColor(.lightGray, for: .normal)
                        buttonCreditCard.setTitle("Credit Card".localizedString , for: .normal)
                                 
                    }
                               
                  
                    
                    request.credit_point_used = nil
                    switchCreditPoints.setOn(false, animated: true)
                   
               default:
                   break
                   
                   }
    }
    
    func setWalletData(wallet: WalletDetails?) {
        lblCreatedHeading.text = "Use Wallet Amount".localizedString
        minimumAmount = Int(/wallet?.details?.minBalance) ?? 0
        walletAmount = /wallet?.amount
        
        if /wallet?.amount == 0 {
            labelCreditPoints.text =  String(/wallet?.amount)
            switchCreditPoints.isUserInteractionEnabled = false
            
        } else {
            switchCreditPoints.isUserInteractionEnabled = true
            creditPointView.isHidden = false
            labelCreditPoints.text =  String(/wallet?.amount)
        }
    }
    
    func setCreditPoints(points: Float?) {
        lblCreatedHeading.text = "Use Credit Amount".localizedString
        labelCreditPoints.text =  String(/points)
    }
    
    func showOrderPricingView(superView : UIView , moveType : MoveType ,requestPara : ServiceRequest, modalPackages: TravelPackages? = nil ) {
        request = requestPara
        self.modalPackages = modalPackages
        
        isAppliedPromo = false
        couponID = nil
        couponCode = nil
        
        request.paymentMode = .Cash
        updatePaymentMode(service: request)
        
        switchCreditPoints.setOn(false, animated: true)
        request.credit_point_used = nil
        
      /*  buttonCash.layer.borderColor = R.color.appNewRedBorder()?.cgColor
        buttonCash.setImage(R.image.ic_cash_active(), for: .normal)
        buttonCash.setTitleColor(R.color.appPurple(), for: .normal)
                   
        buttonCreditCard.layer.borderColor = UIColor.lightGray.cgColor
        buttonCreditCard.setImage(R.image.ic_card_inactive(), for: .normal)
        buttonCreditCard.setTitleColor(.lightGray, for: .normal)
        
        request.paymentMode = .Cash */
        
        if !isAdded {
            
           // Ankush frameHeight =  superView.frame.size.width*70/100
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
        }
         assignData()
         maximizeOrderPricingView()
    }
    
    
    func assignData() {
        
        
      /* Ankush  if    BundleLocalization.sharedInstance().language == Languages.English{
            if request.serviceSelected?.serviceCategoryId == 3{
                txtInfoTotal.text = "Base price"
            }
            else{
                txtInfoTotal.text = "Total"
            }
        }
        
         lblBrandName.text =  /request.serviceSelected?.serviceCategoryId != 2 ?   /request.serviceSelected?.serviceName : /request.selectedBrand?.brandName
        
        
        
        if  /request.serviceSelected?.serviceCategoryId == 4 {
            
             lblOrderDetails.text =   /request.selectedProduct?.productName
            lblBrandName.text =   /request.selectedBrand?.brandName
            
        } else if /request.serviceSelected?.serviceCategoryId == 7  {
            
            lblBrandName.text =   /request.serviceSelected?.serviceName
            lblOrderDetails.text =  /request.selectedBrand?.brandName + " : "  + /request.selectedProduct?.productName
            
        } else{
            
            lblBrandName.text =   /request.serviceSelected?.serviceName
               lblOrderDetails.text =   /request.productName + " × " +  String(request.quantity)
        } */

        textFieldPromo.isHidden = modalPackages != nil
        buttonApplyPromo.isHidden = modalPackages != nil
        btnBookService.titleLabel?.textAlignment = .center
        
       // imageViewVehicle?.image = request.selectedBrand?.categoryBrandId == 20 ? R.image.ic_micro_inactive() : R.image.ic_bike_inactive()
        imageViewVehicle.sd_setImage(with: request.selectedBrand?.imageURL, completed: nil)
        
        lblBrandName.text =  /request.selectedProduct?.productName // Ankush
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .DeliverSome?:
             labelSeatCapacity.text = ""
             buttonCreditCard.isHidden = false
             buttonCash.isHidden = true
            
        default:
            
            if request.selectedBrand?.categoryId == 4 {
                labelSeatCapacity.text = ""
            } else {
                labelSeatCapacity.text = "\("Seating capacity".localizedString) : \(/request.selectedProduct?.seating_capacity)"
            }
            
        }
        
        
        
        
        textFieldPromo.text = nil
        
        buttonApplyPromo.setTitle("APPLY PROMO CODE".localizedString, for: .normal)
        buttonApplyPromo.setButtonWithTitleColorSecondary()
        
        if modalPackages == nil {
            
          /*  var totalCost : Float = 0.0
            
            //Price based on distance
            
            if let pricePPD = request.selectedProduct?.pricePerDistance {
                totalCost = totalCost + (pricePPD * request.distance)
            }
            
            //Price based on time
            if let pricePPM = request.selectedProduct?.price_per_hr {
                totalCost = totalCost + (pricePPM * /request.duration)
            }
            
            /* Ankush  if let pricePPQ = request.selectedProduct?.pricePerQuantity{
             totalCost = totalCost + (pricePPQ * Float(request.quantity))
             } */
            
           
            totalCost = totalCost + Float(/request.selectedProduct?.alphaPrice) // Base price
                        
            if /UDSingleton.shared.appSettings?.appSettings?.schedule_fee == "true" && request.requestType == .Future{
                
                let type = /self.request.selectedProduct?.schedule_charge_type
                
                if type == "value"{
                    
                    totalCost = totalCost + Float(/self.request.selectedProduct?.schedule_charge)
                }
                else{
                    
                    totalCost = totalCost + ((totalCost * Float(/self.request.selectedProduct?.schedule_charge)) / 100.0)
                }
            }
            
            // Ankush  totalCost = totalCost + totalCost.getBuraqShare(percent: /request.serviceSelected?.buraqPercentage)
            // Ankush  lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat() + " " + "currency".localizedString
            if let percentage = request.selectedBrand?.buraq_percentage {
                totalCost = totalCost + ((totalCost * percentage) / 100.0)
            }
            
                            
            
            //Time require to level charge -> calculated the price value
//           let appTemp  = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
//            switch appTemp {
//                case .GoMove:
//                    totalCost = calculateGomovePricing()
//                    break
//           
//                default:
//                    break
//               
//           }
            
            
            //Adding Surchange Value
//            if Bool(/UDSingleton.shared.appSettings?.appSettings?.surCharge) ?? false {
//                let surchargePercentage = Float(/UDSingleton.shared.appSettings?.appSettings?.surChargePercentage)
//                totalCost = totalCost + ((totalCost * /surchargePercentage) / 100.0)
//            }
            
            

            //Time require to level charge -> calculated the price value
           let appTemp  = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch appTemp {
                case .GoMove:
                    totalCost = calculateGomovePricing()
                    break
           
                default:
                    break
               
           }
            
            if Bool(/UDSingleton.shared.appSettings?.appSettings?.surCharge) ?? false {
                let surchargeCalculatedAmount = calculateSurchargeWithTimeSlot(totalCost: totalCost)
                totalCost = totalCost + surchargeCalculatedAmount
            }
            CalculatedPriceBeforePromo = totalCost
            lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat()
            lblNewPrice.text = String(totalCost).getTwoDecimalFloat()*/
            
            if /request.isPool{
                
                calculatePriceForPoolBooking()
            }
            else{
                
                calculatePriceForNormalBooking()
            }
            
            
        } else {
            
            guard let selectedBrand = modalPackages?.package?.pricingData?.categoryBrands?.filter({$0.categoryBrandId == request.selectedBrand?.categoryBrandId}).first,
                  let selectedProduct = selectedBrand.products?.filter({$0.productBrandId == request.selectedProduct?.productBrandId}).first else {return}

            self.selectedPackageProduct = selectedProduct
            CalculatedPriceBeforePromo = /selectedProduct.distance_price_fixed
            lblFinalPrice.text = String(/selectedProduct.distance_price_fixed).getTwoDecimalFloat()
            lblNewPrice.text =  String(/selectedProduct.distance_price_fixed).getTwoDecimalFloat()
        }
        
       
        
        if request.requestType == .Future {
           
            let strOrderType = "schedule".localizedString
            let strDate = strOrderType + "\n" + request.orderDateTime.toLocalDateAcTOLocale() + ", " + request.orderDateTime.toLocalTimeAcTOLocale()
            btnBookService.setTitle( strDate, for: .normal)
            
        }else{
            
            let strOrderType = "booking".localizedString
            btnBookService.setTitle( strOrderType, for: .normal)
            
           /* if BundleLocalization.sharedInstance().language == Languages.English{
                
                if request.serviceSelected?.serviceCategoryId == 2{
                    btnBookService.setTitle("Order Now", for: .normal)
                }
                else{
                    btnBookService.setTitle("Book Now", for: .normal)
                }
            }
            else{
                btnBookService.setTitle( "book_now".localizedString, for: .normal)
            } */
            
        }
      
    }
    
    
    func calculatePriceForNormalBooking(){
                
                var totalCost : Float = 0.0
                
                //Price based on distance
                
                if let pricePPD = request.selectedProduct?.pricePerDistance {
                    totalCost = totalCost + (pricePPD * request.distance)
                }
                
                //Price based on time
                if let pricePPM = request.selectedProduct?.price_per_hr {
                    totalCost = totalCost + (pricePPM * /request.duration)
                }
                
                /* Ankush  if let pricePPQ = request.selectedProduct?.pricePerQuantity{
                 totalCost = totalCost + (pricePPQ * Float(request.quantity))
                 } */
                
               
                totalCost = totalCost + Float(/request.selectedProduct?.alphaPrice) // Base price
                            
                if /UDSingleton.shared.appSettings?.appSettings?.schedule_fee == "true" && request.requestType == .Future{
                    
                    let type = /self.request.selectedProduct?.schedule_charge_type
                    
                    if type == "value"{
                        
                        totalCost = totalCost + Float(/self.request.selectedProduct?.schedule_charge)
                    }
                    else{
                        
                        totalCost = totalCost + ((totalCost * Float(/self.request.selectedProduct?.schedule_charge)) / 100.0)
                    }
                }
                
                // Ankush  totalCost = totalCost + totalCost.getBuraqShare(percent: /request.serviceSelected?.buraqPercentage)
                // Ankush  lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat() + " " + "currency".localizedString
                if let percentage = request.selectedBrand?.buraq_percentage {
                    totalCost = totalCost + ((totalCost * percentage) / 100.0)
                }
                
                                
                
                //Time require to level charge -> calculated the price value
    //           let appTemp  = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
    //            switch appTemp {
    //                case .GoMove:
    //                    totalCost = calculateGomovePricing()
    //                    break
    //
    //                default:
    //                    break
    //
    //           }
                
                
                //Adding Surchange Value
    //            if Bool(/UDSingleton.shared.appSettings?.appSettings?.surCharge) ?? false {
    //                let surchargePercentage = Float(/UDSingleton.shared.appSettings?.appSettings?.surChargePercentage)
    //                totalCost = totalCost + ((totalCost * /surchargePercentage) / 100.0)
    //            }
                
                

                //Time require to level charge -> calculated the price value
               let appTemp  = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                switch appTemp {
                    case .GoMove:
                        totalCost = calculateGomovePricing()
                        break
               
                    default:
                        break
                   
               }
                
                if Bool(/UDSingleton.shared.appSettings?.appSettings?.surCharge) ?? false {
                    let surchargeCalculatedAmount = calculateSurchargeWithTimeSlot(totalCost: totalCost)
                    totalCost = totalCost + surchargeCalculatedAmount
                }
                CalculatedPriceBeforePromo = totalCost
                lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat()
                lblNewPrice.text = String(totalCost).getTwoDecimalFloat()
                
            }
    
    
    func calculatePriceForPoolBooking(){
                
                var totalCost : Float = 0.0
                
                //Price based on distance
                var poolPricePerDistance = Float()
                var poolPricePerHour = Float()
                
                if let pricePPD = request.selectedProduct?.pool_price_per_distance {
                    poolPricePerDistance =  (pricePPD * request.distance)
                }
                
                //Price based on time
                if let pricePPM = request.selectedProduct?.pool_price_per_hr {
                    poolPricePerHour = (pricePPM * /request.duration)
                }
                
                /* Ankush  if let pricePPQ = request.selectedProduct?.pricePerQuantity{
                 totalCost = totalCost + (pricePPQ * Float(request.quantity))
                 } */
                let priceBySeat = ((poolPricePerDistance + poolPricePerHour) * Float(selectedPoolSeat))
               
                totalCost = totalCost + Float(/request.selectedProduct?.pool_alpha_price) + priceBySeat // Base price
                            
                if /UDSingleton.shared.appSettings?.appSettings?.schedule_fee == "true" && request.requestType == .Future{
                    
                    let type = /self.request.selectedProduct?.schedule_charge_type
                    
                    if type == "value"{
                        
                        totalCost = totalCost + Float(/self.request.selectedProduct?.schedule_charge)
                    }
                    else{
                        
                        totalCost = totalCost + ((totalCost * Float(/self.request.selectedProduct?.schedule_charge)) / 100.0)
                    }
                }
                
                // Ankush  totalCost = totalCost + totalCost.getBuraqShare(percent: /request.serviceSelected?.buraqPercentage)
                // Ankush  lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat() + " " + "currency".localizedString
                if let percentage = request.selectedBrand?.buraq_percentage {
                    totalCost = totalCost + ((totalCost * percentage) / 100.0)
                }
                
                                
                
                //Time require to level charge -> calculated the price value
    //           let appTemp  = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
    //            switch appTemp {
    //                case .GoMove:
    //                    totalCost = calculateGomovePricing()
    //                    break
    //
    //                default:
    //                    break
    //
    //           }
                
                
                //Adding Surchange Value
    //            if Bool(/UDSingleton.shared.appSettings?.appSettings?.surCharge) ?? false {
    //                let surchargePercentage = Float(/UDSingleton.shared.appSettings?.appSettings?.surChargePercentage)
    //                totalCost = totalCost + ((totalCost * /surchargePercentage) / 100.0)
    //            }
                
                

                //Time require to level charge -> calculated the price value
               let appTemp  = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                switch appTemp {
                    case .GoMove:
                        totalCost = calculateGomovePricing()
                        break
               
                    default:
                        break
                   
               }
                
                if Bool(/UDSingleton.shared.appSettings?.appSettings?.surCharge) ?? false {
                    let surchargeCalculatedAmount = calculateSurchargeWithTimeSlot(totalCost: totalCost)
                    totalCost = totalCost + surchargeCalculatedAmount
                }
                CalculatedPriceBeforePromo = totalCost
                lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat()
                lblNewPrice.text = String(totalCost).getTwoDecimalFloat()
                
            }
    
    
    func calculateSurchargeWithTimeSlot(totalCost:Float)->Float{
        
      
        var surchargeAmount:Float = 0.0
        
        if let surChargeArray =  request.selectedProduct?.surChargeAdmin{
            
              var surChargeAdmin:SurChargeAdmin?
            
            for surcharge in surChargeArray{
                
                let dateStr = Date().dateToString(format: "dd MMM yyyy")
                let startTimeStr =  dateStr + " " + /surcharge.startTime
                let endTimeStr =   dateStr + " " + /surcharge.endTime
                
                guard let startTime = startTimeStr.toLocalDate(format: "dd MMM yyyy HH:mm:ss") else{break}
                guard let endTime = endTimeStr.toLocalDate(format: "dd MMM yyyy HH:mm:ss") else{break}
                
                
                if (startTime.equalToDate(dateToCompare: Date()) || startTime.isLessThanDate(dateToCompare: Date())) &&   (endTime.equalToDate(dateToCompare: Date()) || endTime.isGreaterThanDate(dateToCompare: Date())){
                    
                    surChargeAdmin = surcharge
                    break
                }
                                
            }
            
            if let surChargeAdmin = surChargeAdmin{
                
                if /surChargeAdmin.status == 1{
                    
                    if /surChargeAdmin.type == "value"{
                        
                        if let surchargeAdminAmount = Float(/surChargeAdmin.value){
                            
                            surchargeAmount = surchargeAdminAmount
                        }
                    }
                    else{
                        if let percentage = Int(/surChargeAdmin.value){
                            
                            surchargeAmount = totalCost * Float(Float(percentage) / 100.0)
                        }
                        
                    }
                }
            }
            
        }
        else{
            
            let surchargePercentage = Float(/UDSingleton.shared.appSettings?.appSettings?.surChargePercentage)
            surchargeAmount = ((totalCost * /surchargePercentage) / 100.0)
        }
        
        return surchargeAmount
        
    }
    

       func calculateEstimatePrice()->Double {
           let totalMinutes = calculateEstimateTotalTime()
           //let hours = totalMinutes / 60
           return totalMinutes * Double(/request.selectedProduct?.price_per_hr)
       }
       
       
       func calculateEstimateTotalTime()->Double{
        
            print("unloadTime",Float(unloadTime()))
            print("loadTimeTime",Float(loadTime()))
            print("request.duration",request.duration)
            print("selectedProduct?.actualPrice",Float(/request.selectedProduct?.actualPrice))
        
            
            let estTime = Float(unloadTime()) + Float(loadTime()) + request.duration +  Float(/request.selectedProduct?.actualPrice)
        
            return Double(estTime)
       }
       
       
       func unloadTime() -> Int {
    
           var unloadTime = 0
           var loadUploadTime =  0
           var level = 0
           
           let lvlPercentage = /UDSingleton.shared.appSettings?.appSettings?.level_percentage?.toInt()
           let elivatorPercentage = /UDSingleton.shared.appSettings?.appSettings?.elevator_percentage?.toInt()
        
            print("lvlPercentage ====>",lvlPercentage)
            print("elivatorPercentage ====>",elivatorPercentage)
            print("load_unload_time  ===>", /request.selectedProduct?.load_unload_time)
            print("request.elevator_dropoff ===>", request.elevator_dropoff)
                      
           if let t = Double(/request.selectedProduct?.load_unload_time){
               loadUploadTime = Int(t)
           }
           
          
           if let lvl = Int(/request.dropoff_level){
               level = lvl
           }
           
           if request.elevator_dropoff != "1" {
                unloadTime = loadUploadTime + (loadUploadTime * level * lvlPercentage)
           }
           else{
                unloadTime = loadUploadTime + (loadUploadTime * level * elivatorPercentage)
           }
        
        return unloadTime
        
       }
       
       
       func loadTime()-> Int {
           
           var loadTime = 0
           
           var loadUploadTime =  0
           
           let lvlPercentage = /UDSingleton.shared.appSettings?.appSettings?.level_percentage?.toInt()
           let elivatorPercentage = /UDSingleton.shared.appSettings?.appSettings?.elevator_percentage?.toInt()
        
           print("Load lvlPercentage ====>",lvlPercentage)
           print("load elivatorPercentage ====>",elivatorPercentage)
        
           print("load elivatorPercentage ====>",/request.selectedProduct?.load_unload_time)
           print("load request.pickup_level ====>",/request.pickup_level)
        print("load request.elevator_pickup ====>",/request.elevator_pickup)
           
           
           if let t = Double(/request.selectedProduct?.load_unload_time){
                loadUploadTime = Int(t)
           }
           
            var level = 0
            if let lvl = Int(/request.pickup_level){
               
               level = lvl
           }
           
          
           
           if request.elevator_pickup != "1"{
                loadTime = loadUploadTime + (loadUploadTime * level * lvlPercentage)
           }
           else{
                loadTime = loadUploadTime + (loadUploadTime * level * elivatorPercentage)
           }
        
            return loadTime
        
       }

    func calculateGomovePricing() -> Float {
        var isPickupElevator: Bool = false
        var isDroppElevator: Bool = false
        var loadTime: Double? = 0.0
        var unloadTime: Double? = 0.0
        
        loadTime =  Double(/request.selectedProduct?.load_unload_time)
        unloadTime = Double(/request.selectedProduct?.load_unload_time)
        
        
        var pickLevel: Int? = 0
        pickLevel = Int(/request.pickup_level)
        var dropLevel: Int? = 0
        dropLevel = Int(/request.dropoff_level)
        
        
        var pickuprateVAlue: String? = ""
        var dropRateValue = "0"
        
        if /request.elevator_pickup == "true" {
            isPickupElevator = true
        }
        
        if /request.elevator_dropoff == "true" {
            isDroppElevator = true
        }
        
        
        if isPickupElevator {
            pickuprateVAlue = /UDSingleton.shared.appSettings?.appSettings?.elevator_percentage
        } else {
            pickuprateVAlue = /UDSingleton.shared.appSettings?.appSettings?.level_percentage
        }
        
        if isDroppElevator {
            dropRateValue = /UDSingleton.shared.appSettings?.appSettings?.elevator_percentage
        } else {
            dropRateValue = /UDSingleton.shared.appSettings?.appSettings?.level_percentage
        }
        
        
        var timeLoading: Double = 0
        var timeUnloading: Double = 0
        
        let timeLoadingValue  = loadTime! * Double(/pickLevel) * Double(/pickuprateVAlue!)!
        timeLoading = /loadTime + timeLoadingValue
        print("Time Loading", timeLoading)
        
        
        let timeUnloadingValue  = unloadTime! * Double(/dropLevel)  * Double(/dropRateValue)!
        timeUnloading = /unloadTime  + timeUnloadingValue
        print("timeUnloading", timeUnloading)

        let estimationTime = request.duration
        let ET = timeLoading + timeUnloading + /Double(estimationTime)
        let estimatePriceHourly = (Float(ET) * /request.selectedProduct?.price_per_hr) + Float(/request.selectedProduct?.alphaPrice)
        
        return estimatePriceHourly
        
    }

    // Call After promo applied
    func setupDataAfterPromoApplied (object: Coupon?) {
        
        isAppliedPromo = true
        couponID = object?.couponId
        couponCode = object?.code
        textFieldPromo.text = object?.code
        textFieldPromo.textColor = R.color.appPurple()
        
        buttonApplyPromo.setTitle("REMOVE".localizedString, for: .normal)
        buttonApplyPromo.setTitleColor(R.color.appRed(), for: .normal)
        
        let price = CalculatedPriceBeforePromo

        if /object?.couponType == "Value" {
            
            let finalPrice = price! - Float(/object?.amountValue)!
            lblFinalPrice.text = String(finalPrice).getTwoDecimalFloat()
            lblNewPrice.text =  String(finalPrice).getTwoDecimalFloat()
            
        } else {
            let finalPrice = price! - (price! * Float(/object?.amountValue)!)/100.0
           // let finalPrice = price - (price * Float(object?.amountValue))/100.0
            lblFinalPrice.text = String(finalPrice).getTwoDecimalFloat()
             lblNewPrice.text =  String(finalPrice).getTwoDecimalFloat()
        }
    }
    
    
    func updatePaymentMode(service : ServiceRequest) {
          let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
        request = service
        
        switch service.paymentMode {
        case .Card:
            
            buttonCreditCard.setButtonWithTitleAndBorderColorSecondary()
            buttonCreditCard.setButtonWithTintColorSecondary()
            
            buttonCash.layer.borderColor = UIColor.lightGray.cgColor
            buttonCash.setImage(R.image.ic_cash_inactive(), for: .normal)
            buttonCash.setTitleColor(.lightGray, for: .normal)
            switch paymentGateway {
            case .stripe:
                buttonCreditCard.setTitle("**** **** **** \(/request.selectedCard?.lastDigit)" , for: .normal)
                
            case .peach:
                 buttonCreditCard.setTitle("**** **** **** \(/request.selectedCard?.last4)" , for: .normal)
                
                
            case .epayco:
                 buttonCreditCard.setTitle("\(/request.selectedCard?.last4)" , for: .normal)
                
            default:
                 buttonCreditCard.setTitle(/request.selectedCard?.cardNo , for: .normal)
            }
           
            
         case .Cash:
            
             buttonCash.setButtonWithTitleAndBorderColorSecondary()
             buttonCash.setButtonWithTintColorSecondary()
                        
             buttonCreditCard.layer.borderColor = UIColor.lightGray.cgColor
             buttonCreditCard.setImage(R.image.ic_card_inactive(), for: .normal)
             buttonCreditCard.setTitleColor(.lightGray, for: .normal)
            
             buttonCreditCard.setTitle("Credit Card".localizedString , for: .normal)
             
             request.credit_point_used = nil
             switchCreditPoints.setOn(false, animated: true)
            
        default:
            break
            
            }
    }
    
    
    
}
