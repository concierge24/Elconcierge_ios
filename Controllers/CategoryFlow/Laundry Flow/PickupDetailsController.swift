//
//  PickupDetailsController.swift
//  Clikat
//
//  Created by cblmacmini on 5/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
typealias DateBlock = (Date) -> ()

class PickupDetailsController: CategoryFlowBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var address_view: UIView! {
        didSet {
            address_view.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var change_button: UIButton!
    @IBOutlet weak var placeNoModeStots: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sideMenu_button: ThemeButton! {
        didSet {
            sideMenu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .eCom || SKAppType.type == .carRental ? true : false
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet var btnServicePartner: UIButton!{
        didSet{
            btnServicePartner.setBackgroundColor(SKAppType.type.color, forState: .normal)
            btnServicePartner.kern(kerningValue: ButtonKernValue)
        }
    }
    
    //MARK:- Variable
    var sectionTitle = [SlotTypeOfTime]()
    var morningSlots = [Date]()
    var eveningSlots = [Date]()
    var afternoonSlots = [Date]()
    var nightSlots = [Date]()
    var viewPager: ViewPagerController!
    var options: ViewPagerOptions!
    var seletedTime: Date?
    var selectedIndex: Int = 0 {
        didSet {
            getSlots(date: arrayDates[selectedIndex])
        }
    }
    var selectedAgentId: String?
    lazy var arrayDates: [Date] = {
       return (0..<30).map({ Date().add(days: $0) })
    }()
    var tabs: [ViewPagerTab] = []
    private let reuseIdentifier = "TimeSlotCell"
    lazy var vcTab: UIViewController = {
        return UIViewController()
    }()
    let currentDate = Date()
    var arrayApiSlots = [String]() {
        didSet {
            var seletedDate = currentDate.add(days: selectedIndex).toString(format: Formatters.date)
            if arrayDates.count > selectedIndex {
                seletedDate = arrayDates[selectedIndex].toString(format: Formatters.date)
            }
            var arrayDates: [Date] = arrayApiSlots.map {
                (time) -> Date in
                return "\(seletedDate) \(time) \(Date().timeZone)".toDate(format: .YYYYMMDDHHMMSSZZZZZ) ?? currentDate
            }
            arrayDates.sort()
            
            morningSlots = []
            afternoonSlots = []
            eveningSlots = []
            nightSlots = []
            sectionTitle = []
            
            arrayDates.forEach {
                (date) in
                if date > Date().add(seconds: 60*60) {
                    let hour = Calendar.current.component(.hour, from: date)
                    switch hour {
                    case 0..<12 :
                        morningSlots.append(date)
                    case 12..<16 :
                        afternoonSlots.append(date)
                    case 16..<21 :
                        eveningSlots.append(date)
                    case 21..<24 :
                        nightSlots.append(date)
                    default://Night
                        break
                    }
                }
            }
            
            if !morningSlots.isEmpty {
                sectionTitle.append(.morning)
            }
            
            if !afternoonSlots.isEmpty {
                sectionTitle.append(.afternoon)
            }
            
            if !eveningSlots.isEmpty {
                sectionTitle.append(.evening)
            }
            
            if !nightSlots.isEmpty {
                sectionTitle.append(.night)
            }
            
            placeNoModeStots.isHidden = !sectionTitle.isEmpty
            collectionView.reloadData()
        }
    }
//    var tableDataSource: PickupDetailsDataSource! {
//        didSet {
//            tableView.delegate = tableDataSource
//            tableView.dataSource = tableDataSource
//        }
//    }
//    var pickupDetails : PickupDetails? {
//        didSet {
//            tableDataSource = nil
//            configureTableView()
//            tableView.reloadTableViewData(inView: view)
//        }
//   }
    var blockSelectOnlyDateAndTime: DateBlock?
    var isBeautySalon = false
    var tempPickDetails : Date?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configPager()
//        getAllAdresses()
        
    }
    
    func configPager() {
        setTabs()
        
        options = ViewPagerOptions(viewPagerWithFrame: topView.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewBackgroundDefaultColor = UIColor.clear
        options.tabViewBackgroundHighlightColor = UIColor.clear
        options.tabViewTextHighlightColor = SKAppType.type.color
        options.tabViewTextDefaultColor = SKAppType.type.grayTextColor//UIColor.black
        options.tabIndicatorViewBackgroundColor = SKAppType.type.color //UIColor.black
        
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        topView.addSubview(viewPager.view)
        topView.backgroundColor = SKAppType.type.elementAlphaColor
        collectionView.dataSource = self
        collectionView.delegate = self
        
        selectedIndex = 0

    }
    
    func setTabs() {
        var array: [ViewPagerTab] = []
        for date in arrayDates {
            //            array.append(ViewPagerTab(title: currentDate.add(days: i).toString(format: Formatters.EEEddMMMM), image: UIImage(named: "")))
            array.append(ViewPagerTab(title: date.toString(format: Formatters.EEEddMMMM), image: UIImage(named: "")))
        }
        tabs = array
    }
    
    func getkey(date: Date) {
        let objR = API.GetAgentDBKeys
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(_):
                self.getSlots(date: date)
                
            default:
                break
            }
            
            print(response)
        }
    }
    
    func getSlots(date: Date) {
        
        if GDataSingleton.sharedInstance.agentDBSecretKey == nil {
            getkey(date: date)
            return
        }
        
        self.seletedTime = nil
//        self.arrayApiSlots = []

        var objR = API.getSlotAvailabilties(date: date)
        if let agentId = selectedAgentId {
            objR = API.getAgentAvailabilties(id: agentId, date: date)
        }
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                if let obj = object as? AgentSlotListing {
                    self.arrayApiSlots = obj.array
                    return
                }
                
            default:
                break
            }
            self.arrayApiSlots = []
        }
    }
}

