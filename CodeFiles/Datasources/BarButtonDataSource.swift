//
//  BarButtonDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 4/24/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class BarButtonDataSource: NSObject {
    
    var currentIndex = 0
    var currentSection = 0
    private var shouldUpdateButtonBarView = true
    var changeCurrentIndexProgressive: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    var changeCurrentIndex: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ animated: Bool) -> Void)?
    
    var buttonBarView : ButtonBarView?
    var tableView : UITableView?
    
    var items : Array<AnyObject>?
    
    lazy private var cachedCellWidths: [CGFloat]? = { [unowned self] in
        return self.calculateWidths()
        }()
    
    var selected : [Bool] = []
    
    init(items : Array<AnyObject> , barButtonView : ButtonBarView,tableView : UITableView?) {
        
        self.buttonBarView = barButtonView
        self.items = items
        self.tableView = tableView
        self.selected = Array(repeating: false, count: items.count)
        if selected.count > 0 {
            self.selected[0] = true
        }
    }
    
    
    override init() {
        
        super.init()
    }

    private func calculateWidths() -> [CGFloat] {
        guard let arr = items else { return [] }
        var minimumCellWidths = [CGFloat]()
        let label = UILabel(frame: CGRect.zero)
        
        for item in arr {
            label.text = (item as? DetailedSubCategories)?.strTitle ?? ""
            minimumCellWidths.append(label.intrinsicContentSize.width + LowPadding * 2)
        }
        return minimumCellWidths
    }
}

extension BarButtonDataSource : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
        guard indexPath.item != currentIndex else { return }
        
        buttonBarView?.moveToIndex(toIndex: indexPath.item, animated: true, swipeDirection: .None, pagerScroll: .Yes)
        shouldUpdateButtonBarView = false
        
        let oldCell = buttonBarView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as? ButtonBarViewCell
        let newCell = buttonBarView?.cellForItem(at: IndexPath(row: indexPath.item, section: 0)) as? ButtonBarViewCell
        
        if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
            changeCurrentIndexProgressive(oldCell, newCell, 1, true, true)
        }
            
        else {
            if let changeCurrentIndex = changeCurrentIndex {
                changeCurrentIndex(oldCell, newCell, true)
            }
        }
        
//        UtilityFunctions.delay(0.2) {
            weak var weakSelf : BarButtonDataSource? = self
        weakSelf?.tableView?.scrollToRow(at: IndexPath(row: 0,section: indexPath.item), at: .top, animated: true)
//        }
        
        
        self.selected = Array(repeating: false, count: items?.count ?? 0)
        selected[indexPath.row] = true
        buttonBarView?.reloadData()
        currentIndex = indexPath.item
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ButtonBarViewCell else {
            fatalError("UICollectionViewCell should be or extend from ButtonBarViewCell")
        }
        
        //cell.label.textColor = selected[indexPath.row] ? Colors.MainColor.color() : UIColor.black.withAlphaComponent(0.25)
        
         cell.label.textColor = selected[indexPath.row] ? LabelThemeColor.shared.lblSelectedTitleClr : UIColor.black.withAlphaComponent(0.25)
       
        cell.label.font = selected[indexPath.row] ?  UIFont(name: Fonts.ProximaNova.SemiBold, size: 16) : UIFont(name: Fonts.ProximaNova.Regular, size: 14)
        cell.label.text = (items?[indexPath.item] as? DetailedSubCategories)?.strTitle

        if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
            changeCurrentIndexProgressive(currentIndex == indexPath.item ? nil : cell, currentIndex == indexPath.item ? cell : nil, 1, true, false)
        }
            
        else {
            if let changeCurrentIndex = changeCurrentIndex {
                changeCurrentIndex(currentIndex == indexPath.item ? nil : cell, currentIndex == indexPath.item ? cell : nil, false)
            }
        }
        return cell
    } 
}


extension BarButtonDataSource  {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellWidthValue = cachedCellWidths?[indexPath.row] else {
            fatalError("cachedCellWidths for \(indexPath.row) must not be nil")
        }
        return CGSize(width : cellWidthValue, height : collectionView.frame.size.height)
    }
}
