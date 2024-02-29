//
//  OrderParentCell.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import AMRatingControl

enum OrderCellType : String {
    
    case OrderHistory
    case OrderTracking
    case OrderUpcoming
    case OrderScheduled
    case RateOrder
    case LoyaltyPoints
}

protocol OrderParentCellDelegate {
     func actionOrderTypeButton(cell : OrderParentCell, order : OrderDetails?)
     func actionOrderTypeButton(cell : OrderParentCell, orderId : String?)
    func actionPayNow(cell : OrderParentCell, order : OrderDetails?)
}

extension OrderParentCellDelegate {
    func actionPayNow(cell : OrderParentCell, order : OrderDetails?) { }
}

class OrderParentCell: ThemeTableCell {

    //MARK:- IBOutlet
    @IBOutlet weak var viewRating: UIView!{
        didSet{
            viewRating.isHidden = true
            productRate = 0
        }
    }
    @IBOutlet var lblTitleOrderNo: ThemeLabel!
    @IBOutlet weak var labelPlacedOn: UILabel!
    @IBOutlet var lblPlacedDate: UILabel!
    @IBOutlet var btnOrderType: UIButton!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var constraintBtnOrderWidth: NSLayoutConstraint!
    @IBOutlet var lblDeliveryDate: UILabel!
    @IBOutlet var lblOrderNo: UILabel!
    @IBOutlet var lblPriceItems: UILabel! 
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet weak var labelExpectedDelivery: UILabel! {
        didSet {
            labelExpectedDelivery.text = L10n.ExpectedDeliveryOn.string
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var btnPayNow: ThemeButton!
    @IBOutlet var lblPaymentStatus: UILabel!
    
    //MARK:- Variables
    var orderDelegate : OrderParentCellDelegate?
    var orderType: OrderType = .pending
    
    var cellType : OrderCellType = .OrderHistory{
        didSet{
            updateColors()
        }
    }
    var dataSource : CollectionViewDataSource = CollectionViewDataSource(){
        didSet{
            collectionView.dataSource = dataSource
            collectionView.delegate = dataSource
            collectionView.register(UINib(nibName: CellIdentifiers.OrderImageCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.OrderImageCell)
        }
    }
    
//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_big_grey), solidImage: UIImage(asset : Asset.Ic_star_big_yellow), andMaxRating: 5)
    var rateControl: AMRatingControl!
    
    var productRate : Int = 0 {
        didSet {
            
            defer {
                if !viewRating.subviews.isEmpty {
                    
                    viewRating.subviews.forEach({ $0.removeFromSuperview() })
                    rateControl = nil
                }
                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
                rateControl.frame = viewRating.bounds
                rateControl?.rating = productRate
                rateControl?.starWidthAndHeight = 32
                //                rateControl?.isUserInteractionEnabled = false
//                viewRating.addSubview(rateControl)
            }
        }
    }
    var order : OrderDetails?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        lblTitleOrderNo.text = L10n.OrderNo.stringFor(appType: order?.appType)
        //lblStatus?.text = order?.status.stringValue()
        if let detail = order {
            lblStatus?.text = detail.status.stringValue(deliveryType: detail.deliveryStatus ?? .delivery, appType: detail.appType)
        }
        lblOrderNo?.text = order?.orderId
        let itemtext = order?.productCount == "1" ? "Item".localized() : L10n.Items.string
        let netAmount = order?.netAmount?.toDouble() ?? 0.0
//        let discount = order?.discountAmount?.toDouble() ?? 0.0
//        let referralDiscount = /order?.referral_amount
//        let tipAmount = order?.tipAgent?.toDouble() ?? 0.0
//        let serviceCharge = /order?.user_service_charge?.toDouble()
        let total = netAmount// + tipAmount + serviceCharge - discount - referralDiscount

        lblPriceItems?.text = total.addCurrencyLocale + "  •  " + UtilityFunctions.appendOptionalStrings(withArray: [order?.productCount , itemtext])
        
        lblPlacedDate?.text = order?.createdOn
        
        updateColors()

        let width : CGFloat = 100.0
        dataSource = CollectionViewDataSource(items: order?.product , tableView: collectionView, cellIdentifier: CellIdentifiers.OrderImageCell , headerIdentifier: nil, cellHeight: width , cellWidth: width , configureCellBlock: {
            (cell, item) in

            guard let product = item as? ProductF , let tempCell = cell as? OrderImageCell else{
                return
            }
            tempCell.product = product
            
            }, aRowSelectedListener: { (indexPath) in
        })
    }
    
    private func updateColors(){
        
        lblDetails?.isHidden = true
        let color = order?.status.color()
        btnOrderType?.layer.borderWidth = 1
        btnOrderType.setTitleColor(ButtonThemeColor.shared.btnTextThemeColor, for: .normal)
        btnOrderType?.layer.borderColor = ButtonThemeColor.shared.btnBorderThemeColor.cgColor
        btnPayNow?.isHidden = true
        lblPaymentStatus?.isHidden = true
        lblStatus?.isHidden = false
        //color?.cgColor
        lblStatus?.textColor = LabelThemeColor.shared.lblThemeColor
        
        //Nitin
        //labelExpectedDelivery?.text = (SKAppType.type == .home || SKAppType.type == .gym) ? L11n.expectedEndOn.string : L11n.expectedDeliveryOn.string
        
        //labelExpectedDelivery?.text = (SKAppType.type == .home) ? L11n.expectedEndOn.string : L11n.expectedDeliveryOn.string
        guard let orderDetail = order else { return }
        switch cellType {
        case .OrderHistory:
            btnOrderType.isHidden = true
            btnOrderType?.setTitle(L10n.REORDER.string, for: .normal)
            //btnOrderType?.isHidden = order?.status == .Delivered ? false : true
            
            if order?.status == .Rejected || order?.status == .none || order?.status == .CustomerCancel {
                labelExpectedDelivery?.text = ""
                lblDeliveryDate?.text = ""
                return
            }
          //  labelExpectedDelivery?.text = (SKAppType.type == .home) ? L11n.end.string : L10n.DeliveredOn.string
            
            //Nitin
            if orderType == .pending {
               labelExpectedDelivery?.text = (order?.appType == .home) ? L11n.startOn.string : L10n.ExpectedDeliveryOn.string
                if order?.appType == .home {
                    lblDeliveryDate?.text = order?.serviceDate
                }
                else {
                    lblDeliveryDate?.text = order?.deliveredOn
                }
            } else {
                labelExpectedDelivery?.text = (order?.appType == .home) ? L11n.endOn.string : L10n.DeliveredOn.string
                lblDeliveryDate?.text = order?.deliveredOn
            }
           // labelExpectedDelivery?.text = (SKAppType.type == .home || SKAppType.type == .gym) ? L11n.end.string : L10n.DeliveredOn.string

            lblDetails?.isHidden = false
           // btnOrderType?.isHidden = LocationSingleton.sharedInstance.location?.areaEN?.id == order?.areaId ? false : true
           
        case .OrderTracking:
            lblDeliveryDate?.text = order?.deliveredOn
            btnOrderType?.setTitle(L10n.TRACK.string, for: .normal)
        case .OrderUpcoming:

            if order?.appType == .home {
                if orderType == .pending {
                    labelExpectedDelivery?.text = L11n.startOn.string
                    lblDeliveryDate?.text = order?.serviceDate
                    
                } else {
                    labelExpectedDelivery?.text = L11n.endOn.string
                    lblDeliveryDate?.text = order?.deliveredOn
                }
            }
            else {
                labelExpectedDelivery?.text = L10n.ExpectedDeliveryOn.string
                lblDeliveryDate?.text = order?.deliveredOn
            }

            constraintBtnOrderWidth?.constant = 120.0
            layoutIfNeeded()
            if let schdeuledParameter = order?.scheduleOrder, schdeuledParameter == "1"{
                btnOrderType?.setTitle(L10n.CONFIRMORDER.string, for: .normal)
            }
            else {
                if /order?.shouldPayAfterConfirmation || /order?.shouldPayRemainingAmount {
                    //btnPayNow?.isHidden = false
                    lblPaymentStatus?.isHidden = false
                    lblStatus?.isHidden = true
                }
                btnOrderType.isHidden = order?.status != .Pending
                btnOrderType?.setTitle(L10n.CANCELORDER.string, for: .normal)
                
            }
        case .RateOrder:
            lblDeliveryDate?.text = order?.deliveredOn
            labelExpectedDelivery?.text = (order?.appType == .home) ? L11n.end.string : L10n.DELIVERED.string
  
            //Nitin
//            labelExpectedDelivery?.text = (SKAppType.type == .home || SKAppType.type == .gym) ? L11n.end.string : L10n.DELIVERED.string

            viewRating?.isHidden = false
        case .OrderScheduled:
            lblDeliveryDate?.text = order?.serviceDate
            btnOrderType?.setTitle(L10n.CONFIRMORDER.string, for: .normal)
            constraintBtnOrderWidth?.constant = 120.0
            layoutIfNeeded()
        case .LoyaltyPoints:
            updateUILoyalty()
        }

   
    }
  
    @IBAction func payNow(_ sender: Any) {
        orderDelegate?.actionPayNow(cell: self, order: order)
    }
    
    @IBAction func actionOrderType(sender: AnyObject) {
        
        orderDelegate?.actionOrderTypeButton(cell: self, order: order)
        orderDelegate?.actionOrderTypeButton(cell : self, orderId: order?.orderId)
    }
}

//MARK: - Update UI Loyalty Points
extension OrderParentCell {
    
    func updateUILoyalty(){
        btnOrderType?.isHidden = true
        labelPlacedOn?.isHidden = true
        
        lblPriceItems?.text = UtilityFunctions.appendOptionalStrings(withArray: [order?.totalPoints, L10n.Points.string]) + "  •  " + UtilityFunctions.appendOptionalStrings(withArray: [order?.product?.count.toString , L10n.Items.string])
        lblDeliveryDate?.text = order?.serviceDate
    }
}
