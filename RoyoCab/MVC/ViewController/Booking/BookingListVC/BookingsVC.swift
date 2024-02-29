//
//  BookingsVC.swift
//  Buraq24
//
//  Created by MANINDER on 25/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit



enum BookingListType : String {
    
    case Past = "Past"
    case Upcoming = "Upcoming"
    
    
}

class BookingsVC : BaseVCCab , RequestCancelDelegate, FSCalendarDelegate {

    //MARK:-  Outlets
    @IBOutlet var btnPast: UIButton!
    @IBOutlet var btnUpcoming: UIButton!
    @IBOutlet var viewScroll: UIScrollView!
    @IBOutlet var viewMovingLine: UIView!
    @IBOutlet weak var btnCalendar: UIButton!
    
    @IBOutlet weak var topCalenderConstraint: NSLayoutConstraint!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet var btnBackBase: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var constraintCentreMovingLine: NSLayoutConstraint!
    
    @IBOutlet var viewPast: UIView!
    @IBOutlet var viewUpcoming: UIView!
    
    @IBOutlet var collectionViewPast: UICollectionView!
    @IBOutlet var collectionViewUpcoming: UICollectionView!
    
    @IBOutlet var lblNoBookingsPast: UILabel!
    @IBOutlet var lblNoBookingsUpcoming: UILabel!
    @IBOutlet weak var btnCloseCalendar: UIButton!
    @IBOutlet weak var btnFilterData: UIButton!
    
    
    @IBOutlet weak var viewTabsBack: UIView!
    //MARK:- Properties
    var collectionViewPastDataSource : CollectionViewDataSourceCab?
    lazy  var arrPastOrder : [OrderCab] = [OrderCab]()
    
    var collectionViewUpComingDataSource : CollectionViewDataSourceCab?
    lazy  var arrComingOrder : [OrderCab] = [OrderCab]()
    lazy var refreshControlPast = UIRefreshControl()
    lazy var refreshControlUpcoming = UIRefreshControl()
    
    //MARK:- view Life cycle
    var listType : BookingListType = .Past
    var isRightToLeft = false
    
    // first date in the range
    var firstDate: Date?
    // last date in the range
    var lastDate: Date?
    
    var datesRange: [Date]?
    
    var pagingPast : Int = 0
    var pagingUpcoming : Int = 0
    var isAllItemPastFetched : Bool = false
    var isAllItemUpcomingFetched : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        swapStackViews()
        configurePastCollectionView()
        configureUpcomingCollectionView()
        getPastBookingList(startDate: "", endDate: "")
        getUpcomingBookingList(startDate: "", endDate: "")
        calender.swipeToChooseGesture.isEnabled = true
        calender.allowsMultipleSelection = true
        calender.delegate = self
        
