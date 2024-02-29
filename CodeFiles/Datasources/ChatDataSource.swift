//
//  ChatDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 6/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class ChatDataSource: TableViewDataSource {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: getIdentifier(item: items?[indexPath.row]) ?? "" , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row]{
            block(cell , item)
        }
        return cell
    }
    
    func getIdentifier(item : Any?) -> String?{
        guard let message = item as? Message,let myMessage = message.myMessage else { return "" }
        
        return myMessage ? CellIdentifiers.LiveSupportMyCell : CellIdentifiers.LiveSupportOtherCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
