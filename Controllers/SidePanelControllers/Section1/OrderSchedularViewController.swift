//
//  OrderSchedularViewController.swift
//  Clikat
//
//  Created by Night Reaper on 29/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

enum CalendarMode  {
    case Weekly
    case Monthly
    
    static let allValues = [L10n.Monthly.string , L10n.Weekly.string]

}


enum Weekday : Int {
    
    case Sun = 0
    case Mon = 1
    case Tues = 2
    case Wed = 3
    case Thurs = 4
    case Fri = 5
    case Sat = 6
    
    func value () -> String{
        
        switch self {
        case .Sun:
            return "Sun"
        case .Mon:
           return "Mon"
        case .Tues:
           return "Tues"
        case .Wed:
           return "Wed"
        case .Thurs:
           return "Thurs"
        case .Fri:
           return "Fri"
        default:
          return  "Sat"
        }
        
    }
    
}

class OrderSchedularViewController: BaseViewController {

    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet var calendarContentView: JTHorizontalCalendarView!
    @IBOutlet var viewWeekly : UIView!
    @IBOutlet var btnWeekly: [UIButton]!
    @IBOutlet weak var btnBookingCycle: UIButton!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblBookingValues: UILabel!
    @IBOutlet var btnSetScheduled: Button!{
        didSet{
            btnSetScheduled.kern(kerningValue: ButtonKernValue)
        }
    }
    @IBOutlet weak var btnDate: UIButton! {
        didSet{
            btnDate.setTitle(UtilityFunctions.getTimeFormatted(format: DateFormat.TimeFormatUI, date: Date()), for: .normal)
        }
    }
    
    var selectedTime : Date? = Date()
    var calendarManager : JTCalendarManager!
    var dateSelectedArray : [Date] = []
    var mode : CalendarMode = .Monthly{
        didSet{
          
            if !(oldValue == mode){
                calendarContentView.isHidden = !calendarContentView.isHidden
                viewWeekly.isHidden = !viewWeekly.isHidden
                
                switch mode {
                case .Weekly:
                    selectedDayString()
                default:
                    selectedDateString()
                }
            }

        }
    }
    
    var orderSummary : OrderSummary?
  //  var orderId_Array : [Int]?
    var orderId : String?
    var orderIdArray : [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
      
        updateUI()
        self.IsSchduledDate()

    }
 
    private func updateUI(){
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
        calendarManager.contentView = calendarContentView
        calendarManager.menuView = self.calendarMenuView
    
        calendarManager.setDate(Date())
        calendarContentView.isScrollEnabled = true
//        lblMonth?.text = calendarManager.date().toString(format: "MMM, yyyy")
    }


}


extension OrderSchedularViewController : JTCalendarDelegate {
    
    func IsSchduledDate() -> Date {
        
        
        
        let daysToAdd = 2
     
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        
       
        dateComponent.day = daysToAdd
       
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
//        print(currentDate)
//        print(futureDate!)
        
        return futureDate ?? currentDate
        
    }
    
    func isInDateSelected (date : Date) -> Bool{
        for dateSelected in dateSelectedArray {
            if calendarManager.dateHelper.date(dateSelected, isTheSameDayThan : date){
                return true
            }
        }
        return false
    }
    
    func selectedDateString(){
        
        var dateSringArray : [String] = []
        for dateSelected in dateSelectedArray {
             dateSringArray.append(dateSelected.toString(format: "d"))
        }

        lblBookingValues?.text = ""
    }
    
    func selectedDayString(){
        
        var dayStringArray : [String] = []
        for (index , sender) in btnWeekly.enumerated() {
            if sender.isSelected{
                dayStringArray.append(Weekday(rawValue: index)?.value() ?? "")
                continue
            }
        }
    }

    
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        
        guard let currentDayView = dayView as? JTCalendarDayView else{
            return
        }
        
        if Date().compare(currentDayView.date) == .orderedDescending{
            currentDayView.textLabel.textColor = UIColor.lightGray.withAlphaComponent(0.6)
            currentDayView.circleView.isHidden = true
            currentDayView.backgroundColor = UIColor.clear
            currentDayView.isUserInteractionEnabled = false
        }else if(isInDateSelected(date: currentDayView.date)){
            currentDayView.circleView.isHidden = false
            currentDayView.circleView.backgroundColor = Colors.MainColor.color()
            currentDayView.textLabel.textColor = UIColor.white
            currentDayView.isUserInteractionEnabled = true
        }
            // Other month
        else if (!(calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: currentDayView.date))){
            currentDayView.circleView.isHidden = true
            currentDayView.backgroundColor = UIColor.clear
            currentDayView.textLabel.textColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
            // Another day of the current month
        else{
            currentDayView.circleView.isHidden = true
            currentDayView.backgroundColor = UIColor.clear
            currentDayView.textLabel.textColor = UIColor.black
        }
 
    }
    
    
    
