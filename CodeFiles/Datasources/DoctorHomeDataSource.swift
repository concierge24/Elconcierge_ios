//
//  DoctorHomeDataSource.swift
//  Clikat
//
//  Created by Night Reaper on 19/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

enum DoctorHomeScreenSection : Int {
    
    case Categories = 0
    case Banners
    case ProductList

    
    static var allValues: [DoctorHomeScreenSection] {

        var tempArray = [DoctorHomeScreenSection]()
        
        //Add categories
        if let categories = GDataSingleton.sharedInstance.doctorCategories, !categories.isEmpty {
            tempArray.append(.Categories)
        }
        
        //Add top deals
        let count = GDataSingleton.sharedInstance.getOfferByCategory?.count ?? 0
        if count > 0 {
            for _ in 0...count-1 {
                tempArray.append(.ProductList)
            }
        }
        //Add one row to show suppliers
        if let suppliers = GDataSingleton.sharedInstance.doctorHomeProviders, !suppliers.isEmpty {
            tempArray.append(.ProductList)
        }
        return tempArray
        return []//[.Banners]
    }
    
    static let registerCells = [
        HomeSkeletonCell.identifier
    ]

    func identifier(isLast: Bool) -> String {
        switch self {
        case .Banners :
            return CellIdentifiers.BannerParentCell

        case .Categories:
            return DoctorCategoryParentCell.identifier
            
        default:
            return DoctorHomeParentCell.identifier
        }
    }
    
    func rowHeight() -> CGFloat {

        switch self {
        default:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfRowsInSection(section :Int?) -> Int {
        
        switch self {

        case .ProductList, .Categories:
            return 1

        default :
            return 0
        }
        
    }
}

class DoctorHomeDataSource: NSObject {
    
    typealias  HomeListCellConfigureBlock = (_ indexPath : IndexPath ,_ cell : Any , _ item : Any , _ type : DoctorHomeScreenSection) -> ()
    typealias  HomeDidSelectedRow = (_ indexPath : IndexPath ,_ type : DoctorHomeScreenSection) -> ()
    var tableView  : UITableView?
    var configureCellBlock : HomeListCellConfigureBlock?
    var aRowSelectedListener : HomeDidSelectedRow?
    
//    var sectionHeader : HomeSectionHeader?
    
    init (tableView : UITableView? , configureCellBlock : @escaping HomeListCellConfigureBlock , aRowSelectedListener : @escaping HomeDidSelectedRow) {
        
        tableView?.registerCells(nibNames: DoctorHomeScreenSection.registerCells)
        
        self.tableView = tableView
        self.configureCellBlock = configureCellBlock
        self.aRowSelectedListener = aRowSelectedListener
    }
    
    override init(){
        super.init()
    }
}

extension DoctorHomeDataSource : UITableViewDelegate , SkeletonTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DoctorHomeScreenSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= DoctorHomeScreenSection.allValues.count {return 0}
        let sectionCase = DoctorHomeScreenSection.allValues[section]
        return sectionCase.numberOfRowsInSection(section: section)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section >= DoctorHomeScreenSection.allValues.count {return 0}
        let sectionCase = DoctorHomeScreenSection.allValues[indexPath.section]
        let height = sectionCase.rowHeight()
        return (DoctorHomeScreenSection.allValues.count ==  0) ? 0: height
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FlickeringHomeTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section >= DoctorHomeScreenSection.allValues.count {return UITableViewCell()}
        let sectionCase = DoctorHomeScreenSection.allValues[indexPath.section]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: sectionCase.identifier(isLast: false), for: indexPath as IndexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = configureCellBlock {
            block(indexPath,cell, "", sectionCase)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = aRowSelectedListener {
            let sectionCase = DoctorHomeScreenSection.allValues[indexPath.section]
            block(indexPath, sectionCase)
        }
    }
}
