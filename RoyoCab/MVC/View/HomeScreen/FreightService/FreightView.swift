//
//  FreightView.swift
//  Buraq24
//
//  Created by MANINDER on 17/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class FreightView: UIView,UITextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackMoreDetails: UIStackView!
    @IBOutlet var btnAddMore: UIButton!
    @IBOutlet var txtFieldMaterialType: UITextField!
    @IBOutlet weak var btnAddCategory: UIButton!
    @IBOutlet var txtDetailName: UITextField!
    @IBOutlet var txtDetailPhone: UITextField!
    @IBOutlet var txtDetailInvoice: UITextField!
    @IBOutlet var txtDropPersonName: UITextField!
    @IBOutlet weak var txfReceiverName: UITextField!
    @IBOutlet var txtFieldWeight: UITextField!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet var txtViewInformation: PlaceholderTextView!
    @IBOutlet weak var descriptionTextview: PlaceholderTextView!
    @IBOutlet var collectionViewImages: UICollectionView!
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var pickupStack: UIStackView!
    @IBOutlet weak var dropUpStack: UIStackView!
    @IBOutlet weak var btnYesElevatorPickup: UIButton!
    @IBOutlet weak var btnNoElevatorPickup: UIButton!
    @IBOutlet weak var txfPickUpLevel: UITextField!
    @IBOutlet weak var btnYesElevatorDropoff: UIButton!
    @IBOutlet weak var btnNoElevatorDropoff: UIButton!
    @IBOutlet weak var txfDropOffLevel: UITextField!
    @IBOutlet weak var btnYesFragile: UIButton!
    @IBOutlet weak var btnNoFragile: UIButton!
    @IBOutlet weak var dropAtStackView: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!
    @IBOutlet weak var stackViewFrigile: UIStackView!
    @IBOutlet weak var receiverNameStack: UIStackView!
    @IBOutlet weak var pickupAtStack: UIStackView!
    @IBOutlet weak var invoiceStack: UIStackView!
    @IBOutlet weak var additionalInfoStackView: UIStackView!
    @IBOutlet weak var txfCheckItem: UITextField!
    @IBOutlet weak var txfCheckPrice: UITextField!
    @IBOutlet weak var checkListView: UIView!
    @IBOutlet weak var orderDetailsView: UIStackView!
    @IBOutlet weak var checkListTableView: UITableView!
    @IBOutlet weak var btnCheckListContinue: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var dropLocationStack: UIStackView!
    @IBOutlet weak var descriptionStack: UIStackView!
    @IBOutlet weak var materialStack: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var weightStack: UIStackView!
    @IBOutlet weak var DecriptionStack: UIStackView!
    @IBOutlet weak var txfGoMoveDesc: UITextField!
    @IBOutlet weak var lblInvoive: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitleLine: UILabel!
    @IBOutlet weak var lblPickUpLevelLine: UILabel!
    @IBOutlet weak var dropOffLevelLine: UILabel!
    @IBOutlet weak var segmentStack: UIStackView!
    @IBOutlet weak var txfSenderName: UITextField!
    @IBOutlet weak var senderNameStack: UIStackView!

    
    //MARK:- Properties
    var elevatorPickUp =  true
    var elevatorDropOff = true
    var isFigile = true
    var pickupPicker = UIPickerView()
    var dropupPicker = UIPickerView()
    var pickupDataSource: PickerViewCustomDataSource?
    var dropupSizesDataSource: PickerViewCustomDataSource?
    var checkListItemTableDataSource:TableViewDataSourceCab?
    var validateCheckItems = Bool()
    
    var collViewDataSource : CollectionViewDataSourceCab?
    
    lazy  var images : [UIImage] = [UIImage]()
    var request : ServiceRequest?
    var delegate : BookRequestDelegate?
    
    var heightPopUp : CGFloat = 200
    var isAdded : Bool = false
    var viewSuper : UIView?
    var checkListItem = [[String: String]]()
    var totalPrice = 0
    var pickupLevelArr: [LevelValues]?
    var pickUpLevelValue = String()
    var dropUpLevelValue = String()
    
    var pickupStringArray = [String]()
    var dropoffStringArray = [String]()
   
    
    var openMoreDetail : Bool = false {
        didSet {
            //btnAddMore.isHidden = true
            btnAddMore.isSelected = openMoreDetail
            
            
            
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .DeliverSome:
                
                receiverNameStack.isHidden = !openMoreDetail
                dropLocationStack.isHidden = !openMoreDetail
                break
            default:
                 //stackMoreDetails.isHidden = !openMoreDetail
                print("default")
            }
            
           
        }
    }
    
    
    override func awakeFromNib() {
        
       
        
        
       
        configureCheckListCell()
        btnAddCategory.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
    
        
        
       let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        
        switch template {
        case .DeliverSome:
            DecriptionStack.isHidden = true
            descriptionStack.isHidden = true
            pickupAtStack.isHidden = true
            phoneStack.isHidden = true
            invoiceStack.isHidden = true
            pickupStack.isHidden = true
            dropUpStack.isHidden = true
            stackViewFrigile.isHidden = true
            dropAtStackView.isHidden  = true
            
            btnYesElevatorPickup.setButtonWithTintColorSecondary()
            btnNoElevatorPickup.setButtonWithTintColorSecondary()
            btnYesElevatorDropoff.setButtonWithTintColorSecondary()
            btnNoElevatorDropoff.setButtonWithTintColorSecondary()
            
            btnYesFragile.setButtonWithTintColorSecondary()
            btnNoFragile.setButtonWithTintColorSecondary()
            btnAddMore.setButtonWithTitleColorSecondary()
            txtFieldWeight.placeholder = "Enter approx weight in lbs."
            btnAddImage.setButtonWithTintColorSecondary()
            btnAddMore.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue), for: .selected)
            openMoreDetail = true 
            
            break
            
            
        case .GoMove:
            
             btnAddMore.isHidden = true
             lblTitle.textAlignment = .left
             lblTitleLine.isHidden = true
             lblTitle.text = "Details"
            
             
             materialStack.isHidden = true
             weightStack.isHidden = true
             receiverNameStack.isHidden = true
             phoneStack.isHidden = true
             dropLocationStack.isHidden = true
             additionalInfoStackView.isHidden = true
            
             txtDetailInvoice.placeholder = "Order, bill or Invoice number (optional)"
             txtDetailInvoice.setBorderColorSecondary()
             txtDetailInvoice.addShadowToTextFieldColorSecondary() 
             txtDetailInvoice.setLeftPaddingPoints(10)
            
             txfGoMoveDesc.setBorderColorSecondary()
             txfGoMoveDesc.addShadowToTextFieldColorSecondary()
             txfGoMoveDesc.setLeftPaddingPoints(10)
             txfGoMoveDesc.placeholder = "What are you moving?"
            
             stackMoreDetails.isHidden = true
            
             txfPickUpLevel.setBorderColorSecondary()
             txfPickUpLevel.addShadowToTextFieldColorSecondary()
             txfPickUpLevel.setLeftPaddingPoints(10)
            
             txfDropOffLevel.setBorderColorSecondary()
             txfDropOffLevel.addShadowToTextFieldColorSecondary()
             txfDropOffLevel.setLeftPaddingPoints(10)
             
             stackViewFrigile.isHidden = true
             descriptionStack.isHidden = true
             btnSchedule.isHidden  = false
             lblPickUpLevelLine.isHidden = true
             dropOffLevelLine.isHidden = true
             senderNameStack.isHidden = true
             
             btnBookNow.setTitle("Estimate", for: .normal)
            break
            
        case .Delivery20:
            txtFieldMaterialType.placeholder = "Item to be picked up"
            txtFieldWeight.placeholder = "Item weight"
            txfReceiverName.placeholder = "Name of contact at drop off location"
            txtDetailPhone.placeholder = "Phone number of contact at pickup location"
            txfSenderName.placeholder = "Name of contact at pickup location"
            
            DecriptionStack.isHidden = true
            descriptionStack.isHidden = true
            stackMoreDetails.isHidden = false
            invoiceStack.isHidden = true
            pickupStack.isHidden = true
            dropUpStack.isHidden = true
            stackViewFrigile.isHidden = true
            dropLocationStack.isHidden = true
            btnAddMore.isHidden = true
            btnAddImage.setButtonWithTintColorSecondary()
            
            break
            
        default:
            DecriptionStack.isHidden = true
            descriptionStack.isHidden = true
            stackMoreDetails.isHidden = true
            invoiceStack.isHidden = true
            pickupStack.isHidden = true
            dropUpStack.isHidden = true
            stackViewFrigile.isHidden = true
            dropLocationStack.isHidden = true
            btnAddMore.isHidden = true
            btnAddImage.setButtonWithTintColorSecondary()
            break
        }
        
        
        let pickupArrayString = UDSingleton.shared.appSettings?.registration_forum?.pickup_level
        let dropOffArrayString = UDSingleton.shared.appSettings?.registration_forum?.drop_level
        
        let newPString = /pickupArrayString?.replacingOccurrences(of: "[", with: "")
        let newp2String = newPString.replacingOccurrences(of: "]", with: "")
        pickupStringArray = newp2String.components(separatedBy: ",")
        
        let newdString = /dropOffArrayString?.replacingOccurrences(of: "[", with: "")
        let newd2String = newdString.replacingOccurrences(of: "]", with: "")
        dropoffStringArray = newd2String.components(separatedBy: ",")
        
        pickupStringArray.insert("0", at: 0)
        dropoffStringArray.insert("0", at: 0)
        configurePickUpPickerView()
        configureDropOffPickerView()
        
    }
    
    
    //MARK:- Action
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            validateCheckItems = false
            checkListView.isHidden = true
            orderDetailsView.isHidden = false
            break
        case 1:
            validateCheckItems = true
            checkListView.isHidden = false
            orderDetailsView.isHidden = true
            
            break
        default:
            print("default")
        }
        
    }
   
   
    
    @IBAction func addNewField(_ sender: Any) {
        
        if txfCheckItem.text != "" && txfCheckPrice.text != "" {
            
            let dictData = [
                "item_name": txfCheckItem.text,
                "price": txfCheckPrice.text
            ]
            
            checkListItem.append(dictData as! [String : String])
            totalPrice = 0
            for checkItem in checkListItem {
                totalPrice = totalPrice + (Int(checkItem["price"] ?? "") ?? 0)
            }
            
            lblTotalPrice.text = "Total: \(/UDSingleton.shared.appSettings?.appSettings?.currency) \(totalPrice)"
            
            checkListItemTableDataSource?.items = checkListItem
            checkListTableView.reloadData()
            txfCheckItem.text = ""
            txfCheckPrice.text = ""
            txfCheckItem.becomeFirstResponder()
            
        }
        
        
    }
    
    @IBAction func elevatorPickUpAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            elevatorPickUp = true
            self.btnYesElevatorPickup.setImage(R.image.ic_check(), for: .normal)
            self.btnNoElevatorPickup.setImage(R.image.ic_uncheck(), for: .normal)
        } else if sender.tag == 1 {
            elevatorPickUp = false
            self.btnYesElevatorPickup.setImage(R.image.ic_uncheck(), for: .normal)
            self.btnNoElevatorPickup.setImage(R.image.ic_check(), for: .normal)
        }
        
     
    }
    
    @IBAction func elevatorDropOffAction(_ sender: UIButton) {
            if sender.tag == 0 {
               elevatorDropOff = true
               btnYesElevatorDropoff.setImage(R.image.ic_check(), for: .normal)
               btnNoElevatorDropoff.setImage(R.image.ic_uncheck(), for: .normal)
            } else if sender.tag == 1 {
               elevatorDropOff = false
               btnYesElevatorDropoff.setImage(R.image.ic_uncheck(), for: .normal)
               btnNoElevatorDropoff.setImage(R.image.ic_check(), for: .normal)
           }
    }
    
    @IBAction func fragileAction(_ sender: UIButton) {
            if sender.tag == 0 {
                  isFigile = true
                  btnYesFragile.setImage(R.image.ic_check(), for: .normal)
                  btnNoFragile.setImage(R.image.ic_uncheck(), for: .normal)
               } else if sender.tag == 1 {
                  isFigile = false
                  btnYesFragile.setImage(R.image.ic_uncheck(), for: .normal)
                  btnNoFragile.setImage(R.image.ic_check(), for: .normal)
              }
        
        (ez.topMostVC as? HomeVC)?.serviceRequest.fragile = /isFigile ? "1" : "0"
    }
    
    
    @IBAction func actionAddMorePressed(_ sender: UIButton) {
        openMoreDetail = !openMoreDetail
        self.layoutIfNeeded()
        
        maximizeFreightOrderView()
    }
    
    @IBAction func btnContinueCheckList(_ sender: Any) {
    }
    
    
    @IBAction func actionSchedulePressed(_ sender: UIButton) {
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                   switch template {
                   case .DeliverSome:
                       request?.requestType = .Future
                       moveToNextPopUp()
                       break
                   case .Moby:
                       request?.requestType = .Future
                       moveToNextPopUp()
                       break
                   case .GoMove:
                    if  Validations.sharedInstance.validationLevel(pickupLevel:txfPickUpLevel.text!, dropLevel: txfDropOffLevel.text!){
                       request?.requestType = .Future
                       moveToNextPopUp()
                    }
                       break
                   case .Mover:
                       request?.requestType = .Future
                       moveToNextPopUp()
                       break
                   default:
                       if Validations.sharedInstance.validationFrazileTemplate(materialType: /txtFieldMaterialType.text?.trimmed(), weightInKg: /txtFieldWeight.text?.trimmed(), receiverName: /txfReceiverName.text?.trimmed(), phoneNumber: /txtDetailPhone.text?.trimmed(), senderName: /txfSenderName.text?.trimmed(), additionalInfomation: /txtViewInformation.text?.trimmed(), pickupAt: "a", dropoffAt: "a") {
                          request?.requestType = .Future
                           moveToNextPopUp()
                       }
                   }
        
        
    }
    
    @IBAction func buttonCheckBoxClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        (ez.topMostVC as? HomeVC)?.serviceRequest.fragile = /sender.isSelected ? "1" : "0"
    }
    
    
    @IBAction func actionBtnBookNowPressed(_ sender: UIButton) {
        
        //Getting the level Percentage
        var totalPercentageValue = Int()
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .GoMove:
            totalPercentageValue = (Int(pickUpLevelValue) ?? 0) + (Int(dropUpLevelValue) ?? 0)
            UserDefaults.standard.set(Float(totalPercentageValue), forKey: "levelsValues")
        default:
            print("Default Case")
        }
        
        
        
        if validateCheckItems {
            if checkListItem.count != 0 {
                request?.requestType = .Present
                request?.orderDateTime = Date()
                request?.check_lists = checkListItem
                
                moveToNextPopUp()
            } else {
                Alerts.shared.show(alert: "AppName".localizedString, message: "App Checklist Items." , type: .error )
            }
            
            
        } else {
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .DeliverSome:
                request?.requestType = .Present
                request?.orderDateTime = Date()
                moveToNextPopUp()
                break
            case .Moby:
                request?.requestType = .Present
                request?.orderDateTime = Date()
                moveToNextPopUp()
                break
            case .GoMove:
                 if  Validations.sharedInstance.validationLevel(pickupLevel:txfPickUpLevel.text!, dropLevel: txfDropOffLevel.text!){
                request?.requestType = .Present
                request?.orderDateTime = Date()
                moveToNextPopUp()
                 }
                break
            case .Mover:
                request?.requestType = .Present
                request?.orderDateTime = Date()
                moveToNextPopUp()
                break
                
            case .Delivery20:
                
                if Validations.sharedInstance.validationFrazileTemplate(materialType: /txtFieldMaterialType.text?.trimmed(), weightInKg: /txtFieldWeight.text?.trimmed(), receiverName: /txfReceiverName.text?.trimmed(), phoneNumber: /txtDetailPhone.text?.trimmed(), senderName: /txfSenderName.text?.trimmed(), additionalInfomation: /txtViewInformation.text?.trimmed(), pickupAt: /txtDetailName.text?.trimmed(), dropoffAt: /txtDropPersonName.text?.trimmed()) {
                    request?.requestType = .Present
                    request?.orderDateTime = Date()
                    moveToNextPopUp()
                }
                break
                
                
            default:
                if Validations.sharedInstance.validationFrazileTemplate(materialType: /txtFieldMaterialType.text?.trimmed(), weightInKg: /txtFieldWeight.text?.trimmed(), receiverName: /txfReceiverName.text?.trimmed(), phoneNumber: /txtDetailPhone.text?.trimmed(), senderName: /txfSenderName.text?.trimmed(), additionalInfomation: /txtViewInformation.text?.trimmed(), pickupAt: "-", dropoffAt: "-") {
                    request?.requestType = .Present
                    request?.orderDateTime = Date()
                    moveToNextPopUp()
                }
            }
        }
    }
    
    @IBAction func btndeleteCheckList(_ sender: UIButton) {
        
        alertBoxOption(message: "Are you sure you want to remove this item form your checklist.", title: "Remove Item", leftAction: "Cancel", rightAction: "Ok", ok: {
            self.checkListItem.remove(at: sender.tag)
            self.checkListItemTableDataSource?.items = self.checkListItem
            self.checkListTableView.reloadData()
            self.totalPrice = 0
            for checkItem in self.checkListItem {
                self.totalPrice = self.totalPrice + (Int(checkItem["price"] ?? "") ?? 0)
            }
            
            self.lblTotalPrice.text = "Total: \(self.totalPrice) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
            
        }) {
            print("Cencel")
        }
        
    }
    
    
    
    
    @IBAction func actionBtnAddMoreImage(_ sender: UIButton) {
        
        if images.count < 2 {
           
            guard let topController = ez.topMostVC else{return}
            CameraImage.shared.captureImage(from: topController, At: collectionViewImages , mediaType: nil, captureOptions: [.camera, .photoLibrary], allowEditting: true) { [unowned self] (image) in
                guard let img = image else { return }
                ez.runThisInMainThread {
                      self.images.append(img)
                    self.collViewDataSource?.items = self.images
                    self.collectionViewImages.reloadData()
                }
            }
            
        }else{
            Alerts.shared.show(alert: "AppName".localizedString, message: "max_images_validation_msg".localizedString , type: .error )
            
        }
    }
    
    
    private func moveToNextPopUp() {
        
        guard var request = request else{return}
        
        request.materialType = /txtFieldMaterialType.text?.trimmed()
        request.additionalInfo = /txtViewInformation.text?.trimmed()
        request.check_lists = checkListItem
      
        
        if openMoreDetail {
            request.pickupPersonName = /txfSenderName.text?.trimmed()
            request.pickupPersonPhone = /txtDetailPhone.text?.trimmed()
            request.invoiceNumber = /txtDetailInvoice.text?.trimmed()
            request.deliveryPersonName = /txtDropPersonName.text?.trimmed()
            request.elevator_pickup = elevatorPickUp ? "true" : "false"
            request.elevator_dropoff = elevatorDropOff ? "true" : "false"
            request.pickup_level = /txfPickUpLevel.text?.trimmed()
            request.dropoff_level = /txfDropOffLevel.text?.trimmed()
            request.fragile = isFigile ? "1" : "0"
            request.description = /descriptionTextview.text
            
        } else {
            request.pickupPersonName = ""
            request.pickupPersonPhone = ""
            request.invoiceNumber = ""
            request.deliveryPersonName = ""
            request.elevator_pickup = ""
            request.elevator_dropoff = ""
            request.pickup_level = ""
            request.dropoff_level = ""
            request.fragile = ""
            request.description = ""
        }
        
        if let weight = txtFieldWeight.text?.trimmed() {
            request.weight = Double(weight)
        }
        
        if  images.count > 0  {
            request.orderImages = images
        }
        
        
        
        let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
        
        
        
         
         switch template {
        
         case .Default?:
             delegate?.didGetRequestDetails(request: request)
             
         case .Mover?:
             self.delegate?.didSelectNext(type: .SelectLocation)
             
         default:
             break
             
         }
        
        
        minimizeFreightOrderView()
        
        
        
    }
    
    //MARK:- Functions
    
    func configurePickUpPickerView() {
        
          txfPickUpLevel.inputView = pickupPicker
    
          pickupDataSource = PickerViewCustomDataSource(picker: pickupPicker, items: pickupStringArray, columns: 1, aSelectedStringBlock: { (row, item) in
              
          }, textFieldForInputView: txfPickUpLevel)
          
          
          pickupDataSource?.titleForRow = { (row, item) -> String in
            //return String(/((item as? LevelValues)?.level_id))
            return /(item as? String)
          }
          
          pickupDataSource?.aSelectedBlock = { (row, item) in
            //self.txfPickUpLevel.text = String(/((item as? LevelValues)?.level_id))
            //self.pickUpLevelValue = String(/((item as? LevelValues)?.level_value))
            
            self.txfPickUpLevel.text = /(item as? String)
            self.pickUpLevelValue = /(item as? String)
          }
      }
    
    
    func configureDropOffPickerView() {
        
          txfDropOffLevel.inputView = dropupPicker
    
          dropupSizesDataSource = PickerViewCustomDataSource(picker: dropupPicker, items: dropoffStringArray, columns: 1, aSelectedStringBlock: { (row, item) in
              
          }, textFieldForInputView: txfDropOffLevel)
          
          
          dropupSizesDataSource?.titleForRow = { (row, item) -> String in
             //return String(/((item as? LevelValues)?.level_id))
           return /(item as? String)
          }
          
          dropupSizesDataSource?.aSelectedBlock = { (row, item) in
             //self.txfDropOffLevel.text = String(/((item as? LevelValues)?.level_id))
             //self.dropUpLevelValue = String(/((item as? LevelValues)?.level_value))
            
            self.txfDropOffLevel.text = /(item as? String)
            self.dropUpLevelValue = /(item as? String)
          }
      }
    
    
    func minimizeFreightOrderView() {
        checkListItem.removeAll()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            let height = [/self?.heightPopUp, /self?.scrollView.contentSize.height].min()
            self?.frame = CGRect(x: 0 , y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: height!)
            
            }, completion: { (done) in
        })
    }
    
    
    func maximizeFreightOrderView() {
         
        request?.selectedCard?.lastDigit = ""
        if /UDSingleton.shared.appTerminology?.key_value?.check_list == "1" {
             segmentStack.isHidden = true
        } else {
             segmentStack.isHidden = false
        }
        
        btnSchedule.setButtonBorderTitleAndTintColor()
        btnBookNow.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnCheckListContinue.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnAddMore.setButtonWithTitleColorSecondary()
        configurePickUpPickerView()
        configureDropOffPickerView()
        
        
//        stackViewFrigile.isHidden = (/UDSingleton.shared.appTerminology?.categoryData?.fragile) == "0"
//        btnSchedule.isHidden = (/UDSingleton.shared.appTerminology?.key_value?.schedule) == "0"
        
      //  UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
//        let height = [/self.heightPopUp, /self.scrollView.contentSize.height].min()
//            self.frame = CGRect(x: 0, y: (/self.viewSuper?.frame.origin.y + /self.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /height , width: BookingPopUpFrames.WidthPopUp, height: height)
            
//            }, completion: { (done) in
//        })
    }
    
    
    func showFreightOrderView(supView : UIView , moveType : MoveType , requestPara : ServiceRequest) {
        
       // pickupLevelArr = UDSingleton.shared.appSettings?.level_values
       
        
        
        
        
        let levelFirstValue  = LevelValues(level_id: 0, created_at: "", level_value: "0", blocked: "", is_default: "", updated_at: "")
        
        pickupLevelArr?.insert(levelFirstValue, at: 0)
        
        request = requestPara
        heightPopUp = supView.bounds.size.height*0.75//supView.bounds.size.width*120/100
        viewSuper = supView
        
       // txfPickUpLevel.text = String(/pickupLevelArr?.first?.level_id)
       // txfDropOffLevel.text = String(/pickupLevelArr?.first?.level_id)
        
        pickUpLevelValue = String(/pickupLevelArr?.first?.level_value)
        dropUpLevelValue = String(/pickupLevelArr?.first!.level_value)
        
        openMoreDetail = true //requestPara.serviceSelected?.serviceCategoryId == 4
        self.layoutIfNeeded()

        if !isAdded {
            
            txtFieldWeight.setAlignment()
            txtViewInformation.setAlignment()
            txtFieldMaterialType.setAlignment()
            txtViewInformation.placeholderColor = UIColor.placeHolderGray
            descriptionTextview.placeholderColor = UIColor.placeHolderGray
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/viewSuper?.frame.origin.y + /viewSuper?.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: heightPopUp)
            viewSuper?.addSubview(self)

            viewSuper?.layoutIfNeeded()
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/viewSuper?.frame.origin.y + /viewSuper?.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: /[heightPopUp, scrollView.contentSize.height].min())
            
             configureImagesCollectionView()
            isAdded = true
        }

        if moveType == .Forward {
            
            self.txtViewInformation.placeholder = "enter_additional_information".localizedString as NSString
            self.descriptionTextview.placeholder = "Description"
            self.request?.orderImages.removeAll()
            
            
            request?.materialType = nil
            request?.additionalInfo = nil
            request?.weight = nil
            
            txtFieldWeight.text = ""
            txtViewInformation.text = ""
            txtFieldMaterialType.text = ""
            txtDetailName.text = ""
            txtDetailPhone.text = ""
            txtDetailInvoice.text = ""
            txtDropPersonName.text = ""
            txfReceiverName.text = ""
            txfSenderName.text = ""
            lblTotalPrice.text = ""
            checkListItem.removeAll()
            checkListItemTableDataSource?.items = checkListItem
            checkListTableView.reloadData()
            images.removeAll()
            collViewDataSource?.items = images
            collectionViewImages.reloadData()
        }
       
        maximizeFreightOrderView()
    }
    
    private func configureImagesCollectionView() {
        
        
        self.txtFieldWeight.delegate = self
        
        let configureCellBlock : ListCellConfigureBlockCab = { [weak self] (cell, item, indexPath) in
            
            if let cell = cell as? AddImageCell, let image = item as? UIImage {
                cell.assignCellData(image: image)
                cell.callBackDeletion = { (cell : AddImageCell )   in
                    
                    if let indexCell = self?.collectionViewImages.indexPath(for: cell) {
                        
                        ez.runThisInMainThread {
                             self?.images.remove(at: indexCell.row)
                            self?.collViewDataSource?.items = self?.images
                            self?.collectionViewImages.reloadData()
                        }
                    }
                }
            }
        }
        
        
        let widthColl = collectionViewImages.frame.size.height
        
        collViewDataSource = CollectionViewDataSourceCab(items:  images , collectionView: collectionViewImages, cellIdentifier: R.reuseIdentifier.addImageCell.identifier, cellHeight:  widthColl, cellWidth: widthColl , configureCellBlock: configureCellBlock, aRowSelectedListener: nil)
        collectionViewImages.delegate = collViewDataSource
        collectionViewImages.dataSource = collViewDataSource
        collectionViewImages.reloadData()
    }
    
    
    
    //MARK:- TextView Delegates
    //MARK:-
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if validateCheckItems {
            
            let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            let textFieldIndex = textField.tag
            
            if newString == "" {
                checkListItem[textFieldIndex]["after_item_price"] = "0"
            } else {
                checkListItem[textFieldIndex]["after_item_price"] = newString
            }
            
            
            var total = 0
            for checkListItem in checkListItem {
                total = total + (Int(/checkListItem["after_item_price"]) ?? 0)
            }
                       
            self.lblTotalPrice.text = "Total: \(total) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
            
            
        } else {
            if string.isEmpty { return true }
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return replacementText.isValidDouble(maxDecimalPlaces: 2)
        }
        
       return true
    }
}

extension FreightView {
    
    func configureCheckListCell() {
        
        checkListItemTableDataSource = TableViewDataSourceCab.init(items: nil , tableView: checkListTableView, cellIdentifier: R.reuseIdentifier.checkListCell.identifier, cellHeight: 40)
            
            checkListItemTableDataSource?.configureCellBlock = { (cell , item, indexPath) in
                
                if let cell = cell as? CheckListCell, let item = item as? [String: String] {
                    cell.lblItem.text = item["item_name"]
                    cell.txfPrice.text = "\(/item["price"])"
                    cell.btnDelete.tag = indexPath.row
                    cell.lblCurrency.text = /UDSingleton.shared.appSettings?.appSettings?.currency
                }
            }
            
            checkListItemTableDataSource?.aRowSelectedListener = { [weak self] (indexPath, cell, item) in
                
            }
            
            checkListTableView.delegate = checkListItemTableDataSource
            checkListTableView.dataSource = checkListItemTableDataSource
            checkListTableView.reloadData()
    }
    
}