//    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
//        guard let currentDayView = dayView as? JTCalendarDayView else{
//            return
//        }
//
//        if Date().compare(currentDayView.date) == .orderedDescending{
//            currentDayView.textLabel.textColor = UIColor.lightGray.withAlphaComponent(0.6)
//            currentDayView.circleView.isHidden = true
//            currentDayView.backgroundColor = UIColor.clear
//        }else if(isInDateSelected(date: currentDayView.date)){
//            currentDayView.circleView.isHidden = false
//            currentDayView.circleView.backgroundColor = Colors.MainColor.color()
//            currentDayView.textLabel.textColor = UIColor.white
//        }
//            // Other month
//        else if (!(calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: currentDayView.date))){
//            currentDayView.circleView.isHidden = true
//            currentDayView.backgroundColor = UIColor.clear
//            currentDayView.textLabel.textColor = UIColor.lightGray.withAlphaComponent(0.6)
//        }
//            // Another day of the current month
//        else{
//            currentDayView.circleView.isHidden = true
//            currentDayView.backgroundColor = UIColor.clear
//            currentDayView.textLabel.textColor = UIColor.black
//        }
//
//    }
//
    
    func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool {
        
        let cal = Calendar.current
        let maxdate = cal.date(byAdding: .month, value: 2, to: Date())
        return calendarManager.dateHelper.date(date, isEqualOrAfter: Date(), andEqualOrBefore: maxdate)
    }
    
    
//    func calendar(calendar: JTCalendarManager!, canDisplayPageWithDate date: Date!) -> Bool {
//
//        let cal = Calendar.current
//        let maxdate = cal.date(byAdding: .month, value: 2, to: Date())
//        return calendarManager.dateHelper.date(date, isEqualOrAfter: Date(), andEqualOrBefore: maxdate)
//    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        
        guard let currentDayView = dayView as? JTCalendarDayView else{return}
        
        
        // Previous or next month date clicked
        if (!calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: currentDayView.date)){
            // calendarContentView.date.compare(dayVIew.date) == NSComparisonResult.OrderedAscending ? calendarContentView.loadNextPageWithAnimation() : calendarContentView.loadPreviousPageWithAnimation()
            return
        }
        if isInDateSelected(date: currentDayView.date){
            
            dateSelectedArray.removeFirst(currentDayView.date)
            dateSelectedArray.sort(by: { $0.compare($1) == ComparisonResult.orderedAscending })
            selectedDateString()
            UIView.transition(with: currentDayView, duration: 0.3, options: UIView.AnimationOptions.curveEaseInOut , animations: {
                currentDayView.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                weak var weak : OrderSchedularViewController? = self
                weak?.calendarManager.reload()
            }, completion: nil)
            
        }
        else if IsSchduledDate().compare(currentDayView.date) == .orderedAscending {
            
            dateSelectedArray.append(currentDayView.date)
            dateSelectedArray.sort(by: { $0.compare($1) == ComparisonResult.orderedAscending })
            selectedDateString()
            UIView.transition(with: currentDayView, duration: 0.3, options: UIView.AnimationOptions.curveEaseInOut , animations: {
                currentDayView.circleView.transform = CGAffineTransform.identity
                weak var weak : OrderSchedularViewController? = self
                weak?.calendarManager.reload()
            }, completion: nil)

            
        }
            
            
//        else{
//            dateSelectedArray.append(currentDayView.date)
//            dateSelectedArray.sort(by: { $0.compare($1) == ComparisonResult.orderedAscending })
//            selectedDateString()
//            UIView.transition(with: currentDayView, duration: 0.3, options: UIView.AnimationOptions.curveEaseInOut , animations: {
//                currentDayView.circleView.transform = CGAffineTransform.identity
//                weak var weak : OrderSchedularViewController? = self
//                weak?.calendarManager.reload()
//            }, completion: nil)
//
//        }
    }
    
//    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
//        guard let currentDayView = dayView as? JTCalendarDayView else{return}
//
//
//        // Previous or next month date clicked
//        if (!calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: currentDayView.date)){
//           // calendarContentView.date.compare(dayVIew.date) == NSComparisonResult.OrderedAscending ? calendarContentView.loadNextPageWithAnimation() : calendarContentView.loadPreviousPageWithAnimation()
//            return
//        }
//        if isInDateSelected(date: currentDayView.date){
//            dateSelectedArray.removeObject(currentDayView.date)
//            dateSelectedArray.sort(by: { $0.compare($1) == ComparisonResult.orderedAscending })
//            selectedDateString()
//            UIView.transition(with: currentDayView, duration: 0.3, options: UIView.AnimationOptions.curveEaseInOut , animations: {
//                currentDayView.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//                weak var weak : OrderSchedularViewController? = self
//                weak?.calendarManager.reload()
//                }, completion: nil)
//        }
//        else{
//            dateSelectedArray.append(currentDayView.date)
//            dateSelectedArray.sort(by: { $0.compare($1) == ComparisonResult.orderedAscending })
//            selectedDateString()
//            UIView.transition(with: currentDayView, duration: 0.3, options: UIView.AnimationOptions.curveEaseInOut , animations: {
//                currentDayView.circleView.transform = CGAffineTransform.identity
//                weak var weak : OrderSchedularViewController? = self
//                weak?.calendarManager.reload()
//                }, completion: nil)
//
//        }
//    }
    
