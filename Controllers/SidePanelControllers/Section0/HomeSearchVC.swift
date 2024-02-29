//
//  HomeSearchVC.swift
//  Sneni
//
//  Created by MAc_mini on 15/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeSearchVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    
    //MARK:- Variables
    var AllData:Array<Dictionary<String,String>> = []
    var SearchData:Array<Dictionary<String,String>> = []
    var search:String=""
    var tableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = tableViewDataSource
            tableView?.delegate = tableViewDataSource
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AllData = [["pic":"list0.jpg", "name":"Angel Mark", "msg":"Hi there, I would like read your...", "time":"just now", "unread":"12"],
                   ["pic":"list1.jpg", "name":"John Doe", "msg":"I would prefer reading on night...", "time":"56 second ago", "unread":"2"],
                   ["pic":"list2.jpg", "name":"Krishta Hide", "msg":"Okey Great..!", "time":"2m ago", "unread":"0"],
                   ["pic":"list3.jpg", "name":"Keithy Pamela", "msg":"I am waiting there", "time":"5h ago", "unread":"0"]
        ]
        
        SearchData=AllData
        
        self.configureTableViewInitialization()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: - TableView Configuration Methods
extension HomeSearchVC {
    
    func configureTableViewInitialization(){
        
        tableViewDataSource = TableViewDataSource(items: SearchData, height: 45.0 , tableView: tableView, cellIdentifier: CellIdentifiers.SearchTableViewCell , configureCellBlock: { (cell, item) in
            weak var weakSelf : HomeSearchVC? = self
            
            weakSelf?.configureCell(withCell: cell, item: item)
        }, aRowSelectedListener: { (indexPath) in
            weak var weakSelf : HomeSearchVC? = self
           // weakSelf?.itemClicked(atIndexPath: indexPath)
        })
        
        //        tableViewDataSource.viewforHeaderInSection = { (section) in
        //            weak var weakSelf = self
        //            let sponsorView = SponsorView(frame: CGRect(x: 0, y: 0, w: ScreenSize.SCREEN_WIDTH, h: 48))
        //            guard let image = weakSelf?.sponsor?.logo,url = NSURL(string: image) else { return nil }
        //            sponsorView.imageViewSponsor.yy_setImageWithURL(url, options: .ProgressiveBlur)
        //            return sponsorView
        //        }
        
    }
    
    
    func configureCell(withCell cell : Any , item : Any? ){
       
        guard let tempCell = cell as? SearchTableViewCell else{
            return
        }
        let object = item as? [String:String]
        tempCell.searchString = object?["name"]
    }
    
//    func itemClicked(atIndexPath indexPath : IndexPath){
//
//        guard let supplierId = (tableViewDataSource.items?[indexPath.row] as? Supplier)?.id , let supplierBranchId = (tableViewDataSource.items?[indexPath.row] as? Supplier)?.supplierBranchId else{
//            return
//        }
//        GDataSingleton.sharedInstance.currentSupplier = tableViewDataSource.items?[indexPath.row] as? Supplier
//        let supp = GDataSingleton.sharedInstance.currentSupplier
//        supp?.categoryId = passedData.categoryId
//        GDataSingleton.sharedInstance.currentSupplier = supp
//        ez.runThisInMainThread {
//            weak var weakSelf : SupplierListingViewController? = self
//            weakSelf?.passedData.supplierId = supplierId
//            weakSelf?.passedData.supplierBranchId = supplierBranchId
//            weakSelf?.pushNextVc()
//        }
//    }
}


extension HomeSearchVC{
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
}

extension HomeSearchVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissVC(completion:nil)
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if string.isEmpty{
            search = String(search.dropLast())
        } else{
            search=textField.text!+string
        }
       
        let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@", search)
        let arr=(AllData as NSArray).filtered(using: predicate)
        
        if arr.count > 0 {
            SearchData.removeAll(keepingCapacity: true)
            SearchData=arr as! Array<Dictionary<String,String>>
        } else{
            SearchData=AllData
        }
        
        tableViewDataSource.items = SearchData
        print("SearchData-----------\(SearchData)")
        tableView.reloadData()
        return true

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        constraintTableViewBottom.constant = 260
        view.layoutIfNeeded()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        constraintTableViewBottom.constant = 0        
        view.layoutIfNeeded()
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        view.endEditing(true)
//        return true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
