//
//  SKTableViewDataSourceWithHeader.swift
//  Sneni
//
//  Created by Sandeep Kumar on 16/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

typealias SKBlock_Table_HeightFoHeaderInSection = (_ section: Int, _ sectionObj: TableViewHeaderObjectType) -> CGFloat?
typealias SKBlock_Table_ViewForHeaderInSection = (_ section: Int, _ sectionObj: TableViewHeaderObjectType) -> UIView?

//MARK:- ======== TableViewDataSourceWithHeader ========
class SKTableViewDataSourceWithHeader: SKTableViewDataSource {
    
    var viewforHeaderInSection: SKBlock_Table_ViewForHeaderInSection?
    var viewForFooterInSection: SKBlock_Table_ViewForHeaderInSection?
    
    var headerHeight: CGFloat = 0.0
    var headerFooter: CGFloat = 0.0
    
    var heightForHeaderInSection: SKBlock_Table_HeightFoHeaderInSection?
    var heightForFooterInSection: SKBlock_Table_HeightFoHeaderInSection?
    
    override init() {
        super.init()
    }
    
    required init(items: [Any] = [],
                  tableView: UITableView?,
                  cellIdentifier: String? = nil,
                  cellHeight: CGFloat = UITableView.automaticDimension,
                  headerHeight:CGFloat = 0.0,
                  headerFooter:CGFloat = 0.0) {
        
        self.headerHeight = headerHeight
        self.headerFooter = headerFooter
        
        super.init(items: items, tableView: tableView, cellIdentifier: cellIdentifier, cellHeight: cellHeight)
    }
    
    ///Indexing
    override func numberOfSections(in tableView: UITableView) -> Int {
        return /items?.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemSection = self.items?[section] as? TableViewHeaderObjectType {
            return itemSection.rows.count
        }
        
        
        return 0
    }
    
    ///cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifierCell = self.blockCellIdentifier?(indexPath)
        
        if identifierCell == nil {
            identifierCell = cellIdentifier
        }
        
        guard let identifier = identifierCell else {
            fatalError("Cell identifier not provided")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            fatalError("Cell is not register")
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = self.configureCellBlock,
            let itemSection = self.items?[indexPath.section] as? TableViewHeaderObjectType {
            let item = itemSection.rows[indexPath.row]
            block(indexPath, cell, item)
        }
        return cell
    }
    
    ///viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
            let viewH = viewforHeaderInSection?(section, itemSection) else { return nil }
        return viewH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
            let height = heightForHeaderInSection?(section, itemSection) else { return headerHeight }
        return height
    }
    
    ///viewForFooterInSection
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
            let viewH = viewForFooterInSection?(section, itemSection) else { return nil }
        return viewH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
            let height = heightForFooterInSection?(section, itemSection) else { return headerFooter }
        return height
    }
}
