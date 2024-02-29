//
//  ItemListingDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 4/24/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class ItemListingDataSource: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    typealias ChangeSectionBlock = (_ section : Int) -> ()
    var items : Array<Any>?
    var tableView : UITableView?
    var buttonBarView : ButtonBarView?
    var aRowSelectedListener : DidSelectedRow?
    var currentIndex = 0
    var currentSection = 0
    var changeSectionListener : ChangeSectionBlock?
    var configureCellBlock : ListCellConfigureBlock?
    var isFromFilter : Bool = false
    
    init(items : Array<Any>?, tableView : UITableView,buttonBarView : ButtonBarView? , aRowSelectedListener : DidSelectedRow?) {
        super.init()
        self.items = items
        self.tableView = tableView
        self.buttonBarView = buttonBarView
        self.aRowSelectedListener = aRowSelectedListener
        tableView.register(UINib(nibName: CellIdentifiers.ProductListingCell,bundle: nil), forCellReuseIdentifier: CellIdentifiers.ProductListingCell)
        
    }
    override init() {
        super.init()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFromFilter == false ? items?.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFromFilter == false ? (items?[section] as? DetailedSubCategories)?.arrProducts?.count ?? 0 : items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ProductListingCell) as? ProductListingCell else { fatalError() }
        cell.product = isFromFilter == false ?  (items?[indexPath.section] as? DetailedSubCategories)?.arrProducts?[indexPath.row] : items?[indexPath.row] as? ProductF 
        cell.selectionStyle = .none
        cell.productClicked = { [weak self] product in
            guard let block = self?.aRowSelectedListener else{
                return
            }
            block(indexPath)
        }
        
        if let block = configureCellBlock  {
            block(cell, indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (items?[section] as? DetailedSubCategories)?.strTitle
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let cell = tableView?.visibleCells.first else { return }
        
        if let section = tableView?.indexPath(for: cell)?.section , let isDraging = tableView?.isDragging, isDraging{
            if section != currentSection {
                buttonBarView?.moveToIndex(toIndex: section, animated: true, swipeDirection: SwipeDirection.Left, pagerScroll: PagerScroll.ScrollOnlyIfOutOfScreen)
                currentSection = section
                
                guard let block = changeSectionListener else { return }
                block(section)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}

extension ItemListingDataSource {
    func reloadTable(items: [Any]?) {
        self.items = items
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.reloadData()
    }
}
