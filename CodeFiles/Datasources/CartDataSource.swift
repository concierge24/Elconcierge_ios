//
//  CartDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 5/11/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SkeletonView

class CartDataSource: TableViewDataSource {
    
    var questions: [Question]?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (items?.count ?? 0)
        case 1:
            return (questions?.count ?? 0)
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = getCellIdentifier(indexpath: indexPath) else{
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock {
            block(cell , indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && (questions?.count ?? 0) > 0 {
            return 50
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && (questions?.count ?? 0) > 0 {
            let headerView = CartQuestionHeader(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 50))
            return headerView
            
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension  //indexPath.row == items?.count ? UITableView.automaticDimension : 120
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func getCellIdentifier(indexpath : IndexPath) -> String? {
        if indexpath.section == 0 {
            return ProductListCell.identifier
        }
        else if indexpath.section == 2 {
            return CartBillCell.identifier
        }
        return CartQuestionCell.identifier//CellIdentifiers.CartListingCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let _ = tableView.cellForRow(at: indexPath) as? ProductListCell {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
               if let block = self.swipeToDeleteBlock {
                   block(indexPath)
               }
           }
           delete.backgroundColor = SKAppType.type.color
           return [delete]
        }
        return []
    }

}
