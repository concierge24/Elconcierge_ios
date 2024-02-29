//
//  ProductDetailDataSource.swift
//  Clikat
//
//  Created by cbl73 on 5/6/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit

enum ProductDetailRow : Int {
    
    case FirstInfoCell = 0
    case NutritionalContentCell
    
    
    static let allValues = [ProductDetailRow.FirstInfoCell, ProductDetailRow.NutritionalContentCell]
    
    
    
    func identifier() -> String {
        switch self {
        case .FirstInfoCell :
            return CellIdentifiers.ProductDetailFirstCell
        case .NutritionalContentCell :
            return CellIdentifiers.SupplierDescriptionCell
        }
        
    }
    
    func rowHeight(witHome home : Home?) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfRowsInSection() -> Int {
        return 2
    }
}

typealias ScrollViewScrolled = (UIScrollView) -> ()

class ProductDetailDataSource : TableViewDataSource {
    
    typealias ConfigureProductCellBlock = (_ cell : Any,_ indexPath : IndexPath) -> ()
    var scrollViewListener : ScrollViewScrolled?
    var configureSupplierCellBlock: ConfigureProductCellBlock?
    
    
    var product : ProductF?
    
    init(product: ProductF?, height: CGFloat, tableView: UITableView?, cellIdentifier: String?, configureCellBlock: @escaping ConfigureProductCellBlock, aRowSelectedListener: @escaping DidSelectedRow,scrollViewListener : @escaping ScrollViewScrolled) {
        super.init(items: [], height: height, tableView: tableView, cellIdentifier: cellIdentifier, configureCellBlock : nil, aRowSelectedListener: aRowSelectedListener)
        self.product = product
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
        return ProductDetailRow.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row =  ProductDetailRow.allValues[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: row.identifier() , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureSupplierCellBlock{
            block(cell ,indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    
}
