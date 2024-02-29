//
//  VehicleTypeTableViewCell.swift
//  Trava
//
//  Created by Dhan Guru Nanak on 11/7/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class VehicleTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblPriceEstimation: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblVehicleSeatsQuantity: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var imageViewVehicleType: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var item : ProductCab?
    var request : ServiceRequest?
    var modalPackages : TravelPackages?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func markProductSelected(selected : Bool , model : ProductCab, modalPackages: TravelPackages?) {
        
        item = model
        self.modalPackages = modalPackages
        
        lblVehicleType.text = /model.productName
        
        
        lblVehicleSeatsQuantity.text = "\("Seating capacity".localizedString) : \(/model.seating_capacity)"
        
        containerView.layer.cornerRadius = 4.0
        lblCurrency.text = (/UDSingleton.shared.appSettings?.appSettings?.currency)

      let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .DeliverSome:
            
            lblVehicleSeatsQuantity.textColor = UIColor.clear
            
            let colorValue = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
            selected ? containerView.addBorder(width: 1, color: colorValue) :  containerView.addBorder(width: 0, color: .clear)
            break
        case .GoMove:
            if /model.productBrandId == 69 || /model.productBrandId == 79 || /model.productBrandId == 73{

                 lblVehicleSeatsQuantity.text = "We bring it in your house"
             }
             else if /model.productBrandId == 74 || /model.productBrandId == 78 || /model.productBrandId == 81{

                  lblVehicleSeatsQuantity.text = "We drop it in front of your house"
             }
             
            
             lblPriceEstimation.isHidden = true
             lblCurrency.isHidden = true
             lblCurrency.text = (/UDSingleton.shared.appSettings?.appSettings?.currency)
            let colorValue = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
            selected ? containerView.addBorder(width: 1, color: colorValue) :  containerView.addBorder(width: 0, color: .clear)
            
        default:
            let colorValue  = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
            selected ? containerView.addBorder(width: 1, color: colorValue) :  containerView.addBorder(width: 0, color: .clear)
        }
        
        
                
        // imgViewBrand.addBorder(width: 0, color: .colorDefaultSkyBlue)
        
       // imageViewVehicleType.image = request?.selectedBrand?.categoryBrandId == 20 ? R.image.ic_micro_inactive() : R.image.ic_bike_inactive()
        
        //#imageLiteral(resourceName: "tonImg")
        imageViewVehicleType.sd_setImage(with: model.imageURL, completed: nil)
        
        // lblBrandName.text = /model.productName
        // lblBrandName.textColor =  selected ? .colorDefaultSkyBlue : .colorDarkGrayPopUp
        
        assignData()
    }
    
    
    // For calculations
    func assignData() {
        
        /* // Ankush
         if    BundleLocalization.sharedInstance().language == Languages.English{
         if request.serviceSelected?.serviceCategoryId == 3{
         txtInfoTotal.text = "Base price"
         }
         else{
         txtInfoTotal.text = "Total"
         }
         }
         
         lblBrandName.text =  /request.serviceSelected?.serviceCategoryId != 2 ?   /request.serviceSelected?.serviceName : /request.selectedBrand?.brandName
         
         var totalCost : Float = 0.0
         
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
        
        
        
        
        // Ankush : User indexpath.row instaed of selected product, as product are multiple and we need to ahow all prices
        
        if modalPackages == nil {
            
            let product = request?.selectedBrand?.products?[/indexPath?.row]
            
            var totalCost : Float = 0.0
            
            if let pricePPD = product?.pricePerDistance {
                totalCost = totalCost + (pricePPD * /request?.distance)
            }
            
            if let pricePPM = product?.price_per_hr {
                totalCost = totalCost + (pricePPM * /request?.duration)
            }
            
            /* Ankush
             if let pricePPQ = product?.pricePerQuantity{
             totalCost = totalCost + (pricePPQ * Float(request.quantity))
             } */
            
            // Ankush  totalCost = totalCost + Float(/product?.alphaPrice)
            totalCost = totalCost + Float(/product?.alphaPrice) // Base price
            
            // Ankush totalCost = totalCost + totalCost.getBuraqShare(percent: /request.serviceSelected?.buraqPercentage)
            
            // Ankush  lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat() + " " + "currency".localizedString
            
            if let percentage = request?.selectedBrand?.buraq_percentage {
                totalCost = totalCost + ((totalCost * percentage) / 100.0)
            }
            
            
            if (Bool(/UDSingleton.shared.appSettings?.appSettings?.surCharge) ?? false) {
                let surchargeCalculatedAmount = calculateSurchargeWithTimeSlot(totalCost: totalCost)
                totalCost = totalCost + surchargeCalculatedAmount
            }
            
            
            lblPriceEstimation.text =  String(totalCost).getTwoDecimalFloat()
            
        } else {
            
            guard let selectedBrand = modalPackages?.package?.pricingData?.categoryBrands?.filter({$0.categoryBrandId == request?.selectedBrand?.categoryBrandId}).first else {return}
            lblPriceEstimation.text =  String((selectedBrand.products?[/indexPath?.row].distance_price_fixed)!).getTwoDecimalFloat()
        }
        
        
        // Ankush btnBookService.titleLabel?.textAlignment = .center
        
        if request?.requestType == .Future {
            
            let strOrderType = "schedule".localizedString
            // Ankush let strDate = strOrderType + "\n" + request?.orderDateTime.toLocalDateAcTOLocale() + ", " + request?.orderDateTime.toLocalTimeAcTOLocale()
            
            
            // Ankush  btnBookService.setTitle( strDate, for: .normal)
            
        }else{
            
            if Localize.currentLanguage()  == Languages.English{
                
                if request?.serviceSelected?.serviceCategoryId == 2{
                    // Ankush  btnBookService.setTitle("Order Now", for: .normal)
                }
                else{
                    // Ankush  btnBookService.setTitle("Book Now", for: .normal)
                }
            }
            else{
                // Ankush  btnBookService.setTitle( "book_now".localizedString, for: .normal)
            }
            
        }
        
    }
    
    
    
    func calculateSurchargeWithTimeSlot(totalCost:Float)->Float{
        
      
        var surchargeAmount:Float = 0.0
        
        if let surChargeArray =  request?.selectedProduct?.surChargeAdmin{
            
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
    
    @IBAction func buttonInfoClicked(_ sender: Any) {
        
        guard let vc = R.storyboard.bookService.fareBreakdownViewController() else {return}
        vc.product = item
        (ez.topMostVC as? HomeVC)?.presentVC(vc)
        
        
    }
    
}