//extension PickupDetailsController {
//
//    func configureTableView() {
//
//        tableDataSource = PickupDetailsDataSource(
//            pickUpDetails: pickupDetails,
//            height: UITableView.automaticDimension,
//            tableView: tableView,
//            cellIdentifier: nil,
//            configureCellBlock: {
//                [weak self] (cell, indexPath) in
//
//                guard let self = self else { return }
//                self.configureCell(cell: cell)
//
//        }, aRowSelectedListener: {
//            [weak self] (indexPath) in
//
//            guard let self = self else { return }
//            self.handleCellSelection(indexPath: indexPath)
//
//        })
//
//    }
//
//    func configureCell(cell : Any?){
//
//        let nextDate = Date().addingTimeInterval(60*60*24)
//        let strDisplayDate = UtilityFunctions.appendOptionalStrings(withArray: [UtilityFunctions.getDateFormatted(format: DateFormat.DateFormatGeneric, date: nextDate),"10 : 00 AM"])
//
//        (cell as? PickupDateCell)?.pickupDate = pickupDetails?.date ?? Date(fromString: strDisplayDate,format: DateFormat.DateFormatGeneric + " " + DateFormat.TimeFormatUI)
//        (cell as? DeliveryAddressCell)?.arrAddress = pickupDetails?.arrAddress
//        tempPickDetails = pickupDetails?.date ?? Date(fromString: strDisplayDate,format: DateFormat.DateFormatGeneric + " " + DateFormat.TimeFormatUI)
//    }
//
//    func handleCellSelection(indexPath : IndexPath){
//        guard let cell = tableView.cellForRow(at: indexPath) as? PickupDateCell else { return }
//
//        var dayComponent = DateComponents()
//        dayComponent.day = 1
//
//        let theCalendar = Calendar.current
//        let nextDate = theCalendar.date(byAdding: dayComponent, to: Date(), wrappingComponents: true)
//        //        let strDisplayDate = UtilityFunctions.appendOptionalStrings(withArray: [UtilityFunctions.getDateFormatted("yyyy-mm-dd", date: nextDate),"10 : 00 AM"])
//        var comps = theCalendar.dateComponents([.day,.month,.year], from: nextDate ?? Date())
//        comps.hour   = 10
//        comps.minute = 00
//        comps.second = 00
//        let newDate = theCalendar.date(from: comps)
//        UtilityFunctions.showDatePicker(viewController: self, minDate: Date(), title: L10n.SelectPickupDateAndTime.string, message: nil, selectedDate: { [weak self] (date) in
//            guard let self = self else { return }
//            cell.pickupDate = date
//            self.pickupDetails?.date = date
//        }) {
//
//        }
//    }
//
//    func setAddressData() {
//
//        if self.pickupDetails?.arrAddress?.count ?? 0 > 0 {
//
//            self.address_label.text = self.pickupDetails?.arrAddress?.first?.address
//            GDataSingleton.sharedInstance.pickupAddress = self.pickupDetails?.arrAddress?.first
//            GDataSingleton.sharedInstance.pickupAddressId = self.pickupDetails?.arrAddress?.first?.id
//
//        } else {
//            self.showSelectedAddress()
//        }
//    }
//
//    func openAdressController() {
//
//        let vc = NewLocationViewController.getVC(.main)
//        vc.transitioningDelegate = self
//        vc.modalPresentationStyle = .custom
//        vc.deliverycompletionBlock = { [weak self] data in
//            guard let strongSelf = self else { return }
//            guard let adressData = data as? Address else {return}
//            strongSelf.address_label.text = adressData.address
//            GDataSingleton.sharedInstance.pickupAddress = adressData
//            GDataSingleton.sharedInstance.pickupAddressId = adressData.id
//
//        }
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    func showSelectedAddress() {
//
//        if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
//            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
//                self.address_label.text = name + " " + locality
//            }
//        } else if let address = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
//            self.address_label.text = address
//        }
//    }
//
//}

////MARK: - Webservices
//extension PickupDetailsController {
//
//    func getAllAdresses() {
//
//        let objR = API.Addresses(FormatAPIParameters.Addresses(supplierBranchId: nil,areaId: LocationSingleton.sharedInstance.location?.areaEN?.id).formatParameters())
//        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
//            [weak self] (result) in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .Success(let object):
//                guard let delivery = object as? Delivery else { return }
//                self.pickupDetails = PickupDetails(arrAddress: delivery.addresses)
//                self.setAddressData()
//            case .Failure(_):
//                break
//            }
//        }
//    }
//}
//MARK: - Button Actions
extension PickupDetailsController {
    
//    @IBAction func change_buttonAction(_ sender: Any) {
//        //Nitin
//        self.openAdressController()
//    }
//
    @IBAction func actionServicePartners(sender: AnyObject) {

        guard let date = seletedTime else {
            SKToast.makeToast(L11n.pleaseSelectTimeSlot.string)
            return
        }
//        pickupDetails?.date = date
        
        if let block = blockSelectOnlyDateAndTime {
            // GDataSingleton.sharedInstance.pickupDate = pickupDetails?.date ?? tempPickDetails
            //            let objAddress = cell.collectionDataSource.items?[selectedIndex] as? Address
            //            GDataSingleton.sharedInstance.pickupAddress = objAddress
            //            GDataSingleton.sharedInstance.pickupAddressId = objAddress?.id
            dismiss(animated: true) {
                block(date)
            }
            return
        }
        
        guard let cell = tableView.visibleCells.last as? DeliveryAddressCell else {
            //            let selectedIndex = cell.selectedIndexPath?.row, (cell.collectionDataSource.items?.count ?? 0) > 0 else {
            // SKToast.makeToast(L10n.PleaseSelectAnAddress.string)
            return
        }
        
        if GDataSingleton.sharedInstance.pickupAddressId == nil {
            SKToast.makeToast("Your address is not saved,please save this address and proceed further.")
            // self.openAdressController()
            return
        }
        
        GDataSingleton.sharedInstance.pickupDate = date //pickupDetails?.date ?? tempPickDetails
        let objAddress = cell.collectionDataSource.items?[selectedIndex] as? Address
        GDataSingleton.sharedInstance.pickupAddress = objAddress
        GDataSingleton.sharedInstance.pickupAddressId = objAddress?.id

        if isBeautySalon {
            laundryData = OrderSummary()
//            laundryData?.pickupDate = pickupDetails?.date ?? tempPickDetails

            SupplierListingViewController.getSuppliers(categoryId: passedData.categoryId, subCategoryId: passedData.subCategoryId, order: laundryData) {
                [weak self] (array) in
                guard let self = self else { return }
                let tempNextVc = StoryboardScene.Main.instantiateSupplierListingViewController()
                tempNextVc.laundryData = self.laundryData
                tempNextVc.passedData = self.passedData

                tempNextVc.suppliers = array

                if array.count == 1 {
                    tempNextVc.view.alpha = 0.0
                    self.navigationController?.pushViewController(tempNextVc, animated: false)
                    tempNextVc.itemClicked(atIndexPath: IndexPath(row: 0, section: 0))

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        if let ind = self.navigationController?.viewControllers.firstIndex(where: { $0 is SupplierListingViewController }) {
                            self.navigationController?.viewControllers.remove(at: ind)
                        }

                    })
                } else {
                    self.pushVC(tempNextVc)
                }
            }

//            SupplierListingViewController.getSuppliers(categoryId: passedData.categoryId, subCategoryId: passedData.subCategoryId, order: laundryData) {
//                [weak self] (array) in
//                guard let self = self else { return }
//
//                let VC = StoryboardScene.Main.instantiateSupplierListingViewController()
//                VC.laundryData = self.laundryData
//                VC.passedData = self.passedData
//                self.navigationController?.pushViewController(VC, animated: array.count != 1)
//                VC.suppliers = array
//
//            }


        }else {

            laundryData = OrderSummary()
            laundryData?.pickupAddress = cell.collectionDataSource.items?[selectedIndex] as? Address
            laundryData?.pickupDate = date //pickupDetails?.date ?? tempPickDetails
            pushNextVc()
        }

    }
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func actionCart(sender: UIButton) {
        
    }
    
    @IBAction func actionBack(sender: UIButton) {
        if let block = blockSelectOnlyDateAndTime {
            dismiss(animated: true) {
            }
            return
        }
        popVC()
    }
}


