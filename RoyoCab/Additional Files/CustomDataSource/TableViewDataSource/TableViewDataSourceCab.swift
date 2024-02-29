//
//  TableViewDataSource.swift
//  SafeCity
//
//  Created by Aseem 13 on 29/09/15.
//  Copyright (c) 2015 Taran. All rights reserved.
//


import UIKit

typealias  ListCellConfigureBlockCab = (_ cell: Any , _ item: Any? , _ indexpath: IndexPath) -> ()
typealias  DidSelectedRowCab = (_ indexPath: IndexPath , _ cell: Any , _ item : Any?) -> ()
typealias  DidCellIndexInCenter = (_ indexPath: IndexPath) -> ()

typealias  ViewForHeaderInSectionCab = (_ headerView: UITableViewHeaderFooterView , _ section : Int) -> ()
typealias  ViewForFooterInSection = (_ section: Int) -> UIView?
typealias  WillDisplayCell = (_ indexPath: IndexPath,_ cell:UITableViewCell) -> ()

typealias  ScrollViewScroll = (_ scrollView: UIScrollView) -> ()
typealias Identifier = (_ identy: IndexPath?) ->(String?)

class TableViewDataSourceCab: NSObject  {
    var items: Array<Any>?
    var cellIdentifier: String?
    var tableView : UITableView?
    var configureCellBlock: ListCellConfigureBlockCab?
    var aRowSelectedListener: DidSelectedRowCab?
    var scrollViewScroll:  ScrollViewScroll?
    var willDisplayCell:WillDisplayCell?
    var cellHeight: CGFloat?
    var identifier1: Identifier?
    
    init (items: Array<Any>? , tableView: UITableView? , cellIdentifier: String?, cellHeight:CGFloat? ) {
        self.tableView = tableView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellHeight = cellHeight
        
    }
    
    
    override init() {
        super.init()
    }
}

extension TableViewDataSourceCab: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let identifier = cellIdentifier else {
//            fatalError("Cell identifier not provided")
//        }
        
        let ident = self.identifier1?(indexPath)
        
        
        let identifier = (ident != nil) ? /ident : /cellIdentifier
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row] { 
            block(cell , item , indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let block = self.aRowSelectedListener, let item: Any = self.items?[indexPath.row], case let cell as Any = tableView.cellForRow(at: indexPath) {
            
            block(indexPath , cell , item)

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return   /cellHeight
    }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if let block = willDisplayCell{
      block(indexPath,cell)
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.scrollViewScroll?(scrollView)
  }
    


}
