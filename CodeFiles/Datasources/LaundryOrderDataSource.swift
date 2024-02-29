//
//  LaundryOrderDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 6/10/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

enum LaundryOrderSection {
    
    
    static func numberOfSections(laundryOrder : LaundryProductListing?) -> Int{
        return (laundryOrder?.arrDetailedSubCategories?.count ?? 1) + 2
    }
    
    static func  numberOfRowsInSection(laundryOrder : LaundryProductListing?,section : Int) -> Int?{
        switch section {
        case 0, LaundryOrderSection.numberOfSections(laundryOrder: laundryOrder) - 1:
            return 1
        case 1...LaundryOrderSection.numberOfSections(laundryOrder: laundryOrder) - 2  :
            return laundryOrder?.arrDetailedSubCategories?[section - 1].arrProducts?.count
        default:
            return 0
        }
    }
    
    static func getIdentifier(laundryOrder : LaundryProductListing?,section : Int) -> String?{
        switch section {
        case 0 :
            return CellIdentifiers.LaundrySupplierInfoCell
        case 0...LaundryOrderSection.numberOfSections(laundryOrder: laundryOrder) - 2 :
            return CellIdentifiers.LaundryProductCell
        case LaundryOrderSection.numberOfSections(laundryOrder: laundryOrder) - 1:
            return CellIdentifiers.LaundryBillCell
        default:
            return ""
        }
    }
    
    static func titleForHeaderInSection(section : Int,laundryOrder : LaundryProductListing?) -> String?{
        if laundryOrder?.arrDetailedSubCategories?.count == 0 { return nil }
        switch section {
        case 1...LaundryOrderSection.numberOfSections(laundryOrder: laundryOrder) - 2 :
            return laundryOrder?.arrDetailedSubCategories?[section - 1].strTitle
        default:
            return nil
        }
    }
}

class LaundryOrderDataSource: TableViewDataSource {

    var laundryOrder : LaundryProductListing?
    var buttonBarView : ButtonBarView?
    var currentIndex = 0
    var currentSection = 0
    
    init(laundryOrder : LaundryProductListing?, tableView : UITableView,configureCellBlock : ListCellConfigureBlock?,aRowSelectedListener : @escaping DidSelectedRow) {
        super.init(items: nil, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: nil, configureCellBlock: configureCellBlock, aRowSelectedListener: aRowSelectedListener)
        self.laundryOrder = laundryOrder
    }
    override init() {
        super.init()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return laundryOrder?.arrDetailedSubCategories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (laundryOrder?.arrDetailedSubCategories?.count ?? 0 ) <= 0 { return 0 }
        return laundryOrder?.arrDetailedSubCategories?[section].arrProducts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let identifier = CellIdentifiers.LaundryProductCell
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock{
            block(cell , indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return LaundryOrderSection.titleForHeaderInSection(section, laundryOrder: laundryOrder)
//    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let title = LaundryOrderSection.titleForHeaderInSection(section, laundryOrder: laundryOrder) else { return nil }
//        
//        let view = LaundrySectionHeader(frame: CGRect(x: 0, y: 0, w: ScreenSize.SCREEN_WIDTH, h: 40))
//        view.labelDetailSubCategory.text = title
//        return view
//    }
//    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else { return }
//        header.contentView.backgroundColor = UIColor.whiteColor()
//        header.textLabel?.textColor = UIColor.lightGrayColor()
//        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: 12)
//    }
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 0 : 40
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let cell = tableView?.visibleCells.first else { return }
        
        if let section = tableView?.indexPath(for: cell)?.section , let isDraging = tableView?.isDragging, isDraging{
            if section != currentSection {
                buttonBarView?.moveToIndex(toIndex: section, animated: true, swipeDirection: SwipeDirection.Left, pagerScroll: PagerScroll.ScrollOnlyIfOutOfScreen)
                currentSection = section
            }
        }
    }
    
}
