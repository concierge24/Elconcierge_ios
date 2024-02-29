//
//  PrescriptionRequestsVC.swift
//  Sneni
//
//  Created by Daman on 01/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import ESPullToRefresh

class PrescriptionRequestsVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewNoData: UIView!
    
    var dataSource : TableViewDataSource = TableViewDataSource(){
          didSet{
              tableView?.dataSource = dataSource
              tableView?.delegate = dataSource
          }
      }
    var requests: [RequestModel] = []
    var skip = 0
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableViewInitialization()
        addLoadMore()
        getRequests()
    }
    
    func addLoadMore() {
        tableView.es.addInfiniteScrolling { [weak self] in
            guard let `self` = self else { return }
            if self.totalCount == self.requests.count {
                self.tableView.es.stopLoadingMore()
                self.tableView.es.removeRefreshFooter()
                return
            }
            self.getRequests()
        }
    }
    
    func reloadData() {
        skip = 0
        addLoadMore()
        getRequests()
    }
    
    func getRequests()  {
        let objR = API.requestList(skip: skip)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            self.tableView.es.stopLoadingMore()

            switch response {
            case APIResponse.Success(let object):
                guard let objModel = object as? RequestList else { return }
                self.totalCount = objModel.totalCount ?? 0
                let arr = objModel.data ?? []
                if self.skip == 0 {
                    self.requests = arr
                }
                else {
                    self.requests.append(contentsOf: arr)
                }
                if !arr.isEmpty {
                    self.skip += 1
                }
                self.reloadTable()
                break
            default :
                break
            }
        }
    }
    
    
    func cancelRequest(requestId: Int)  {
         let objR = API.cancelRquest(requestId: requestId, reason: "")
         
         APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
             [weak self] (response) in
             guard let self = self else { return }
             self.tableView.es.stopLoadingMore()

             switch response {
             case APIResponse.Success(let object):
                if let index = self.requests.firstIndex(where: {$0.requestId == requestId}) {
                    self.requests.remove(at: index)
                }
                 self.reloadTable()
                 break
             default :
                 break
             }
         }
     }
    
    func reloadTable() {
        viewNoData.isHidden = !requests.isEmpty
        dataSource.items = requests
        tableView.reloadData()
        if self.totalCount == self.requests.count {
            tableView.es.removeRefreshFooter()
        }
    }
    
    func configureTableViewInitialization(){
        dataSource = TableViewDataSource(items: requests, height: 150, tableView: tableView, cellIdentifier: PrescriptionRequestCell.identifier , configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
            let model = item as! RequestModel
            (cell as? PrescriptionRequestCell)?.configureCell(model)
            (cell as? PrescriptionRequestCell)?.cancelPressed = { [weak self] in
                UtilityFunctions.showAlert(title: nil, message: "Are you sure you want to cancel this request?".localized(), success: {
                            [weak self] in
                            guard let self = self else { return }
                            self.cancelRequest(requestId: /model.requestId)
                            }, cancel: {})
            }
            
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            
        })
        tableView.reloadData()
    }

}
