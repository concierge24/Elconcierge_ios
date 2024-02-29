//
//  GMStepper.swift
//  GMStepper
//
//  Created by Gunay Mert Karadogan on 1/7/15.
//  Copyright © 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit
import Foundation
import EZSwiftExtensions

protocol CartStepperDelegate {
    
}

//typealias StepperValueListener = (AnyObject) -> ()
//Nitn for old code

typealias StepperValueListener = (Double?) -> ()
typealias NewListner = (Any?) -> ()

@IBDesignable public class GMStepper: UIControl {
    
    var newListnerObj: NewListner? // for background color changing
    var stepperValueListener : StepperValueListener? // for main data sending
    var addonStepperListner: NewListner? // for addons managing
    
    /// Current value of the stepper. Defaults to 0.
    
    var forCheckCustomizationVC = false
    var willHideRemoveCart: Bool = false
    var appType = SKAppType.type
    var cart_image_upload: String?
    var order_instructions: String?
    
    public var value: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
            let isInteger = floor(value) == value
            
            if showIntegerIfDoubleIsInteger && isInteger {
                if appType == .home {
                    label.text = "\(Int(value)) \(Int(value) == 1 ? "hr" : "hrs")"
                }
                else {
                    label.text = "\(Int(value))"
                }
                //label.text = String(stringInterpolationSegment: Int(value))
            } else {
                if appType == .home {
                    label.text = "\(value) \((value) == 1 ? "hr" : "hrs")"
                }
                else {
                    label.text = "\(value)"
                }
                // label.text = String(stringInterpolationSegment: value)
            }
            //label.textColor =  Int(value) > 0 ? Colors.MainColor.color() : UIColor.black.withAlphaComponent(0.25)
            
            label.textColor =  Int(value) > 0 ? LabelThemeColor.shared.lblTitleClr : UIColor.black.withAlphaComponent(0.95)
            //   button.setImage(image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
            ///let img  = UIImage(asset : Asset.Ic_cart_plus_pressed).withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            
            //            Int(value) > 0 ? rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_pressed).withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal) : rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_normal).withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            
            //            rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_pressed).withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            //            leftButton.setImage(UIImage(asset : Asset.Ic_cart_minus_pressed).withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            
            rightButton.imageView?.tintColor = ButtonThemeColor.shared.btnSelectedColor
            leftButton.imageView?.tintColor = ButtonThemeColor.shared.btnSelectedColor
            
            if oldValue != value {
                sendActions(for: .valueChanged)
                invalidateIntrinsicContentSize()
                superview?.layoutIfNeeded()
                // self.layoutIfNeeded()
            }
            isAddCartActive = value > 0
            
            self.cornerRadius = 0.0
            
