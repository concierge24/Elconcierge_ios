//
//  WalletVCViewController.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 08/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class WalletVCViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblAmountDes: UILabel!
    @IBOutlet weak var walletTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnSendMoney: UIButton!
    @IBOutlet weak var btnAddMoney: UIButton!
    @IBOutlet weak var lblMinBalBottomConstraints: NSLayoutConstraint!
    
    //MARK:- Properties
    var tableDataSource : TableViewDataSourceCab?
    var walletArray = [WalletModel]()
    var amoutAdd = Int()
      private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        lblAmountDes.text = ""
        lblMinBalBottomConstraints.constant = 0.0
        
        headerView.setViewBackgroundColorSecondary()
        topView.setViewBackgroundColorSecondary()
        btnSendMoney.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
        btnAddMoney.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
        
        configureTableView()
        getWalletData(skip: "0", limit: "50")
        getWalletBalance()
        
        if #available(iOS 10.0, *) {
            walletTableView.refreshControl = refreshControl
        } else {
            walletTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatedWallet), name: NSNotification.Name(rawValue: LocalNotifications.updateWallet.rawValue), object: nil)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
           // Fetch Weather Data
           getWalletData(skip: "0", limit: "50")
           getWalletBalance()
       }
    
    
    @objc func updatedWallet(notification: NSNotification) {
        getWalletData(skip: "0", limit: "50")
        getWalletBalance()
    }
    
    
    @IBAction func btnSendMoneyAction(_ sender: Any) {
        guard let sendMoneyVC = R.storyboard.sideMenu.sendMoneyVCViewController() else { return }
        sendMoneyVC.modalPresentationStyle = .overCurrentContext
        self.presentVC(sendMoneyVC, false)
        
    }
    
    
    @IBAction func btnAddMoneyAction(_ sender: Any) {
        
        guard let vc = R.storyboard.sideMenu.addMoneyVC() else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.amountEntered = { [weak self](amount) in
            
            self?.amoutAdd = amount
            self?.goToCardViewController()
        }
        self.presentVC(vc, false)
        
    }
    
    
    func goToCardViewController(){
        
        guard let vc = R.storyboard.sideMenu.cardListViewController() else { return }
        vc.cardListDelegate = self
        vc.isWallet = true
        self.pushVC(vc)
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.popVC()
    }
    
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { ( cell , item , indexpath) in
            if let cell = cell as? WalletTableCell , let model = item as? WalletModel{
                cell.lblName.text = (model.transaction_by ?? "")
                cell.lblDate.text = model.created_at
                cell.lblAmount.text = "\(/model.amount) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
                
               // if model.transaction_type == ""
                
                
            }
        }

        tableDataSource = TableViewDataSourceCab(items: walletArray, tableView: walletTableView, cellIdentifier: R.reuseIdentifier.walletTableCell.identifier, cellHeight: 50)
        tableDataSource?.configureCellBlock = configureCellBlock

        walletTableView.delegate = tableDataSource
        walletTableView.dataSource = tableDataSource
        walletTableView.reloadData()
    }
    
    
    func getWalletData(skip: String?, limit: String?) {
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
       let walletObjectService = BookServiceEndPoint.walletLogs(skip: skip, limit: limit)
        walletObjectService.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
            switch response {
                                    
                case .success(let data):
                   
                let walletDataArray = data as? [WalletModel]
                self.walletArray = walletDataArray ?? []
                self.tableDataSource?.items = self.walletArray
                self.walletTableView.reloadData()
                    
                case .failure(let strError):
                    
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
        }
    }
    
    
    func getWalletBalance() {
         let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let walletBalance = BookServiceEndPoint.getWalletBalance
        walletBalance.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
            
            switch response {
                
            case .success(let data):
                let walletData = data as? WalletDetails
                self.lblTotalAmount.text = "\(/walletData?.amount) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
                
                
                if (Double(/walletData?.details?.minBalance) ?? 0.0) > 0.0{
                    self.lblAmountDes.text = "Please maintain a minimum balance of   \(/walletData?.details?.minBalance) \(/UDSingleton.shared.appSettings?.appSettings?.currency) in the wallet in order to receive the booking request."
                    self.lblMinBalBottomConstraints.constant = 25
                }
                else{
                    self.lblAmountDes.text = ""
                    self.lblMinBalBottomConstraints.constant = 0
                    
                }
                
                self.refreshControl.endRefreshing()
                
                //   self.lblAmountDes.text = "Please maintain a minimum balance of  \(/walletData?.details?.minBalance) \(/UDSingleton.shared.appSettings?.appSettings?.currency) in the wallet in order to receive the booking request."
                //self.refreshControl.endRefreshing()
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func addMoney(cardId:Int){
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let walletBalance = BookServiceEndPoint.addWalletMoney(amount: amoutAdd, cardId: cardId, gatewayId: /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id)
        walletBalance.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
            
            switch response {
                
            case .success(let data):
                
                self.getWalletData(skip: "0", limit: "50")
                self.getWalletBalance()
               
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
}


extension WalletVCViewController:CardListViewControllerDelegate{
  
    func cardSelected(card: CardCab?) {
        
        print(/card?.customerToken)
        
        self.addMoney(cardId: /card?.userCardId)
        
        
    }
    
    
    
}
