//
//  AgentTimeSlotVC.swift
//  Sneni
//
//  Created by Mac_Mini17 on 10/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

enum SlotTypeOfTime {
    case morning
    case evening
    case afternoon
    case night

    var title: String {
        switch self {
        case .morning: return "Morning"
        case .evening: return "Evening"
        case .afternoon: return "Afternoon"
        case .night: return "Night"
        }
    }
}

class AgentTimeSlotVC: BaseVC {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblCountReviews: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var lblRating: ThemeLabel!


    //MARK:- ======== Variables ========
    var objModel: AgentListingData?
    var blockDone: ((Date?) -> ())?
    private let reuseIdentifier = "TimeSlotCell"

    let currentDate = Date()
    var selectedAgentId: String?
    var timeInterVal : Double = 0
    var selectedIndex: Int = 0 {
        didSet {
            getSlots(agentId: selectedAgentId, date: arrayDates[selectedIndex])
        }
    }
    lazy var vcTab: UIViewController = {
        return UIViewController()
    }()
    var arrayDates = [Date]()
    var tabs: [ViewPagerTab] = []
    func setTabs() {
        var array: [ViewPagerTab] = []
        for date in arrayDates {
//            array.append(ViewPagerTab(title: currentDate.add(days: i).toString(format: Formatters.EEEddMMMM), image: UIImage(named: "")))
            array.append(ViewPagerTab(title: date.toString(format: Formatters.EEEddMMMM), image: UIImage(named: "")))
        }
        tabs = array
    }
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
                    default: break
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
            
           // placeNoModeStots.isHidden = !sectionTitle.isEmpty
            collectionView.reloadData()
        }
    }
    
    var sectionTitle = [SlotTypeOfTime]()
    var morningSlots = [Date]()
    var eveningSlots = [Date]()
    var afternoonSlots = [Date]()
    var nightSlots = [Date]()
    var seletedTime: Date?
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabs()
        lblTitle.text =   "\(L11n.select.string) \(SKAppType.type.agent)"
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
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
        
        topView.backgroundColor = SKAppType.type.elementAlphaColor
        topView.addSubview(viewPager.view)
        
//        self.setupTimeSlotter()
        selectedIndex = 0
        
        lblName.text = objModel?.cblUser?.name
        
        let occ = objModel?.cblUser?.occupation ?? ""
        let exp = "\(/objModel?.cblUser?.experience)" + " " + L11n.yearsExperience.string
        lblOccupation.text = [occ, exp].joined(separator: " | ")
        //lblCountReviews.text = "[ 0 Review ]"

        imgUser.loadImage(thumbnail: objModel?.cblUser?.image, original: nil, placeHolder: Asset.ic_dummy_user.image)
        
        guard let cblUser = objModel?.cblUser else { return }
        lblRating.text = "\(cblUser.avg_rating)"
        lblCountReviews.text = cblUser.reviewsStr
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        options.viewPagerFrame = topView.bounds
    }

}

extension AgentTimeSlotVC: ViewPagerControllerDataSource, ViewPagerControllerDelegate {
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

//MARK:- ======== UICollectionViewDelegate, UICollectionViewDataSource ========
extension AgentTimeSlotVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader
        {
            
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

//MARK:- ======== Actions ========
extension AgentTimeSlotVC{
    
    @IBAction func backBtnClick(sender:UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func didTapBookNow(_ sender:UIButton) {
//        if let vc = (self.presentingViewController as? LeftNavigationViewController)?.viewControllers.first(where: { $0 is AgentListingVC }) as? AgentListingVC {
//            vc.selectedDate = seletedTime ?? Date()
//        }
//        self.dismissVC {
//            [weak self] in
//            guard let self = self else { return }
//        }
        let date = seletedTime ?? Date()
        verifySlots(agentId: /selectedAgentId, date: date, duration: Int(timeInterVal)) { [weak self] in
            self?.blockDone?(date)
        }
    }
    
}

//MARK:- ======== Api's ========
extension AgentTimeSlotVC{
    func getSlots(agentId: String?, date: Date){

        self.seletedTime = nil
        let objR = API.getAgentAvailabilties(id: agentId, date: date)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                if let obj = object as? AgentSlotListing {
                    self.arrayApiSlots = obj.array
                }
                
            default:
                break
            }
        }
    }
    
    class func getAvailabilty(id: String, block: (([Date]) -> ())?) {
        let objR = API.getAgentAvailabilty(id: id)//"61")
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            (response) in
            
            switch response {
            case .Success(let object):
                if let obj = object as? AvailabilityModel {
                    block?(obj.getAllDates())
                } else {
                    block?([])
                }
                
            default:
                block?([])
            }
        }
    }
    
    
    func verifySlots(agentId: String, date: Date, duration: Int, completion: @escaping EmptyBlock) {
        let objR = API.verifySlot(agentId: agentId, duration: duration, datetime: date)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            (response) in
            
            switch response {
            case .Success(let object):
                completion()
                
            default:
               break
            }
        }
    }
}