            if willHideRemoveCart {
                leftButton.alpha = value > 0 ? 1.0 : 0.0
                label.alpha = value > 0 ? 1.0 : 0.0
            }
            else {
//                btnAddToCart.isHidden = value > 0 || maximumValue > 1
//                label.isHidden = value == 0 || maximumValue == 1
//                leftButton.isHidden = value == 0 || maximumValue == 1
//                rightButton.isHidden = value == 0 || maximumValue == 1
            }
            
        }
    }
    
    /// Minimum value. Must be less than maximumValue. Defaults to 0.
    public var minimumValue: Double = 0 {
        didSet {
            if value == 0 {
                return
            }
            value = min(maximumValue, max(minimumValue, value))
        }
    }
    
    public var purchasedQuantity = Double()
    public var maximumProductQuanity = Double()
    
    /// Maximum value. Must be more than minimumValue. Defaults to 100.
    public var maximumValue =  Double() { //     public var maximumValue: Double = 100 { // Nitin
        didSet {
            value = min(maximumValue, max(minimumValue, value))

//            if appType == .food {
//                btnAddToCart.isHidden = true
//            } else {
//                btnAddToCart.isHidden = maximumValue > 1
//            }
//            label.isHidden = maximumValue == 1
//            leftButton.isHidden = maximumValue == 1
//            rightButton.isHidden = maximumValue == 1
            

            btnAddToCart.isHidden = true
            label.isHidden = false
            leftButton.isHidden = false
            rightButton.isHidden = false
            label.isHidden = false
           // }
            
            if isCartView && maximumValue == 1 {
                alpha = 0.0
            } else {
                alpha = 1.0
            }
        }
    }
    
    /// Step/Increment value as in UIStepper. Defaults to 1.
    public var stepValue: Double = 1
    
    /// The same as UIStepper's autorepeat. If true, holding on the buttons or keeping the pan gesture alters the value repeatedly. Defaults to true.
    public var autorepeat: Bool = true
    
    /// If the value is integer, it is shown without floating point.
    public var showIntegerIfDoubleIsInteger: Bool = true
    
    var isHide: Bool = false {
        didSet {
            isHidden = isHide
        }
    }
    
    public var isCartView: Bool = false {
        didSet {
            if isCartView && maximumValue == 1 {
                alpha = 0.0
            } else {
                alpha = 1.0
            }
        }
    }
    
    /// Text on the left button. Be sure that it fits in the button. Defaults to "−".
    public var leftButtonText: String = "−" {
        didSet {
            leftButton.setTitle(leftButtonText, for: .normal)
        }
    }
    
    /// Text on the right button. Be sure that it fits in the button. Defaults to "+".
    public var rightButtonText: String = "+" {
        didSet {
            rightButton.setTitle(rightButtonText, for: .normal)
        }
    }
    
    /// Text color of the buttons. Defaults to white.
    public var buttonsTextColor: UIColor = SKAppType.type.color {
        didSet {
            for button in [leftButton, rightButton] {
                button.setTitleColor(buttonsTextColor, for: .normal)
            }
        }
    }
    
    /// Background color of the buttons. Defaults to dark blue.
    public var buttonsBackgroundColor: UIColor = UIColor.clear {
        didSet {
            for button in [leftButton, rightButton] {
                button.backgroundColor = UIColor.clear
            }
            backgroundColor = UIColor.clear
        }
    }
    
    /// Font of the buttons. Defaults to AvenirNext-Bold, 20.0 points in size.
    public var buttonsFont = UIFont(name: "AvenirNext-Bold", size: 32.0)! {
        didSet {
            for button in [leftButton, rightButton] {
                button.titleLabel?.font = buttonsFont
            }
        }
    }
    
    /// Text color of the middle label. Defaults to white.
    public var labelTextColor: UIColor = UIColor.black.withAlphaComponent(0.95) {
        didSet {
            label.textColor = labelTextColor
        }
    }
    
    /// Text color of the middle label. Defaults to lighter blue.
    //    public var labelBackgroundColor: UIColor = UIColor.clear{
    //        didSet {
    //            label.backgroundColor = labelBackgroundColor
    //        }
    //    }
    
    /// Font of the middle label. Defaults to AvenirNext-Bold, 25.0 points in size.
    public var labelFont = UIFont(name: Fonts.ProximaNova.Regular , size: Size.Large.rawValue)! {
        didSet {
            label.font = labelFont
        }
    }
    
    /// Corner radius of the stepper's layer. Defaults to 4.0.
    public  var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    /// Border width of the stepper and middle label's layer. Defaults to 0.0.
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            label.layer.borderWidth = borderWidth
        }
    }
    
    /// Color of the border of the stepper and middle label's layer. Defaults to clear color.
    public var borderColorS: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColorS.cgColor
            label.layer.borderColor = borderColorS.cgColor
        }
    }
    
    /// Percentage of the middle label's width. Must be between 0 and 1. Defaults to 0.5. Be sure that it is wide enough to show the value.
    public var labelWidthWeight: CGFloat = 0.35 {
        didSet {
            labelWidthWeight = min(1, max(0, labelWidthWeight))
            setNeedsLayout()
        }
    }
    
    /// Color of the flashing animation on the buttons in case the value hit the limit.
    public var limitHitAnimationColor: UIColor = UIColor(red:0.26, green:0.6, blue:0.87, alpha:1)
    
    /**
     Width of the sliding animation. When buttons clicked, the middle label does a slide animation towards to the clicked button. Defaults to 5.
     */
    let labelSlideLength: CGFloat = 5
    
    // Product for saving in Core Data (Edited By Rajat)
    var fromCartView = false
    var associatedProduct : ProductF? {
        didSet {
            //            minimumValue = associatedProduct?.minQty ?? 0
            purchasedQuantity = associatedProduct?.purchasedQuantity ?? 0.0
            if associatedProduct?.priceType == PriceType.Hourly {
                maximumValue = /associatedProduct?.maxQty
            }
            else {
                maximumValue = associatedProduct?.valueMaxQtyLimit ?? 100
            }

            maximumProductQuanity = associatedProduct?.totalMaxQuantity ?? 0.0
            stepValue = (associatedProduct?.priceType == PriceType.Hourly ? Double(/associatedProduct?.duration) : (associatedProduct?.isProduct == .service ? AppSettings.shared.intervalServiceHourly : 60.0))/60.0
        }
    }
    
    /// Duration of the sliding animation
    let labelSlideDuration = TimeInterval(0.1)
    
    /// Duration of the animation when the value hits the limit.
    let limitHitAnimationDuration = TimeInterval(0.1)
    
    var isAddCartActive: Bool = false {
        didSet {
            btnAddToCart.isSelected = isAddCartActive
            
            btnAddToCart.borderColor = btnAddToCart.borderColor?.withAlphaComponent(isAddCartActive ? 0.95 : 1.0)
            
            let selecter = isAddCartActive ? #selector(GMStepper.leftButtonTouchDown) : #selector(GMStepper.rightButtonTouchDown)
            
            btnAddToCart.removeTarget(nil, action: nil, for: .allEvents)
            
            btnAddToCart.addTarget(self, action: selecter, for: .touchDown)
            btnAddToCart.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpInside)
            btnAddToCart.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpOutside)
            
        }
    }
    
    var stepperStackView: UIStackView!

    lazy var btnAddToCart: UIButton = {
        let button = UIButton()
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.setTitleColor(self.buttonsTextColor.withAlphaComponent(0.95), for: .selected)
        button.titleLabel?.font = self.buttonsFont
        button.setTitle("Add", for: .normal)
        button.setTitle("Remove", for: .selected)
        button.fontSize = 10.0
        //        button.addTarget(self, action: #selector(GMStepper.rightButtonTouchDown), for: .touchDown)
        button.imageView?.tintColor = ButtonThemeColor.shared.btnSelectedColor
        button.borderColor = ButtonThemeColor.shared.btnSelectedColor
        button.borderWidthW = 1
        button.cornerRadiusR = 3
        button.backgroundColor = backgroundColor
        return button
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        //        button.setTitle(self.leftButtonText, forState: .Normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        //        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(GMStepper.leftButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpOutside)
        
        //       rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_pressed).withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal) : rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_normal).withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        //if appType == .food || appType.isJNJ {
            button.setImage(UIImage(named: "ic_minus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            button.setImage(UIImage(named: "ic_minus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .highlighted)
       // } else {
        //    button.setImage(UIImage(named: "ic_cart_minus_normal")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        //    button.setImage(UIImage(named: "ic_cart_minus_normal")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .highlighted)
        //}
        button.imageView?.tintColor = ButtonThemeColor.shared.btnSelectedColor
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        //        button.setTitle(self.rightButtonText, forState: .Normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        //        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(GMStepper.rightButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpOutside)
        
       // if appType == .food || appType.isJNJ {
            button.setImage(UIImage(named: "ic_plus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            button.setImage(UIImage(named: "ic_plus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .highlighted)
        //} else {
        //    button.setImage(UIImage(named: "ic_cart_plus_normal")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
         //   button.setImage(UIImage(named: "ic_cart_plus_pressed")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .highlighted)
       // }
        button.imageView?.tintColor = ButtonThemeColor.shared.btnSelectedColor
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let suffix = associatedProduct?.priceType.strStepperPer(isProduct: associatedProduct?.isProduct ?? .product, interVal: associatedProduct?.typeDuration ?? 1) ?? ""
        if self.showIntegerIfDoubleIsInteger && floor(self.value) == self.value {
            label.text = UtilityFunctions.appendOptionalStrings(withArray: ["\(Int(self.value))", suffix])
            //label.text = String(stringInterpolationSegment: Int(self.value))
        } else {
            label.text = UtilityFunctions.appendOptionalStrings(withArray: ["\(self.value)", suffix])
            // label.text = String(stringInterpolationSegment: self.value)
        }
        
        label.textColor = UIColor.black
        label.numberOfLines = 0
        //        label.backgroundColor = self.labelBackgroundColor
        label.font = self.labelFont
        label.isUserInteractionEnabled = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GMStepper.handlePan))
        panRecognizer.maximumNumberOfTouches = 1
        //        label.addGestureRecognizer(panRecognizer)
        
        return label
    }()
    
    var labelOriginalCenter: CGPoint!
    var labelMaximumCenterX: CGFloat!
    var labelMinimumCenterX: CGFloat!
    
    enum LabelPanState {
        case Stable, HitRightEdge, HitLeftEdge
    }
    var panState = LabelPanState.Stable
    
    enum StepperState {
        case Stable, ShouldIncrease, ShouldDecrease
    }
    var stepperState = StepperState.Stable {
        didSet {
            if stepperState != .Stable {
                updateValue()
                if autorepeat {
                    scheduleTimer()
                }
            }
        }
    }
    
    /// Timer used for autorepeat option
    var timer: Timer?
    
    /** When UIStepper reaches its top speed, it alters the value with a time interval of ~0.05 sec.
     The user pressing and holding on the stepper repeatedly:
     - First 2.5 sec, the stepper changes the value every 0.5 sec.
     - For the next 1.5 sec, it changes the value every 0.1 sec.
     - Then, every 0.05 sec.
     */
    let timerInterval = TimeInterval(0.05)
    
    /// Check the handleTimerFire: function. While it is counting the number of fires, it decreases the mod value so that the value is altered more frequently.
    var timerFireCount = 0
    var timerFireCountModulo: Int {
        if timerFireCount > 80 {
            return 1 // 0.05 sec * 1 = 0.05 sec
        } else if timerFireCount > 50 {
            return 2 // 0.05 sec * 2 = 0.1 sec
        } else {
            return 10 // 0.05 sec * 10 = 0.5 sec
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 80, height: 24)
    }
    
    func setup() {
        
        stepperStackView = UIStackView(frame: bounds)
        if SKAppType.type == .home {
            stepperStackView.spacing = 4
        }
        else {
            stepperStackView.spacing = 8
        }
        stepperStackView.axis = .horizontal
        
        leftButton.setContentHuggingPriority(.required, for: .horizontal)
        rightButton.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        leftButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        rightButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        stepperStackView.addArrangedSubview(leftButton)
        stepperStackView.addArrangedSubview(label)
        stepperStackView.addArrangedSubview(rightButton)
        stepperStackView.addArrangedSubview(btnAddToCart)
        //        addSubview(leftButton)
        //        addSubview(rightButton)
        //        addSubview(label)
        //        addSubview(btnAddToCart)
        do{

            stepperStackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stepperStackView)
            NSLayoutConstraint.activate([
                
                stepperStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                stepperStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                stepperStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                stepperStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
        catch let exception{
            print(exception)
        }
        
        
        backgroundColor = buttonsBackgroundColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(GMStepper.reset), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        labelMaximumCenterX = label.center.x + labelSlideLength
        labelMinimumCenterX = label.center.x - labelSlideLength
        labelOriginalCenter = label.center
    }
    
    func updateValue() {
        if stepperState == .ShouldIncrease {
            value += stepValue
        } else if stepperState == .ShouldDecrease {
            value -= stepValue
        }   
    }
    
    deinit {
        resetTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Useful closure for logging the timer interval. You can call this in the timer handler to test the autorepeat option. Not used in the current implementation.
    //    lazy var printTimerGaps: () -> () = {
    //        var prevTime: CFAbsoluteTime?
    //
    //        return { _ in
    //            var now = CFAbsoluteTimeGetCurrent()
    //            if let prevTime = prevTime {
    //                print(now - prevTime)
    //            }
    //            prevTime = now
    //        }
    //    }()
}

// MARK: Pan Gesture
extension GMStepper {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            leftButton.isEnabled = false
        //            rightButton.isEnabled = false
        case .changed:
            let translation = gesture.translation(in: label)
            gesture.setTranslation(CGPoint.zero, in: label)
            
            let slidingRight = gesture.velocity(in: label).x > 0
            let slidingLeft = gesture.velocity(in: label).x < 0
            
            // Move the label with pan
            if slidingRight {
                //                label.center.x = min(labelMaximumCenterX, label.center.x + translation.x)
            } else if slidingLeft {
                //                label.center.x = max(labelMinimumCenterX, label.center.x + translation.x)
            }
            
            // When the label hits the edges, increase/decrease value and change button backgrounds
            if label.center.x == labelMaximumCenterX {
                // If not hit the right edge before, increase the value and start the timer. If already hit the edge, do nothing. Timer will handle it.
                if panState != .HitRightEdge {
                    stepperState = .ShouldIncrease
                    panState = .HitRightEdge
                }
                
                animateLimitHitIfNeeded()
            } else if label.center.x == labelMinimumCenterX {
                if panState != .HitLeftEdge {
                    stepperState = .ShouldDecrease
                    panState = .HitLeftEdge
                }
                
                animateLimitHitIfNeeded()
            } else {
                panState = .Stable
                stepperState = .Stable
                resetTimer()
                
                self.rightButton.backgroundColor = self.buttonsBackgroundColor
                self.leftButton.backgroundColor = self.buttonsBackgroundColor
            }
        case .ended, .cancelled, .failed:
            reset()
        default:
            break
        }
    }
    
    @objc func reset() {
        panState = .Stable
        stepperState = .Stable
        resetTimer()
        
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        label.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: self.labelSlideDuration, animations: {
            //            self.label.center = self.labelOriginalCenter
            self.rightButton.backgroundColor = self.buttonsBackgroundColor
            self.leftButton.backgroundColor = self.buttonsBackgroundColor
        })
    }
}

