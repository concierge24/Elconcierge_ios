//
//  ServicesViewController.swift
//  Clikat
//
//  Created by cbl73 on 5/7/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class ServicesViewController: CategoryFlowBaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var tableView: SKSTableView!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    
    //MARK:- variables
    let headerHeight = ScreenSize.SCREEN_WIDTH * 0.7
    let headerView = LaundryServiceHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_WIDTH * 0.7))
    var services : [Laundry]?{
        didSet{
            guard let _ = tableView.sksTableViewDelegate else{
                tableView.sksTableViewDelegate = self
                tableView.register(UINib(nibName: CellIdentifiers.ProductListingCell,bundle: nil), forCellReuseIdentifier: CellIdentifiers.ProductListingCell)
                tableView.tableHeaderView = headerView
                return
            }
            tableView?.reloadData()
        }
    }
    
    //MARK: - View Hierarchy Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        webService()
        
    }
   
}

//MARK: - WebService
extension ServicesViewController {
    
    func webService(){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LaundryServices(FormatAPIParameters.LaundryServices(categoryId: passedData.categoryId).formatParameters())) { (response) in
            
            weak var weakSelf = self
            switch response {
            case .Success(let object):
                weakSelf?.services = (object as? LaundryServices)?.services
                break
            case .Failure(_):
                
                break
            }
        }
    }
}

//MARK: - Button Actions
extension ServicesViewController {
    
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
}

extension ServicesViewController : SKSTableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services?.count ?? 0
    }
    
    
    func tableView(_ tableView: SKSTableView!, numberOfSubRowsAt indexPath: IndexPath!) -> Int {
        return services?[indexPath.row].products?.count ?? 0
    }
    
    func tableView(_ tableView: SKSTableView!, shouldExpandSubRowsOfCellAt indexPath: IndexPath!) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ServiceCell) as? ServiceCell else {
            fatalError("Missing ServiceCell identifier")
        }
        print(indexPath.row)
        cell.selectionStyle = .none
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.isExpandable = true
        cell.service = services?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    func tableView(_ tableView: SKSTableView!, heightForSubRowAt indexPath: IndexPath!) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: SKSTableView!, cellForSubRowAt indexPath: IndexPath!) -> UITableViewCell! {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ProductListingCell) else {
            fatalError("Missing Product identifier")
        }
        let products = services?[indexPath.row].products
        (cell as? ProductListingCell)?.product = products?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushNextVc()
    }
    
    func tableView(_ tableView: SKSTableView!, didSelectSubRowAt indexPath: IndexPath!) {
        pushVC(PickupDetailsController.getVC(.laundry))
    }
        
    
}
