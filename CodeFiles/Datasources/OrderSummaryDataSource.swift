//
//  OrderSummaryDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 5/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class OrderSummaryDataSource: TableViewDataSource {
    
    var orderSummary : OrderSummary?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count ?? 0) + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = getCellIdentifier(indexPath: indexPath) else{
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock {
            block(cell , indexPath.row == items?.count ? indexPath : items?[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? L10n.Items.string : nil
    }
    
    func getCellIdentifier(indexPath : IndexPath) -> String?{
        
        return indexPath.row == items?.count ? CellIdentifiers.OrderBillCell : CellIdentifiers.OrderSummaryCell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: Size.Medium.rawValue)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