// MARK: Button Events
extension GMStepper {
    @objc func leftButtonTouchDown(button: UIButton) {
        
        rightButton.isEnabled = false
        label.isUserInteractionEnabled = false
        if appType.isFood {
            DBManager.sharedManager.getCart {
                [weak self] (arrayCart) in
                guard let self = self else { return }
                let arrCart: [Cart] = (arrayCart as? [Cart]) ?? []
                self.performLeftButtonClick(arrCart: arrCart)
                return
            }
        } else if appType.isHome || appType == .eCom {
            guard let block = stepperValueListener else {return}
            if isCartView == true {
                if self.value != 0 {
                    stepperState = .ShouldDecrease
                    saveProductWithQuantity(quantity: Int(value))
                    block(value)
                }
            } else {
                stepperState = .ShouldDecrease
                saveProductWithQuantity(quantity: Int(value))
                block(value)
            }
        }
        
        
        //        if value == minimumValue {
        //            animateLimitHitIfNeeded()
        ////            rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_normal), for: .normal)
        //
        //        } else {
        //            if isCartView == true{
        //                if self.value != 1 {
        //                    stepperState = .ShouldDecrease
        //                }
        //            } else {
        //                stepperState = .ShouldDecrease
        //            }
        //
        //            animateSlideLeft()
        //
        //            if value == minimumValue{
        ////                rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_normal), for: .normal)
        //            }
        //        }
        //
        //        if isCartView == true{
        //           if self.value != 0
        //           {
        //               saveProductWithQuantity(quantity: Int(value))
        //               guard let block = stepperValueListener else { return }
        //               block(value)
        //           }
        //        }  else {
        //               saveProductWithQuantity(quantity: Int(value))
        //               guard let block = stepperValueListener else { return }
        //               block(value)
        //        }
        //
        //        guard let block = stepperValueListener else { return }
        //        guard let newBlock = addonStepperListner else {return}
        //        guard let product = self.associatedProduct else {return}
        //
        //        if let addonId = product.addOnId {
        //            saveProductWithQuantity(quantity: Int(value))
        //
        //
        //        } else {
        //            if self.value != 0 {
        //                saveProductWithQuantity(quantity: Int(value))
        //                block(value)
        //            }
        //        }
        //
        //
        //        if forCheckCustomizationVC {
        //            newBlock((value,false))
        //            return
        //        }
        //        if isCartView == true{
        //            if self.value != 0 {
        //                saveProductWithQuantity(quantity: Int(value))
        //                block(value)
        //            }
        //        }else{
        //           // guard let product = self.associatedProduct else {return}
        //            saveProductWithQuantity(quantity: Int(value))
        //            DBManager.sharedManager.removeAddonFromDbAcctoTypeId(productId: product.product_id ?? "", addonId: product.addOnId ?? "", typeId: "")
        //
        //            product.addOnValue?.removeAll()
        //            product.arrayAddonValue?.removeAll()
        //            block(value)
        //            guard let newBlock = self.newListnerObj else {return} // for making cell bg color white
        //            newBlock(false)
        //        }
        
        //Nitin for old code
        //        if isCartView == true {
        //            if self.value != 0 {
        //                //saveProductWithQuantity(quantity: Int(value))
        //                guard let block = stepperValueListener else { return }
        //                block((value,false) as AnyObject)
        //            }
        //        } else {
        //            //saveProductWithQuantity(quantity: Int(value))
        //            guard let block = stepperValueListener else { return }
        //            block((value,false) as AnyObject)
        //        }
        
    }
    
