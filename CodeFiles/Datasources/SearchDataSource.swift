//
//  SearchDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 4/29/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class SearchDataSource: TableViewDataSource {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.section]{
            block(cell , item)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Text Color
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Colors.MainColor.color()
        header.textLabel?.text = [L10n.ResultsFor.string , "\"" , (items?[section] as? Search)?.title ,"\""].flatMap{ $0 }.joined(separator: "")
        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: Size.Medium.rawValue)
        header.contentView.backgroundColor = Colors.lightGrayBackgroundColor.color()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}
