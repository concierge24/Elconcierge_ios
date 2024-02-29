//
//  UIExpandableTableView.swift
//  LabelTeste
//
//  Created by Rondinelli Morais on 11/09/15.
//  Copyright (c) 2015 Rondinelli Morais. All rights reserved.
//

import UIKit

class UIExpandableTableView : UITableView, HeaderViewDelegate {
    
    var sectionOpen:Int = NSNotFound
    
    // MARK: HeaderViewDelegate
    func headerViewOpen(section: Int) {
        
        if self.sectionOpen != NSNotFound {
            headerViewClose(section: self.sectionOpen)
        }
        
        self.sectionOpen = section
        let numberOfRows = self.dataSource?.tableView(self, numberOfRowsInSection: section)
        var indexesPathToInsert:[IndexPath] = []

        let rows = numberOfRows ?? 0
        
        for i in 0..<rows{
            indexesPathToInsert.append(IndexPath(row: i, section: section))
        }
        
        if indexesPathToInsert.count > 0 {
            self.beginUpdates()
            self.insertRows(at: indexesPathToInsert, with: .automatic)
            self.endUpdates()
        }
    }
    
    func headerViewClose(section: Int) {
        
        let numberOfRows = self.dataSource?.tableView(self, numberOfRowsInSection: section)
        var indexesPathToDelete:[IndexPath] = []
        self.sectionOpen = NSNotFound
        
        let rows = numberOfRows ?? 0
        
        for i in 0..<rows{
            indexesPathToDelete.append(IndexPath(row: i, section: section))
        }

        if indexesPathToDelete.count > 0 {
            self.beginUpdates()
            self.deleteRows(at: indexesPathToDelete, with: .top)
            self.endUpdates()
        }
    }
}