    func clearAllProductInCart(msg: String = L10n.AddingProductsFromDiffrentSuppliersWillClearYourCart.string) {
        
        UtilityFunctions.showAlert(title: nil, message: msg, success: {
            [weak self] in
            guard let self = self else { return }
            
            DBManager.sharedManager.cleanCart()
            
            self.stepperValueListener?(self.value)
            if let vc = self.superview?.superview?.superview?.superview?.superview?.next as? ItemListingViewController{
                
                vc.reloadVisibleCells()
            } else if let vc = ez.topMostVC as? ItemListingViewController {
                
                vc.reloadVisibleCells()
            } else if let vc = ez.topMostVC as? ItemTableViewController {
                vc.reloadVisibleCells()
                // vc.tableView.reloadData()
                // vc.collectionView.reloadData()
            } else if let vc = ez.topMostVC as? HomeViewController {
                vc.reloadVisibleCells()
                //vc.tableView.reloadData()
            } else if let vc = ez.topMostVC as? DoctorHomeVC {
                vc.reloadVisibleCells()
            }
            //            weakSelf?.leftButtonTouchDown(button: button)
            
            //            button.setTitle("Add to Cart", for: .normal)
            
            DBManager.sharedManager.getCart {
                [weak self] (arrayCart) in
                guard let self = self else { return }
                let arrCart: [Cart] = (arrayCart as? [Cart]) ?? []
                
                self.performRightButtonClick(arrCart: arrCart)
            }
            
            //            self.rightButtonTouchDown(button: UIButton())
            //
            //
            }, cancel: {})
    }
    
