//
//  TableViewDataSource.swift
//  Realm
//
//  Created by Night Reaper on 29/09/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//


import UIKit
import SkeletonView

typealias ListCellConfigureBlock = (_ cell : Any , _ item : Any?) -> ()
typealias DidSelectedRow = (_ indexPath : IndexPath) -> ()
typealias ViewForHeaderInSection = (_ section : Int) -> UIView?
typealias BlockSizeForCollectionCell = (_ index : IndexPath) -> CGSize
typealias SwipeToDelete = (_ indexPath : IndexPath) -> ()

class TableViewDataSource: NSObject , UITableViewDelegate , UITableViewDataSource {
    
    var data : Any?
    var items : Array<Any>?
    var cellIdentifier : String?
    var tableView  : UITableView?
    var tableViewRowHeight : CGFloat = 44.0
    
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var viewforHeaderInSection : ViewForHeaderInSection?
    var headerHeight : CGFloat?
    var swipeToDeleteBlock :  SwipeToDelete?
    
    init (items : Array<Any>? , data : Any? = nil, height : CGFloat , tableView : UITableView? , cellIdentifier : String?  , configureCellBlock : ListCellConfigureBlock? , aRowSelectedListener : @escaping DidSelectedRow,aRowSwipeListner: SwipeToDelete? = nil) {
        
        self.tableView = tableView
        self.items = items
        self.data = data
        self.cellIdentifier = cellIdentifier
        self.tableViewRowHeight = height
        self.configureCellBlock = configureCellBlock
        self.aRowSelectedListener = aRowSelectedListener
        self.swipeToDeleteBlock = aRowSwipeListner

    }
    
    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.tag = indexPath.row
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row]{
            block(cell , item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = self.aRowSelectedListener{
            block(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return HomeSkeletonCell.identifier
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let block = viewforHeaderInSection else { return nil }
        return block(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight ?? 0.0
    }
    
}
