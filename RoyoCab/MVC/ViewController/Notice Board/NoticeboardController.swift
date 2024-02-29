//
//  NoticeboardController.swift
//  TravaDriver
//
//  Created by Apple on 20/02/20.
//  Copyright © 2020 OSX. All rights reserved.
//

import UIKit

class NoticeboardController: BaseVCCab {
    
    
    //MARK:-Variables.
    var notificationRefreshControl: UIRefreshControl!
    var notifications :[NotificationData]?
    
    //MARK:-IBoutlets.
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblNoResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {

        case .GoMove?:
            lblTitle?.text = "Notifications".localizedString
            
        default:
            break
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.tableFooterView = UIView()
        self.getNotification()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- AddRefreshController To TableView.
    private func addRefreshController() {
        notificationRefreshControl = UIRefreshControl()
        notificationRefreshControl.addTarget(self, action: #selector(refreshNotification(sender:)) , for: .valueChanged)
        tableview.addSubview(notificationRefreshControl)
    }
    
    //MARK:- Function To Refresh News Tableview Data.
    @objc func refreshNotification(sender:AnyObject) {
        getNotification()
    }
    
    func getNotification() {
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        if #available(iOS 16.0, *) {
            BookServiceEndPoint.notification.request(isLoaderNeeded: false, header: ["language_id" : LanguageFile.shared.getLanguage(), "access_token" :  token]) {
                [weak self] (response) in
                
                
                switch response{
                case .success(let response ):
                    if let result = response as? NotificationModel {
                        self?.notifications = result.data
                        
                        if self?.notifications?.count == 0 {
                            self?.lblNoResult.isHidden = false
                        } else {
                            self?.lblNoResult.isHidden = true
                        }
                    }
                    self?.tableview.reloadData()
                case .failure( let str):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /str , type: .error )
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:-UITableViewDelegate&UITableViewDataSource.
extension NoticeboardController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:NoticeboardTableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.noticeboardTableCell, for: indexPath) else {
            return UITableViewCell()
        }
        if let data = self.notifications?[indexPath.row] {
            
            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
            switch template {
            case .GoMove:
                cell.lblHead.text = "Gomove"
                break
            case .DeliverSome:
                cell.lblHead.text = "DeliverSome"
                break
                
            default:
                break
                
            }
           
            cell.messageLabel.text = data.message
            cell.timeLabel.text = data.createdAt?.convertDateFormater()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension String {
    func convertDateFormater() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM dd,yyyy HH:mm a"
        return  dateFormatter.string(from: date!)
    }
}