    @objc func rightButtonTouchDown(button: UIButton) {
        guard let product = associatedProduct else { return }
        DBManager.sharedManager.getCart {
            [weak self] (arrayCart) in
            guard let self = self else { return }
            let arrCart: [Cart] = (arrayCart as? [Cart]) ?? []
            if arrCart.isEmpty { //Doctor
                GDataSingleton.sharedInstance.cartAppType = nil
            }
            //            supplierId
            let isMyAgentExist = self.associatedProduct?.agentList == "1"
            let isAgentExist = arrCart.isEmpty ? isMyAgentExist : (arrCart.first(where: { $0.agentList == "1"}) != nil)
            let isSameSupplier = arrCart.isEmpty ? true : (arrCart.first(where: { $0.supplierId != self.associatedProduct?.supplierId }) == nil)
            let vendorStatus = AppSettings.shared.vendorStatus
            let cartFlow = AppSettings.shared.arrayBookingFlow?.first?.cartFlow
            
            //cart flow
            // 0->single product with single fixed_quantity
            // 1->single product with multiple fixed_quantity
            // 2->multiple product with single fixed_quantity
            // 3->multiple product with multiple fixed_quantity
            
            //            let filteredArray = arrCart.filter() { /$0.id == /product!.id }
            if GDataSingleton.sharedInstance.cartAppType != nil && GDataSingleton.sharedInstance.cartAppType != self.appType.rawValue {
                //Doctor
                self.clearAllProductInCart(msg: L10n.AddingProductsFromDiffrentCategoryWillClearYourCart.string)
                return
            }
            //Nitin
            if self.appType == .food || self.appType == .eCom {
                if !AppSettings.shared.isSingleVendor {
                    switch(vendorStatus,isSameSupplier) {
                    case (.one, false)://, (.many,false):
                        self.clearAllProductInCart(msg: L10n.AddingProductsFromDiffrentSuppliersWillClearYourCart.string)
                        return
                    default: break

                    }
                }

            }
            else if AppSettings.shared.isSingleProduct, let id = arrCart.first?.id, id != product.id {
                print("Cart product id = \(id)")
                print("\nProduct id = \(product.id ?? "")")
                self.clearAllProductInCart(msg: L10n.SingleProductQuantity.string)
                return
            }
            else {
                switch (isMyAgentExist, isAgentExist, isSameSupplier, vendorStatus){
                case (true, true, false, .one), (false, false, false, .one),
                     (false, true, false, .one), (true, false, false, .one):
                    self.clearAllProductInCart(msg: L10n.AddingProductsFromDiffrentSuppliersWillClearYourCart.string)
                    return
                case  (false, true, true, .one), (true, false, true, .one),
                      (false, true, true, .many), (true, false, true, .many),
                      (false, true, false, .many), (true, false, false, .many)://Exist Agent
                    self.clearAllProductInCart(msg: L10n.AddingProductsFromDiffrentAgentWillClearYourCart.string)
                    return
                default: break
                }
            }
            self.performRightButtonClick(arrCart: arrCart)
        }
        
    }
    
    
    func performLeftButtonClick(arrCart: [Cart]) {
        
        guard let newBlock = addonStepperListner else {return}
        guard let product = self.associatedProduct else {return}
        resetTimer()
        
        let isContain = arrCart.contains(where: {$0.id ?? "" == product.id ?? ""})
        
        if isContain {
            if forCheckCustomizationVC {
                if self.value != 0 {
                    stepperState = .ShouldDecrease
                    newBlock((value,false)) // false is for subtraction
                }
                return
            } else {
                guard let index = arrCart.firstIndex(where: {$0.id ?? "" == product.id ?? ""}) else { return }
                if let addonId = arrCart[index].addOnId {
                    self.checkIfProductWithAddonAddedToDb(productId: product.id ?? "", addonId: addonId) { (isAdded) in
                        if isAdded { // for checking if any addons saved in db
                            DBManager.sharedManager.getProductAccToAddonId(productId: product.id ?? "", addonId: addonId) { (cartArray) in
                                if let savedAddons = cartArray.first?.addOns,savedAddons.count > 0 {
                                    guard let savedproduct = cartArray.first else {return}
                                    if self.fromCartView {
                                        newBlock((product,savedproduct,false,value,2)) // for cartviewcontroller - action, 1 is for plus, 2 is for -
                                        return
                                    } else {
                                        newBlock((product,savedproduct,false,value))
                                        return
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if self.value != 0{
                        stepperState = .ShouldDecrease
                        saveProductWithQuantity(quantity: Int(value))
                        newBlock(value)
                    }
                    return
                }
            }
            
        } else {
            if self.value != 0{
                stepperState = .ShouldDecrease
                saveProductWithQuantity(quantity: Int(value))
                newBlock(value)
            }
            
        }
        
    }
    
    func performRightButtonClick(arrCart: [Cart]) {
        
        GDataSingleton.sharedInstance.currentSupplierId = associatedProduct?.supplierBranchId
        GDataSingleton.sharedInstance.currentCategoryId = associatedProduct?.categoryId
        leftButton.isEnabled = true
        label.isUserInteractionEnabled = false
        //        rightButton.setImage(UIImage(asset : Asset.Ic_cart_plus_pressed), for: .normal)
        let quantityLeft = maximumProductQuanity - purchasedQuantity
        
        if appType.isFood {
            guard let newBlock = addonStepperListner else {return}
            guard let product = self.associatedProduct else {return}
            resetTimer()
            
            let isContain = arrCart.contains(where: {$0.id ?? "" == product.id ?? ""})
            
            if isContain {
                if forCheckCustomizationVC {
                    if (value == quantityLeft) {
                        SKToast.makeToast("Product is out of stock")
                        //UtilityFunctions.showAlert(message: "Product is out of stock")
                        animateLimitHitIfNeeded()
                        newBlock((false,false)) // for telling product is out of stock
                        return
                    } else {
                        stepperState = .ShouldIncrease
                        animateSlideRight()
                    }
                    newBlock((value,true)) // true is for addition
                    return
                } else {
                    guard let index = arrCart.firstIndex(where: {$0.id ?? "" == product.id ?? ""}) else { return }
                    if let addonId = arrCart[index].addOnId {
                        self.checkIfProductWithAddonAddedToDb(productId: product.id ?? "", addonId: addonId) { (isAdded) in
                            if isAdded { // for checking if any addons saved in db
                                DBManager.sharedManager.getProductAccToAddonId(productId: product.id ?? "", addonId: addonId) { (cartArray) in
                                    if let savedAddons = cartArray.first?.addOns,savedAddons.count > 0 {
                                        guard let savedproduct = cartArray.first else {return}
                                        if self.fromCartView {
                                            newBlock((product,savedproduct,false,value,1)) // for cartviewcontroller + action, 1 is for plus, 2 is for -
                                            return
                                        } else {
                                            newBlock((product,savedproduct,false,value))
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        if (value == quantityLeft) {
                            SKToast.makeToast("Product is out of stock")
                            //UtilityFunctions.showAlert(message: "Product is out of stock")
                            animateLimitHitIfNeeded()
                            newBlock((false,false))
                            return
                        } else {
                            stepperState = .ShouldIncrease
                            animateSlideRight()
                            saveProductWithQuantity(quantity: Int(value))
                            
                        }
                        newBlock(value)
                        return
                    }
                }
                
            } else {
                if let apiAddons = product.adds_on,apiAddons.count > 0 { // for checking if api has any addons
                    print(apiAddons)
                    newBlock((product,true,value))
                    return
                } else {
                    if (value == quantityLeft) {
                        SKToast.makeToast("Product is out of stock")
                        //UtilityFunctions.showAlert(message: "Product is out of stock")
                        animateLimitHitIfNeeded()
                        newBlock((false,false))
                        return
                    } else {
                        stepperState = .ShouldIncrease
                        animateSlideRight()
                        saveProductWithQuantity(quantity: Int(value))
                    }
                    
                    newBlock(value)
                    return
                }
                
            }
            
        } else if appType.isHome || appType == .eCom {
            guard let block = stepperValueListener else {return}
                    
            if (value == quantityLeft || value > maximumValue) {
                SKToast.makeToast("Maximum limit reached", duration: 1.5)
                //UtilityFunctions.showAlert(message: "Product is out of stock")
                animateLimitHitIfNeeded()
            } else {
                let prevValue = value
                stepperState = .ShouldIncrease
                animateSlideRight()
                //Daman
                if prevValue == value {
                    SKToast.makeToast("Maximum limit reached", duration: 1.5)
                }
                else {
                    saveProductWithQuantity(quantity: Int(value))
                }
                if (value == quantityLeft) {
                    SKToast.makeToast("Maximum limit reached", duration: 1.5)
                    //UtilityFunctions.showAlert(message: "Product is out of stock")
                }
            }
            
            block(value)
        }
        
        
        //Nitin for old code
        //        if (value == maximumProductQuanity - purchasedQuantity) {
        //            UtilityFunctions.showAlert(message: "Product is out of stock")
        //            animateLimitHitIfNeeded()
        //        } else {
        //            stepperState = .ShouldIncrease
        //            animateSlideRight()
        //            saveProductWithQuantity(quantity: Int(value))
        //            if (value == maximumProductQuanity - purchasedQuantity) {
        //                UtilityFunctions.showAlert(message: "Product is out of stock")
        //            }
        //        }
        //
        //        block(value)
        
    }
    
    func checkIfProductWithAddonAddedToDb(productId: String,addonId: String,finished: (_ isAdded:Bool) -> Void) {
        DBManager.sharedManager.getAddonsDataFromDb(productId: productId, addonId: addonId) {(data) in
            print(data)
            finished(data.count == 0 ? false : true)
        }
    }
    
    @objc func buttonTouchUp(button: UIButton) {
        reset()
    }
}

// MARK: Animations
extension GMStepper {
    
    func animateSlideLeft() {
        UIView.animate(withDuration: labelSlideDuration) {
            //            self.label.center.x -= self.labelSlideLength
        }
    }
    
    func animateSlideRight() {
        UIView.animate(withDuration: labelSlideDuration) {
            //            self.label.center.x += self.labelSlideLength
        }
    }
    
    func animateToOriginalPosition() {
        if self.label.center != self.labelOriginalCenter {
            UIView.animate(withDuration: labelSlideDuration) {
                //                self.label.center = self.labelOriginalCenter
            }
        }
    }
    
    func animateLimitHitIfNeeded() {
        if value == minimumValue {
            animateLimitHitForButton(button: leftButton)
        } else if value == maximumValue {
            animateLimitHitForButton(button: rightButton)
        }
    }
    
    func animateLimitHitForButton(button: UIButton){
        UIView.animate(withDuration: limitHitAnimationDuration) {
            //            button.backgroundColor = self.limitHitAnimationColor
        }
    }
    
    
}

// MARK: Timer
extension GMStepper {
    @objc func handleTimerFire(timer: Timer) {
        //        timerFireCount += 1
        //
        //        if timerFireCount % timerFireCountModulo == 0 {
        //            updateValue()
        //        }
    }
    
    func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(GMStepper.handleTimerFire), userInfo: nil, repeats: true)
    }
    
    func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            timerFireCount = 0
        }
    }
}

//MARK: - Save Product

extension GMStepper{
    
    func saveProductWithQuantity(quantity: Int) {
        
        guard let product = associatedProduct else { return }
        if product.is_question == 1  && quantity > 0 {
            //Daman
            if let selectedQuestions = GDataSingleton.sharedInstance.currentSupplier?.associatedQuestions, !selectedQuestions.isEmpty {
                //questions asked after selecting supplier, no need to ask questions for all products of same supplier
                product.questionsSelected = selectedQuestions
                saveProduct(quantity: quantity)
                return
            }
            DBManager.sharedManager.checkIfQuestionsAdded(productId: product.id ?? "") { (added) in
                if added {
                    saveProduct(quantity: quantity)
                }
                else {
                    getQuestions(categoryId: product.subCategoryId ?? "", quantity: quantity)
                }
            }
        }
        else {
            if let _ = product.quantity {
                saveProduct(quantity: quantity)
            } else if quantity > 0 {
                saveProduct(quantity: quantity)
            }
        }
    }
    
    func deleteProduct(quantity : Int) {
        
        guard let product = associatedProduct else { return }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: ["badge" : quantity])
        product.quantity = String(quantity)
        if quantity == 0 {
            product.questionsSelected = nil
        }
        DBManager.sharedManager.removeProductFromCart(productId: product.id)
        
    }
    
    func saveProduct(quantity : Int) {
        guard let product = associatedProduct else { return }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: ["badge" : quantity])
        product.quantity = String(quantity)
        if quantity == 0 {
            product.questionsSelected = nil
        }else {
            //for doctor app to remove products of other app type from cart
            GDataSingleton.sharedInstance.cartAppType = appType.rawValue
            if let value = cart_image_upload {
                AppSettings.shared.cartImageUpload = value == "1"
            }
            if let value = order_instructions {
                AppSettings.shared.orderInstructions = value == "1"
            }
        }
        DBManager.sharedManager.manageCart(product: product, quantity: quantity)
    }
    
    func isSameSupplierId(currentSupplierId : String?) -> Bool {
        guard let suppId = GDataSingleton.sharedInstance.currentSupplierId else {
            return true
        }
        return suppId != currentSupplierId ? true : false
    }
    
    
    func getQuestions(categoryId: String, quantity: Int)  {
        guard let product = associatedProduct else { return }
        
        let vc = QuestionsViewController.getVC(.options)
        vc.totalServiceCharge = Double(product.getPrice(quantity: (Double(/product.quantity) ?? 1))!)
        vc.categoryId = categoryId
        vc.completionBlock = { [weak self] questions in
            product.questionsSelected = questions
            if questions.count > 0 {
                self?.saveProduct(quantity: quantity)
            }
        }
        ez.topMostVC?.pushVC(vc)
    }
}
