//
//  HeaderTableViewDataSource.swift
//  Buraq24
//
//  Created by MANINDER on 30/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class HeaderTableViewDataSource: TableViewDataSourceCab  {
    var configureHeaderBlock: ViewForHeaderInSectionCab?
    var headerHeight : [CGFloat]?
    var headerIdentifiers : [String]?
    var cellIndentifiers : [String]?
    var cellHeights : [CGFloat]?
    var  cellItems : [[Any?]]?
    var sectionCount : Int = 1
    
    
    init (cellItems : Array<Array<Any>> , tableView : UITableView? ,cellIdentifiers : Array<String>? , cellHeights : Array<CGFloat>? , headerIdentifiers : Array<String>?, sections : Int , headerHeight : [CGFloat]?) {
        super.init(items: nil, tableView: tableView, cellIdentifier: nil, cellHeight: 0)

        self.cellItems = cellItems
        self.cellIndentifiers = cellIdentifiers
        self.cellHeights = cellHeights
        self.headerIdentifiers = headerIdentifiers
        self.sectionCount = sections
        self.headerHeight = headerHeight
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = self.cellIndentifiers?[indexPath.section] else {
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = self.configureCellBlock ,  let sectionArray = self.cellItems?[indexPath.section] {
            if let item : Any = sectionArray[indexPath.row] {
                block(cell , item , indexPath)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return /cellHeights?[indexPath.section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return /cellItems?[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return /headerHeight?[section]
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let identifier = self.headerIdentifiers?[section] else {
            fatalError("Header identifier not provided")
        }
        if  let header  = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) {
            if let block = self.configureHeaderBlock{
                block(header, section)
            }
            return header
        }
        return nil
    }
}
