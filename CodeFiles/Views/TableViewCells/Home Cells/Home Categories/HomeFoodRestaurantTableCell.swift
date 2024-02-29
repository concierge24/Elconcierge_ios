//
//  HomeFoodRestaurantTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 02/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeRateTextView: UIView {
    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- ======== Variables ========
    var rating: Double? {
        didSet {
            let int = /rating?.toInt
            lblTitle.text = int == 0 ? "New".localized() : "\(/rating)"
            backgroundColor = getColor(rating: int)
        }
    }
}

class HomeFoodRestaurantTableCell: UITableViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnLiveTrack: UIButton!
    @IBOutlet weak var viewRating: HomeRateTextView!
    @IBOutlet weak var background_view: UIView!{
        didSet{
            //background_view.backgroundColor = SKAppType.type.alphaColor
        }
    }
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    
    //MARK:- ======== Variables ========
    var blockSelect: ((_ supplier : Supplier?) -> ())?
    
    var objModel: Supplier? {
        didSet {
            
            lblTitle?.text = /objModel?.name
            lblSubTitle?.text = /objModel?.address
            imgPic.loadImage(thumbnail: objModel?.supplierImages?.first, original: nil)
            btnLiveTrack.isHidden = DeliveryType.shared == .pickup
            var array:[String] = []
            if (/objModel?.deliveryMaxTime?.toInt()) > 0 {
                array.append(/objModel?.deliveryMaxTime?.toInt()?.toStringHours)
            }
            if (/objModel?.minOrder?.toInt()) > 0 {
                array.append(/objModel?.minOrder?.toDouble()?.addCurrencyLocale)
            }
            lblPrice.text = array.joined(separator: " - ")
            lblPrice.isHidden = array.isEmpty
            viewRating.rating = /objModel?.rating?.toDouble()
            checkIsOpen()
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgPic.isSkeletonable = true
        self.lblTitle.isSkeletonable = true
        self.lblSubTitle.isSkeletonable = true
        self.lblPrice.isSkeletonable = true
        self.btnLiveTrack.isSkeletonable = true
        self.btnLiveTrack.setTitle("Live Tracking".localized(), for: .normal)
        self.btnLiveTrack.setAlignmentWithOffset(space: 4)
        initalSetup()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnClick(_:)))
        addGestureRecognizer(tap)
    }
    
    //MARK:- ======== Actions ========
    @IBAction func btnClick(_ sender: Any) {
        guard let block = blockSelect else { return }
        block(objModel)
    }
    
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        selectedBackgroundView = UIView()
    }
    
    
    func checkIsOpen(){
        let currentDate = Date()
        
        let calender = Calendar.current
        let week = calender.component(.weekday, from: currentDate)
        let hour = calender.component(.hour, from: currentDate)
        let minutes = calender.component(.minute, from: currentDate)
        //        let seconds = calender.component(.second, from: currentDate)
        let currentSec = getdatesec(hour, minutes)
        print(week)
        let timings = self.objModel?.timing
        var obj: Timings?
        timings?.forEach({ (timeObj) in
            if (/timeObj.week_id + 1) == week{
                obj = timeObj
            }
        })
        
        if let timing = obj {
            self.labelStatus.isHidden = false
            self.viewStatus.isHidden = false
            
            if timing.is_open == 1 {
                var start = /timing.start_time
                let startComp = start.components(separatedBy: ":")
                start = "\(getdatesec(/startComp[0].toInt(), /startComp[1].toInt()))"
                var end = /timing.end_time
                let endComp = end.components(separatedBy: ":")
                end = "\(getdatesec(/endComp[0].toInt(), /endComp[1].toInt()))"
                if /start.toInt() < currentSec && currentSec < /end.toInt(){
                    //                    self.isOpen = true
                    self.viewStatus.backgroundColor = UIColor.green
                    self.labelStatus.textColor = UIColor.green
                    self.labelStatus.text = "Open".localized()
                    return
                }else{
                    //                    self.isOpen = false
                    self.viewStatus.backgroundColor = UIColor.red
                    self.labelStatus.textColor = UIColor.red
                    self.labelStatus.text = "Closed".localized()
                }
            }
            else {
                self.viewStatus.backgroundColor = UIColor.red
                self.labelStatus.textColor = UIColor.red
                self.labelStatus.text = "Closed".localized()
            }
            
        }else{
            //                self.isOpen = false
            self.viewStatus.backgroundColor = UIColor.red
            self.labelStatus.isHidden = true
            self.viewStatus.isHidden = true
        }
    }
    
}