        btnCloseCalendar.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
        btnFilterData.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
        
    }
    
   /* override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } */
    
    //MARK:- Actions
    @IBAction func btnFilterAction(_ sender: Any) {
        
        let firstDate = datesRange?.first?.toLocalDateInString(format: "YYYY-MM-dd HH:mm:ss")
        let secondDate = datesRange?.last?.toLocalDateInString(format: "YYYY-MM-dd HH:mm:ss")
        getPastBookingList(startDate: /firstDate, endDate: /secondDate)
        getUpcomingBookingList(startDate: /firstDate, endDate: /secondDate)
        
        self.topCalenderConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func btnAnimatecalender(_ sender: Any) {
        self.topCalenderConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnCloseCalnedar(_ sender: Any) {
        self.topCalenderConstraint.constant = -400
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func actionBackPressed(_ sender: Any) {
        popVC()
    }
    
    @IBAction func actionBtnPastPressed(_ sender: Any) {
        viewScroll.scrollRectToVisible(CGRect(x: 0 , y: 0, width: ez.screenWidth, height: viewScroll.bounds.height), animated: true)
        listType = .Past
        animateSwipeControl(type: listType)
    }
    
    @IBAction func actionBtnUpcomingPressed(_ sender: Any) {
        
        viewScroll.scrollRectToVisible(CGRect(x: ez.screenWidth , y: 0, width: ez.screenWidth, height: viewScroll.bounds.height), animated: true)
//         listType = .Upcoming
//        animateSwipeControl(type: listType)
    }

    //MARK:- Functions
    
    func setUpUI() {
        viewScroll.delegate = self
        var imgBack = R.image.ic_back_arrow_black()
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            switch intVal{
            case 3, 5:
                imgBack = #imageLiteral(resourceName: "Back_New")
            default :
                imgBack = R.image.ic_back_arrow_black()
            }
        }
        //btnBackBase.setImage(imgBack?.setLocalizedImage(), for: .normal)
        configureRefreshControl()
         lblTitle?.text = "My Bookings"
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .Moby?:
            //btnBackBase.setImage(R.image.back(), for: .normal)
            btnBackBase.setButtonWithTintColorHeaderText()
            
        case .DeliverSome?:
            lblNoBookingsPast.text = "No deliveries found."
            //btnBackBase.setImage(R.image.back(), for: .normal)
            btnBackBase.setButtonWithTintColorHeaderText()
            
        case .GoMove?:
            lblTitle?.text = "My Bookings"
            btnBackBase.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        case .Corsa:
            btnCalendar.isHidden = false
            break
            
        default:
          
            btnBackBase.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
           //  btnCalendar.isHidden = false
            break
        }
        
        viewTabsBack.setViewBackgroundColorHeader()
        
        btnPast.isSelected = true
        
        btnPast.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.heder_txt_colour ?? DefaultColor.color.rawValue), for: .selected)
        btnPast.setTitleColor(.lightGray, for: .normal)
        
        btnUpcoming.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.heder_txt_colour ?? DefaultColor.color.rawValue), for: .selected)
        btnUpcoming.setTitleColor(.lightGray, for: .normal)
        btnPast.setTitle("Booking.Past".localizedString, for: .normal)
        btnUpcoming.setTitle("Booking.Upcoming".localizedString, for: .normal)
        btnPast.setTitle("Booking.Past".localizedString, for: .selected)
        btnUpcoming.setTitle("Booking.Upcoming".localizedString, for: .selected)
        lblTitle?.text = "Booking.MyBooking".localizedString
        
        
    }
    
    func configureRefreshControl() {
        
        refreshControlPast.addTarget(self, action: #selector(BookingsVC.refreshList(refresh:)), for: UIControl.Event.valueChanged)
        refreshControlPast.tintColor = R.color.appPurple()
        collectionViewPast.refreshControl = refreshControlPast
        
        refreshControlUpcoming.addTarget(self, action: #selector(BookingsVC.refreshList(refresh:)), for: UIControl.Event.valueChanged)
        refreshControlUpcoming.tintColor = R.color.appPurple()
        collectionViewUpcoming.refreshControl = refreshControlUpcoming
    }
    
    
    func toggleBtnStates() {
        
        btnPast.isSelected = listType == .Past ? true : false
        btnUpcoming.isSelected = listType == .Upcoming ? true : false
        
    }
    
    func animateSwipeControl(type : BookingListType) {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            if  self?.isRightToLeft == true {
                self?.constraintCentreMovingLine.constant = self?.listType == .Past ? 0 : -(UIScreen.main.bounds.width/2)
            }else{
                self?.constraintCentreMovingLine.constant = self?.listType == .Past ? 0 : UIScreen.main.bounds.width/2
            }
            self?.toggleBtnStates()
            self?.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func swapStackViews() {
        if isRightToLeft == true {
            if let myView = stackView.subviews.first {
                stackView.removeArrangedSubview(myView)
                stackView.setNeedsLayout()
                stackView.layoutIfNeeded()
                stackView.insertArrangedSubview(myView, at: 1)
                stackView.setNeedsLayout()
            }
        }
    }
    
    func showBookingDetails(order : OrderCab , type : TabType) {
        guard let detailsVC = R.storyboard.sideMenu.bookingDetailVC() else{return}
          detailsVC.order = order
         detailsVC.type = type
        detailsVC.delegateCancellation = self
         self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func showEtokenBookingDetails(order : OrderCab , type : TabType) {
        guard let detailsVC = R.storyboard.drinkingWater.drinkingWaterETokenDeliver() else {return}
        detailsVC.order = order
        detailsVC.type = type
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    //MARK:-  Delegates
    func didSuccessOnCancelRequest() {
        isAllItemUpcomingFetched = false
        pagingUpcoming = 0
        getUpcomingBookingList(startDate: "", endDate: "")
    }
}

//MARK:- Scroll View Delegates

extension  BookingsVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        listType = pageNumber == 0 ? .Past : .Upcoming
        animateSwipeControl(type: listType)
    }
}
//MARK:- API

extension BookingsVC {

  func configurePastCollectionView() {
    
    let configureCellBlock : ListCellConfigureBlockCab = {(cell, item, indexPath) in
        if let cell = cell as? BookingCell , let model = item as? OrderCab {
            cell.assignData(model: model)
        }
    }
    
    let willDisplayCell : WillDisplay = { [weak self]  (indexPath) in
        if indexPath.row + 1 == self?.arrPastOrder.count && !(/self?.isAllItemPastFetched)  {
            self?.pagingPast =   (/self?.pagingPast + 1) * 10
            self?.getPastBookingList(startDate: "", endDate: "")
        }
    }
    
    let didSelectBlock : DidSelectedRowCab = { [weak self] (indexPath, cell, item) in
        if let _ = cell as? BookingCell , let item = item as? OrderCab {
            self?.showBookingDetails(order: item, type: .Past)
        }
    }
   
     let height = ez.screenWidth*62/100
    
     collectionViewPastDataSource =  CollectionViewDataSourceCab(items:  arrPastOrder, collectionView: collectionViewPast, cellIdentifier: R.reuseIdentifier.bookingCell.identifier, cellHeight: height, cellWidth: ez.screenWidth , configureCellBlock: configureCellBlock )
    
     collectionViewPastDataSource?.willDisplay = willDisplayCell
    collectionViewPastDataSource?.aRowSelectedListener = didSelectBlock
    
    collectionViewPast.delegate = collectionViewPastDataSource
    collectionViewPast.dataSource = collectionViewPastDataSource
    collectionViewPast.reloadData()
 }
    
    @objc func refreshList(refresh : UIRefreshControl) {

        refresh.beginRefreshing()
        if refresh == refreshControlPast {
            isAllItemPastFetched = false
            pagingPast = 0
            getPastBookingList(startDate: "", endDate: "")
        }else{
            isAllItemUpcomingFetched = false
            pagingUpcoming = 0
            getUpcomingBookingList(startDate: "", endDate: "")
        }
    }
    
    func getPastBookingList(startDate: String, endDate: String) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let bookingList = BookServiceEndPoint.history(skip: pagingPast, take: 10, type: 1, startDate: startDate, endDate: endDate)
        
        bookingList.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(let data):
                if let arrBookings = data as? [OrderCab] {
                    
                    if self?.pagingPast == 0  {
                        self?.refreshControlPast.endRefreshing()
                         self?.isAllItemPastFetched = false
                        self?.arrPastOrder.removeAll()
                    }
                    
                    if arrBookings.count == 0 || arrBookings.count < 10 {
                        self?.isAllItemPastFetched = true
                    }
                    
                    self?.arrPastOrder.append(contentsOf: arrBookings)
                    
                    ez.runThisInMainThread {
                        self?.collectionViewPastDataSource?.items = self?.arrPastOrder
                        self?.collectionViewPast.reloadData()
                        self?.lblNoBookingsPast.isHidden =  self?.arrPastOrder.count == 0 ? false : true
                    }
                 
                }
            case .failure(let strError):
                
                self?.isAllItemPastFetched = false
                self?.refreshControlPast.endRefreshing()

                if  self?.pagingPast != 0 {
                    self?.pagingPast =  /self?.pagingPast - 1
                }
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )

            }
        }
    }
}

