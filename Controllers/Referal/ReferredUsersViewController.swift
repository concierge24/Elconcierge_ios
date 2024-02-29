//
//  ReferredUsersViewController.swift
//  Sneni
//
//  Created by Gagandeep Singh on 17/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class ReferredUsersViewController: UIViewController {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    
    //MARK::- PROPERTIES
    lazy var users = [User]()
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getReferals()
    }
    
    
}

//MARK::- TABLEVIEW DELEGATE/DATASOURCE
extension ReferredUsersViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReferredUserTableViewCell", for: indexPath) as? ReferredUserTableViewCell else { return UITableViewCell() }
        cell.user = self.users[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension ReferredUsersViewController {
    
    func getReferals(){
        let objR = API.myReferals
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case APIResponse.Success(let object):
                guard let users = object as? [User] else { return }
                self.users = users
                self.tableView.reloadData()
            default :
                print("Hello Nitin")
                break
            }
           
        }
    }
    
}
