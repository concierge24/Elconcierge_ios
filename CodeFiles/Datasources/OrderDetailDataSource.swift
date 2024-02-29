//
//  OrderDetailDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 5/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class OrderDetailDataSource: TableViewDataSource {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(indexPath: indexPath) ?? "", for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = self.items, let data: Any = self.data{
            block(cell , (item,data))
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return tableViewRowHeight
    }
    
    func tableView(_tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : L10n.OrderDetails.string
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Text Color
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = Colors.lightGrayBackgroundColor.color()
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.Regular , size: Size.Medium.rawValue)
    }
    
    func getCellIdentifier(indexPath : IndexPath) -> String?{
        return indexPath.section == 0 ? CellIdentifiers.OrderStatusCell : CellIdentifiers.OrderDetailCell
    }
}