//    func calendar(calendar: JTCalendarManager!, canDisplayPageWithDate date: NSDate!) -> Bool {
//        return true
//    }
}



//MARK: - Button Actions

extension OrderSchedularViewController{
    
    @IBAction func actionSetSchedule(sender: UIButton) {
        
        webServiceScheduleOrder()
    }
    @IBAction func actionCalendarMode(sender: AnyObject) {
       
        UtilityFunctions.showActionSheet(withTitle: L10n.ChooseBookingCycle.string , subTitle: nil, vc: self, senders: CalendarMode.allValues) { (sender,index) in
            weak var weak : OrderSchedularViewController? = self
            weak?.bookingCycleHandler(withSender: sender)
        }
    }
    
    func bookingCycleHandler (withSender sender : Any?){

        guard let title = sender as? String else{
            return
        }
        btnBookingCycle?.setTitle(title, for: .normal)
        switch title {
        case L10n.Monthly.string:
            mode = .Monthly
        case L10n.Weekly.string:
            mode = .Weekly
        default:
            break
        }
    }
    
    @IBAction func actionWeekMode(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        selectedDayString()
    }
    
    @IBAction func actionBack(sender: UIButton) {
        popVC()
    }
    @IBAction func actionTimePick(sender: UIButton) {
        UtilityFunctions.showDatePicker(viewController: self, datePickerMode: .time, minDate: Date(), title: L10n.SelectBookingTime.string, message: nil, selectedDate: { (date) in
            weak var weakSelf = self
            weakSelf?.selectedTime = date
            weakSelf?.btnDate.setTitle(UtilityFunctions.getTimeFormatted(format: DateFormat.TimeFormatUI, date: date), for: .normal)
            }) {
                
        }
    }
    
    @IBAction func actionSkip(sender: UIButton) {
        getOrderDetails(scheduleOrder: "0")
    }
    
}

//MARK: - Schedule Order Web Service 

extension OrderSchedularViewController {
    
    func webServiceScheduleOrder(){
        
        var selectedSchedule : String = ""
        var tempArr = [String?]()
        switch mode {
        case .Weekly:
            
            for (index,btn) in btnWeekly.enumerated() {
                if btn.isSelected {
                    tempArr.append(String(index))
                }
            }
            selectedSchedule = UtilityFunctions.appendOptionalStrings(withArray: tempArr, separatorString: ",")
        case .Monthly:
            
            for date in dateSelectedArray {
                tempArr.append(UtilityFunctions.getDateFormatted(format: "dd", date: date))
            }
            selectedSchedule = UtilityFunctions.appendOptionalStrings(withArray: tempArr, separatorString: ",")
        }
        if dateSelectedArray.count == 0 {
            UtilityFunctions.showSweetAlert(title: L10n.Warning.string, message: L10n.PleaseSelectDatesToSchedule.string, success: {}, cancel: {})
            return
        }
        
        
        AdjustEvent.ScheduleOrder.sendEvent()
        
      
        let orderIdArr = orderId?.components(separatedBy:[","])
        
        let params = FormatAPIParameters.ScheduleNewOrder(orderId: orderIdArr, deliveryDate: dateSelectedArray, pickUpBuffer: orderSummary?.pickupBuffer,deliveryTime: UtilityFunctions.getTimeFormatted(format: "HH:mm", date: orderSummary?.deliveryDate)).formatParameters()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ScheduleNewOrder(params)) { (response) in
            weak var weakSelf = self
            switch response{
            case .Success(_):
                weakSelf?.handleScheduleOrder()
            case .Failure(_):break
            }
        }
    }
    
    func handleScheduleOrder(){
        
        UtilityFunctions.showSweetAlert(title: L10n.Success.string, message: L10n.YourOrderHaveBeenSheduledSuccessfully.string, style: .Success, success: { [weak self] in
            self?.getOrderDetails(scheduleOrder: "1")
            })
    }
    
    func getOrderDetails(scheduleOrder : String?){
        
        let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
        orderDetailVc.orderDetails = OrderDetails(orderSummary: orderSummary,orderId: orderId,scheduleOrder: scheduleOrder)
        orderDetailVc.type = .OrderUpcoming
        orderDetailVc.isOrderCompletion = true
        self.pushVC(orderDetailVc)
    }
}

extension OrderSchedularViewController {
    
    func addSupplierImage(){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.SupplierImage(FormatAPIParameters.SupplierImage(supplierBranchId: orderSummary?.items?.first?.supplierBranchId).formatParameters())) {[weak self] (response) in
            switch response{
            case .Success(let object):
                guard let image = object as? String else { return }
                self?.addFloatingButton(isCategoryFlow: false, image: image.components(separatedBy: " ").first,supplierId:image.components(separatedBy: " ").last,supplierBranchId: GDataSingleton.sharedInstance.currentSupplierId )
            default :
                break
            }
        }
    }
}