//MARK:- ======== UICollectionViewDelegate, UICollectionViewDataSource ========
extension PickupDetailsController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let title = sectionTitle[section]
        if title == .morning {
            return morningSlots.count
        }
        else if title == .afternoon {
            return afternoonSlots.count
        }
        else if title == .evening {
            return eveningSlots.count
        }
        else {
            return nightSlots.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            
            let obj = sectionTitle[indexPath.section]
            sectionHeader.sectionHeaderlabel.text = obj.title.localized().uppercased()
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
        let section = sectionTitle[indexPath.section]
        
        var slot: Date?
        if section == .morning {
            slot =  morningSlots[indexPath.row]
        }
        else if section == .afternoon {
            slot =  afternoonSlots[indexPath.row]
        }
        else if section == .evening {
            slot =  eveningSlots[indexPath.row]
        }
        else {
            slot =  nightSlots[indexPath.row]
        }
        cell.date = slot
        cell.isSelect = seletedTime == slot
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TimeSlotCell {
            seletedTime = cell.date
            collectionView.reloadData()
        }
    }
}

extension PickupDetailsController: ViewPagerControllerDataSource, ViewPagerControllerDelegate {
    func viewControllerAtPosition(position: Int) -> UIViewController {
        return vcTab
    }
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
        selectedIndex = index
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to pagess \(index)")
        selectedIndex = index
    }
}
//
////MARK:- UIViewControllerTransitioningDelegate
//extension PickupDetailsController : UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
