//
//  SelectBrandCell.swift
//  Buraq24
//
//  Created by MANINDER on 04/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import CoreLocation


class SelectBrandCell: UICollectionViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet var imgViewBrand: UIImageView!
    @IBOutlet var viewImgBrand: UIView!
    @IBOutlet weak var labelEstimateTime: UILabel!
    
    @IBOutlet weak var labelEstimatePrice: UILabel!
    @IBOutlet var lblBrandName: UILabel!
    
    //MARK:- properties
    var indexPath: IndexPath?
    var estimatedDistanceInKm: Float?
    var estimatedTimeinMins: Int?
    
    
    //MARK:- Functions
    
    func markAsSelected(selected : Bool , model : Brand, drivers: [HomeDriver]?, estimatedDistanceInKm: Float?, estimatedTimeinMins: Int?, request: ServiceRequest?) {
        
        self.estimatedDistanceInKm = estimatedDistanceInKm
        self.estimatedTimeinMins = estimatedTimeinMins
        
        viewImgBrand.cornerRadius(radius: viewImgBrand.bounds.width/2)

        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .DeliverSome:
            let colorValue = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
            selected == true ? viewImgBrand.addBorder(width: 2, color: colorValue) :  viewImgBrand.addBorder(width: 0, color: .gray)
            imgViewBrand.sd_setImage(with: model.imageURL, completed: nil)
            print(model.imageURL)
            lblBrandName.text = /model.brandName
            lblBrandName.textColor =  selected == true ? colorValue : .colorDarkGrayPopUp
            
        default:
            let colorValue  = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
            selected == true ? viewImgBrand.addBorder(width: 2, color: colorValue) :  viewImgBrand.addBorder(width: 0, color: .gray)
            imgViewBrand.sd_setImage(with: model.imageURL, completed: nil)
            print(model.imageURL)
            lblBrandName.text = /model.brandName
            lblBrandName.textColor =  selected == true ? colorValue : .colorDarkGrayPopUp
        }
       
       // imgViewBrand.sd_setImage(with: model.imageURL, completed: nil)
        
       
        
        let filteredDriver = drivers?.filter({/$0.category_brand_id == /model.categoryBrandId}).first
        let product = model.products?.first
        var totalCost : Float = 0.0
       
        
        if filteredDriver == nil {
            
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .Corsa:
                
            if let pricePPD = product?.pricePerDistance {
               totalCost = totalCost + (pricePPD * /estimatedDistanceInKm)
              }
              
              //if let pricePPM = product?.price_per_hr {
              //     totalCost = totalCost + (pricePPM * Float(/estimatedTimeinMins))
              // }
              
              totalCost = totalCost + Float(/product?.alphaPrice) // Base price
              
              if let percentage = model.buraq_percentage {
                  totalCost = totalCost + ((totalCost * percentage) / 100.0)
              }
                  
            
            // labelEstimatePrice.text = "Est \("currency".localizedString) \(String(totalCost).getTwoDecimalFloat())"
              
              let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
              switch template {
              case .GoMove:
                  labelEstimatePrice.text = ""
                  break
                  
              default:
                  labelEstimatePrice.text = "Est \(/UDSingleton.shared.appSettings?.appSettings?.currency) \(String(totalCost).getTwoDecimalFloat())"
              }
                              
                
                break
                
            default:
                labelEstimatePrice.text = " "
                labelEstimateTime.text = "No Driver".localizedString
            }
            
            
           
            
            
        } else {
            
            let pickUpLocation = CLLocation(latitude: /request?.latitudeDest, longitude: /request?.longitudeDest)
            let DropOffLocation = CLLocation(latitude: /filteredDriver?.latitude, longitude: /filteredDriver?.longitude)
            
            let distanceInMeter = GoogleMapsDataSource.getDistance(newPosition: DropOffLocation, previous: pickUpLocation)
            let timeInMins = (distanceInMeter/60.0) // 60 kmph - speed of vehicle
            let timeInSeconds = Int(ceil(/timeInMins)) * 60
            let time = Utility.shared.convertToReadableTimeDuration(seconds: Int(timeInSeconds))
            labelEstimateTime.text = time
           
            
            if let pricePPD = product?.pricePerDistance {
             totalCost = totalCost + (pricePPD * /estimatedDistanceInKm)
            }
            
//            if let pricePPM = product?.price_per_hr {
//                totalCost = totalCost + (pricePPM * Float(/estimatedTimeinMins))
//            }
            
            totalCost = totalCost + Float(/product?.alphaPrice) // Base price
            
            if let percentage = model.buraq_percentage {
                totalCost = totalCost + ((totalCost * percentage) / 100.0)
            }
            
            
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .GoMove:
                labelEstimatePrice.text = ""
                break
                
            default:
                 labelEstimatePrice.text = "Est \(/UDSingleton.shared.appSettings?.appSettings?.currency) \(String(totalCost).getTwoDecimalFloat())"
            }
            
            
           // labelEstimatePrice.text = "Est \("currency".localizedString) \(String(totalCost).getTwoDecimalFloat())"
           
            
        }
    }
    
    func markProductSelected(selected : Bool , model : ProductCab) {
        
        viewImgBrand.cornerRadius(radius: viewImgBrand.bounds.width/2)

      let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
             switch template {
                    
                case .DeliverSome?:
                  let colorValue  = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
                  selected ? viewImgBrand.addBorder(width: 2, color: colorValue) :  viewImgBrand.addBorder(width: 0, color: .gray)
                 break
                 
                default:
                  let colorValue  = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
                  selected ? viewImgBrand.addBorder(width: 2, color: colorValue) :  viewImgBrand.addBorder(width: 0, color: .gray)
                 
             }
        
       // imgViewBrand.addBorder(width: 0, color: .colorDefaultSkyBlue)
        
      //  imgViewBrand.image = #imageLiteral(resourceName: "tonImg")
        //        imgViewBrand.sd_setImage(with: model.imageURL, completed: nil)
        lblBrandName.text = /model.productName
        lblBrandName.textColor =  selected ? .colorDefaultSkyBlue : .colorDarkGrayPopUp
    }
    
}