extension BookingsVC {
    
    func configureUpcomingCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {(cell, item, indexPath) in
            if let cell = cell as? BookingCell , let model = item as? OrderCab {
                cell.assignData(model: model)
            }
        }
        
        let didSelectBlock : DidSelectedRowCab = { [weak self] (indexPath, cell, item) in
            if let _ = cell as? BookingCell , let item = item as? OrderCab {
                item.organisationCouponUserId == 0 ?  self?.showBookingDetails(order: item, type: .Upcoming) : self?.showEtokenBookingDetails(order: item, type: .Upcoming)
            }
        }
        let willDisplayCell : WillDisplay = { [weak self]  (indexPath) in
       
            if indexPath.row + 1 == self?.arrComingOrder.count && !(/self?.isAllItemUpcomingFetched)  {
                self?.pagingUpcoming =   /self?.pagingUpcoming + 1
                self?.getPastBookingList(startDate: "", endDate: "")
            }
        }
        
        let height = ez.screenWidth*62/100
        
        collectionViewUpComingDataSource =  CollectionViewDataSourceCab(items:  arrComingOrder, collectionView: collectionViewUpcoming, cellIdentifier: R.reuseIdentifier.bookingCell.identifier, cellHeight: height, cellWidth: ez.screenWidth , configureCellBlock: configureCellBlock )
      
