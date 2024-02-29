//
//  SupplierInfoDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit


struct SupplierInfoRows {
    
    
    static func identifier(index : Int,selectedTab : SelectedTab?,supplier : Supplier?) -> String? {
        
        guard let selected = selectedTab else { return nil }
        let identifier : String
        if index > 1 {
            switch selected {
            case .Review:
                let count = supplier?.reviews?.count ?? 0
                identifier = count == 0 ? CellIdentifiers.SupplierDescriptionCell : CellIdentifiers.OtherReviewCell
                return identifier
            default:
                return  CellIdentifiers.SupplierDescriptionCell
            }
        }else{
            identifier = index == 0 ? CellIdentifiers.SupplierInfoCell : CellIdentifiers.SupplierInfoTabCell
            return identifier
        }
    }
    
    static func numberOfRows(supplier : Supplier? ,selectedTab : SelectedTab?) -> Int{
        guard let tab = selectedTab,let currentSupplier = supplier else { return 0 }
        switch tab {
        case .Review:
            let count = currentSupplier.reviews?.count ?? 0
            return count == 0 ? 3 : count + 2
        default :
            return 3
        }
    }
}



class SupplierInfoDataSource: TableViewDataSource {

    typealias ScrollViewScrolled = (UIScrollView) -> ()
    typealias ConfigureSupplierCellBlock = (_ cell : Any,_ indexPath : IndexPath,_ type : SelectedTab?) -> ()
    var scrollViewListener : ScrollViewScrolled?
    var configureSupplierCellBlock: ConfigureSupplierCellBlock?
    
    var selectedTab : SelectedTab = .About
    
    var supplier : Supplier?
    
    init(supplier: Supplier?, height: CGFloat, tableView: UITableView?, cellIdentifier: String?, configureCellBlock: @escaping ConfigureSupplierCellBlock, aRowSelectedListener: @escaping DidSelectedRow,scrollViewListener : @escaping ScrollViewScrolled) {
        super.init(items: [/supplier?.descriptionHTML], height: height, tableView: tableView, cellIdentifier: cellIdentifier, configureCellBlock : nil, aRowSelectedListener: aRowSelectedListener)
        self.supplier = supplier
        self.configureSupplierCellBlock = configureCellBlock
        self.scrollViewListener = scrollViewListener
    }
    
    override init() {
        super.init()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let block = scrollViewListener {
            block(scrollView)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SupplierInfoRows.numberOfRows(supplier: supplier, selectedTab: selectedTab)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = SupplierInfoRows.identifier(index: indexPath.row, selectedTab: selectedTab,supplier: supplier) else{
            fatalError()
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell( withIdentifier: identifier, for: indexPath) as UITableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = self.configureSupplierCellBlock{
            block(cell ,indexPath,selectedTab)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let identifier = SupplierInfoRows.identifier(index: indexPath.row, selectedTab: selectedTab,supplier: supplier) else{
            return UITableView.automaticDimension
        }
        if identifier == CellIdentifiers.SupplierDescriptionCell {
            switch selectedTab {
            case .About:
                return( supplier?.about?.trimmed().count ?? 0) > 0 ? UITableView.automaticDimension : 250
            case .Review:
                return supplier?.reviews?.count == 0 ? 250 : UITableView.automaticDimension
            case .Uniqueness:
                return ( supplier?.descriptionHTML?.trimmed().count ?? 0) > 0 ? UITableView.automaticDimension : 250
            }
            
        }else {
            return UITableView.automaticDimension
        }        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension SupplierInfoDataSource : SupplierInfoTabCellDelegate{
    
    
    func changeSupplierInfoTab(selectedTab: SelectedTab) {
        
        self.selectedTab = selectedTab
        defer{
            tableView?.reloadData()
        }
        switch selectedTab {
        case .Uniqueness:
            items = [supplier?.descriptionHTML ?? ""]
        case .Review:
            items = supplier?.reviews
        case .About:
            items = [supplier?.about ?? ""]
        }
    }
}
