//
//  ChatListingVC.swift
//  Buraq24
//
//  Created by Apple on 07/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class ChatListingVC: UIViewController {
    
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoMessages: UILabel!
    
    private var getChatUser : [UserList] = []
    private var tableDataSource : TableViewDataSourceCab?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getChatDta()
        setupUI()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.popVC()
    }
    
    

    func setupUI(){
        
        viewNavigation.setViewBackgroundColorHeader()
         configureTableView()
    }
    
    
}




//MARK:- TABLEVIEW DELEGATE FUNCTION
extension ChatListingVC{
    
    func configureTableView() {
        
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            guard let object = self?.getChatUser[indexpath.row] else  {return}
            let firstName = object.name?.components(separatedBy: " ").first
            if let cell = cell as? TableListingTVC {
               // cell.lblName.attributedText = Utility.sendAttString([R.font.montRegular(size: 14)!,R.font.montRegular(size: 12)!], colors: [UIColor.black,UIColor.lightGray], texts: ["\(/firstName)\n",/object.text], align: .left)
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let cDate = formatter.date(from: /object.sent_at)
                if cDate != nil{
                    let time = SharedUtil.timeElapsedFromDate(date: cDate!)
                   // cell.lblTime.font = R.font.montRegular(size: 12)!
                    cell.lblTime.text = time
                }
                
                if let profilePic = object.profile_pic {
                    if let url = URL(string: "\(APIBasePath.basePath)/" + "images/" + profilePic) {
                        cell.imgProfile.sd_setImage(with: url , completed: nil)
                    }else{
                        cell.imgProfile.image = #imageLiteral(resourceName: "ic_user")
                    }
                }
            }
            
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
            if let self = self, let cell = cell as? TableListingTVC {
                let object = self.getChatUser[indexPath.row]
                cell.setSelected(false, animated: true)
                
                guard let editVC = R.storyboard.mainCab.chatVC() else{return}
                editVC.otherUserId = "\(/object.oppositionId)"
                editVC.name = /object.name
                editVC.profilePic = /object.profile_pic
                self.pushVC(editVC)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: getChatUser, tableView: tblView, cellIdentifier: "TableListingTVC", cellHeight: nil)
        
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tblView.delegate = tableDataSource
        tblView.dataSource = tableDataSource
        
        tblView.reloadData()
    }
}
//MARK:- API HIT
extension ChatListingVC{
    
    func getChatDta(){
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let purchasedTokenList = BookServiceEndPoint.getChatList("1", 10, 0)
        
        purchasedTokenList.request(header: ["access_token" :  token]) { [weak self] (response)  in
            switch response{
            case .success(let responseValue):
                self?.getChatUser = (responseValue as? [UserList]) ?? []
                self?.tableDataSource?.items = self?.getChatUser ?? []
                self?.lblNoMessages.isHidden = !(self?.getChatUser ?? []).isEmpty
                DispatchQueue.main.async { [weak self] in self?.tblView.reloadData() }
                
            case .failure(let err):
                self?.lblNoMessages.isHidden = false
                Alerts.shared.show(alert: "AppName".localizedString, message: /err , type: .error)
            }
        }
    }
}
