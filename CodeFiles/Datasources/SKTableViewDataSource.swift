//
//  TableViewDataSource.swift
//  SafeCity
//
//  Created by Aseem 13 on 29/09/15.
//  Copyright (c) 2015 Taran. All rights reserved.
//


import UIKit

typealias SKBlock_ConfigCellBlock       = (_ indexpath: IndexPath, _ cell: Any?, _ item: Any?) -> ()
typealias SKBlock_DidSelectRow          = (_ indexPath: IndexPath , _ cell: Any?) -> ()
typealias SKBlock_WillDisplayCell       = (_ indexPath: IndexPath, _ cell: Any?) -> ()
typealias SKBlock_DidScroll             = (_ scrollView: UIScrollView) -> ()
typealias SKBlock_CellIdentifier        = (_ indexPath: IndexPath) -> String?
typealias SKBlock_HeightForRowAt        = (_ indexPath: IndexPath) -> (CGFloat)
typealias SKBlock_DidDeSelectRow        = (_ indexPath: IndexPath) -> ()
typealias SKBlock_CanEditRowAtIndexPath = (_ indexPath: IndexPath) -> (Bool)
typealias SKBlock_CommitEditingStyle    = (_ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> ()
typealias SKBlock_RefreshTableList      = () -> ()

class SKTableViewDataSource: NSObject  {
    
    var tableView : UITableView?
    private var refreshControl : UIRefreshControl?

    var items: [Any]? {
        didSet {
            endRefreshing()
        }
    }

    var cellIdentifier: String?
    var configureCellBlock          :       SKBlock_ConfigCellBlock?
    var aRowSelectedListener        :       SKBlock_DidSelectRow?
    var block_DidScroll             :       SKBlock_DidScroll?
    var block_WillDisplayCell       :       SKBlock_WillDisplayCell?
    var scrollDidEndDraging         :       SKBlock_DidScroll?
    var blockCellIdentifier         :       SKBlock_CellIdentifier?
    var block_HeightForRowAt        :       SKBlock_HeightForRowAt?
    var block_DidDeSelectRow        :       SKBlock_DidDeSelectRow?
    var canEditRow                  :       SKBlock_CanEditRowAtIndexPath?
    var block_CommitEditingStyle    :       SKBlock_CommitEditingStyle?
    
    //    var direction: DirectionForScroll?
    
    var cellHeight: CGFloat = UITableView.automaticDimension
    
    var refreshTable: SKBlock_RefreshTableList? {
        didSet {
            if refreshTable == nil {
                refreshControl = nil
                tableView?.refreshControl = nil
                return
            }
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
            tableView?.refreshControl = refreshControl
        }
    }
    
    init (items: [Any]? = [], tableView: UITableView?, cellIdentifier: String? = nil, cellHeight:CGFloat = UITableView.automaticDimension) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.tableView = tableView
        self.cellHeight = cellHeight
    }
    
    override init() {
        super.init()
    }
    
    func reloadTable(items: [Any]?) {
        self.items = items
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.reloadData()
    }
    
    @objc private func refreshTableData() {
        refreshTable?()
    }
    
    @objc func beginRefreshing() {
        refreshControl?.beginRefreshing()
    }
    
    @objc func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}

extension SKTableViewDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.items?[indexPath.row]

        var identifierCell = self.blockCellIdentifier?(indexPath)
        
        if identifierCell == nil {
            identifierCell = cellIdentifier
        }
        
        guard let identifier = identifierCell else {
            fatalError("Cell identifier not provided")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            fatalError("Cell not provided")
        }

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = self.configureCellBlock {
            block(indexPath, cell, item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = self.aRowSelectedListener,
            case let cell as Any = tableView.cellForRow(at: indexPath) {
            block(indexPath , cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.items?.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.block_HeightForRowAt?(indexPath)) ?? cellHeight
    }   
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let block = block_WillDisplayCell {
            block(indexPath, cell)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let block = block_DidScroll {
            block(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let block = scrollDidEndDraging {
            block(scrollView)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let block = block_DidDeSelectRow {
            block(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let block = canEditRow {
           return block(indexPath)
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let block = block_CommitEditingStyle {
            block(editingStyle, indexPath)
        }
    }
}

//MARK:- ======== Extension UITableView ========
extension UITableView {
    
    func registerCells(nibNames:[String]) {
        nibNames.forEach({
            [weak self] in
            let nib = UINib(nibName: $0, bundle: nil)
            self?.register(nib, forCellReuseIdentifier: $0)
        })
    }
}

//MARK:- ======== Extension UICollectionView ========
extension UICollectionView {
    
    func registerCells(nibNames:[String]) {
        nibNames.forEach({
            [weak self] in
            let nib = UINib(nibName: $0, bundle: nil)
            self?.register(nib, forCellWithReuseIdentifier: $0)
        })
    }
}