        collectionViewUpComingDataSource?.aRowSelectedListener = didSelectBlock
        collectionViewUpComingDataSource?.willDisplay = willDisplayCell

        collectionViewUpcoming.delegate = collectionViewUpComingDataSource
        collectionViewUpcoming.dataSource = collectionViewUpComingDataSource
        
        collectionViewUpcoming.reloadData()
    }
    
    func getUpcomingBookingList(startDate: String, endDate: String) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let bookingList = BookServiceEndPoint.history(skip: pagingUpcoming, take: 10, type: 2, startDate: startDate, endDate: endDate)
        bookingList.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                if let arrBookings = data as? [OrderCab] {
                  
                    if self?.pagingUpcoming == 0  {
                        self?.refreshControlUpcoming.endRefreshing()

                        self?.isAllItemUpcomingFetched = false
                        self?.arrComingOrder.removeAll()
                    }
                    
                    if arrBookings.count == 0 || arrBookings.count < 10 {
                         self?.isAllItemUpcomingFetched = true
//                        if  self?.pagingUpcoming != 0 {
//                            self?.pagingUpcoming =  /self?.pagingUpcoming - 1
//                        }
                    }
                    
                    self?.arrComingOrder.append(contentsOf: arrBookings)
                    self?.collectionViewUpComingDataSource?.items = self?.arrComingOrder
                    self?.collectionViewUpcoming.reloadData()
                    
                    self?.lblNoBookingsUpcoming.isHidden =  self?.arrComingOrder.count == 0 ? false : true
                    
                }
            case .failure(let strError):
                
                self?.refreshControlUpcoming.endRefreshing()
                self?.isAllItemUpcomingFetched = false
               if  self?.pagingUpcoming != 0 {
                 self?.pagingUpcoming =  /self?.pagingUpcoming - 1
               }
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
          // nothing selected:
          if firstDate == nil {
              firstDate = date
              datesRange = [firstDate!]

              print("datesRange contains: \(datesRange!)")

              return
          }

          // only first date is selected:
          if firstDate != nil && lastDate == nil {
              // handle the case of if the last date is less than the first date:
              if date <= firstDate! {
                  calendar.deselect(firstDate!)
                  firstDate = date
                  datesRange = [firstDate!]

                  print("datesRange55555 contains: \(datesRange!)")

                  return
              }

              let range = datesRange(from: firstDate!, to: date)

              lastDate = range.last

              for d in range {
                  calendar.select(d)
              }

              datesRange = range

              print("datesRange 66666contains: \(datesRange!)")

              return
          }

          // both are selected:
          if firstDate != nil && lastDate != nil {
              for d in calendar.selectedDates {
                  calendar.deselect(d)
              }

              lastDate = nil
              firstDate = nil

              datesRange = []

              print("datesRange11111 contains: \(datesRange!)")
          }
      }

      func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
          // both are selected:

          // NOTE: the is a REDUANDENT CODE:
          if firstDate != nil && lastDate != nil {
              for d in calendar.selectedDates {
                  calendar.deselect(d)
              }

              lastDate = nil
              firstDate = nil

              datesRange = []
              print("datesRang22222 contains: \(datesRange!)")
          }
      }
    
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    
}





