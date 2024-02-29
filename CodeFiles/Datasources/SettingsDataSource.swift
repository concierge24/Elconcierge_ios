//
//  SettingsDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 6/1/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

enum SettingsSection : Int {
    
    case ManageAddress = 0
    case Notifications
    case Other
    
    static var allValues:[SettingsSection] {
        
        if GDataSingleton.sharedInstance.loggedInUser?.fbId != nil {
            return [SettingsSection.Notifications]
        }
        //if SKAppType.type.isJNJ {
            return [SettingsSection.Notifications,SettingsSection.Other]
        //}
        // SettingsSection.ManageAddress, nitin
        return [SettingsSection.Notifications] // ,SettingsSection.Other
    }
    
    static func numberofSections() -> Int{
        return SettingsSection.allValues.count
    }
    
    func numberOfRowsInSection() -> Int{
        switch self {
        case .ManageAddress:
            return 1
        case .Notifications:
            if SKAppType.type.isJNJ {
                return 1
            }
            return 1
        case .Other:
            return (GDataSingleton.sharedInstance.loggedInUser?.fbId == nil && GDataSingleton.sharedInstance.loggedInUser?.appleId == nil) ? 1 : 0 //Nitin
        }
    }
    func titleForHEaderInSection() -> String{
        switch self {
        case .ManageAddress:
            return L10n.ManageAddress.string
        case .Notifications:
            return L10n.Notifications.string
        case .Other:
            return L10n.Other.string
        }
    }
    
    func identifier() -> String {
        switch self {
        case .ManageAddress:
            return CellIdentifiers.DeliveryAddressCell
        default:
            return CellIdentifiers.SettingsCell
        }
    }
    func heightForRow() -> CGFloat{
        switch self {
        case .ManageAddress:
            return 120//UITableView.automaticDimension
        default:
            return 48
        }
    }
}

typealias SettingsCellConfigureBlock = (_ cell : Any,_ section : SettingsSection,_ indexPath : IndexPath) -> ()
class SettingsDataSource: TableViewDataSource {

    var configureSettingsCellBlock : SettingsCellConfigureBlock?
    var scrollViewListener : ScrollViewScrolled?
    
    init(tableView : UITableView,configurecell : @escaping SettingsCellConfigureBlock,rowSelectedBlock : @escaping DidSelectedRow,scrollListener : @escaping ScrollViewScrolled) {
        super.init(items: nil, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: nil, configureCellBlock: nil, aRowSelectedListener: rowSelectedBlock)
        self.configureSettingsCellBlock = configurecell
        self.scrollViewListener = scrollListener
    }
    
    override init() {
         super.init()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.numberofSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row = SettingsSection.allValues[section]
        return row.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = SettingsSection.allValues[indexPath.section]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: row.identifier() , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureSettingsCellBlock {
            block(cell, row, indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = SettingsSection.allValues[indexPath.section]
        return row.heightForRow()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.darkGray
        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: 12)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let row = SettingsSection.allValues[section]
        return row.titleForHEaderInSection()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let block = scrollViewListener else { return }
        block(scrollView)
    }
}
