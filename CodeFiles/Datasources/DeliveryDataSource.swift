//
//  DeliveryDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 5/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

enum DeliverySpeedType : Int {
    case Standard = 0
    case Urgent
    case Postpone
    case scheduled
    static let allValues = [DeliverySpeedType.Standard,DeliverySpeedType.Urgent,DeliverySpeedType.Postpone]
    
    var valueAPi:String {
        
        switch self {
        case .scheduled :
            return "0"
            
        default:
            return "\(rawValue)"
            
        }
    }
    
}

enum DeliveryRow : Int {
    
    case DeliveryAddressCell = 0
    case DeliverySpeedCell
    case TimeAndDateCell
    
    
    static let allValues = [DeliveryRow.DeliveryAddressCell, DeliveryRow.DeliverySpeedCell,DeliveryRow.TimeAndDateCell]
    
    func identifier(selectedDeliverySpeed : DeliverySpeedType,indexPath : IndexPath,delivery : Delivery?) -> String {
        switch self {
        case .DeliveryAddressCell :
            return CellIdentifiers.DeliveryAddressCell
        case .DeliverySpeedCell :
            if (selectedDeliverySpeed == .Standard){ return CellIdentifiers.DeliverySpeedCell }else {
                return indexPath.row == (delivery?.deliverySpeeds?.count ?? 0) ? CellIdentifiers.TimeAndDateCell : CellIdentifiers.DeliverySpeedCell
            }
        default: return ""
        }
        
    }
    
    func rowHeight() -> CGFloat {
        switch self {
        case .DeliverySpeedCell :
            return 72
        default:
            break
        }
        return UITableView.automaticDimension
    }
    
    static func numberOfSection() -> Int {
        return 2
    }
    
    func numberOfRowsInSection(selectedDeliverySpeed : DeliverySpeedType,delivery : Delivery?) -> Int{
        
        switch self {
        case .DeliveryAddressCell:
            //Nitin return 1
            return 0
        case .DeliverySpeedCell :
            return (selectedDeliverySpeed == .Standard || selectedDeliverySpeed == .Urgent) ? delivery?.deliverySpeeds?.count ?? 0 : (delivery?.deliverySpeeds?.count ?? 0) + 1
        default:
            break
        }
        return 0
    }
    
    func titleForHeaderInSection() -> String {
        switch self {
        case .DeliveryAddressCell:
            return ""
            //return L10n.DeliveryAddress.string
        case .DeliverySpeedCell :
            return L10n.DeliverySpeed.string
        default:
            break
        }
        return ""
    }
}

typealias DeliveryCellConfigureBlock = (_ cell : Any , _ indexPath : IndexPath?, _ selectedDeliverySpeed : DeliverySpeedType?) -> ()

class DeliveryDataSource: TableViewDataSource {
    
    var configureDeliveryCellBlock : DeliveryCellConfigureBlock?
    
    var deliveryDetails : Delivery?
    var selectedDeliverySpeed : DeliverySpeedType = .Standard
    
    var loyaltyPointsSummary : LoyaltyPointsSummary?
    
    init(items: Delivery?, height: CGFloat, tableView: UITableView?, cellIdentifier: String?, configureCellBlock: DeliveryCellConfigureBlock?, aRowSelectedListener: @escaping DidSelectedRow) {
        super.init(items: items?.deliverySpeeds, height: height, tableView: tableView, cellIdentifier: cellIdentifier, configureCellBlock: nil, aRowSelectedListener: aRowSelectedListener)
        self.deliveryDetails = items
        self.configureDeliveryCellBlock = configureCellBlock
    }
    
    override init() {
        super.init()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return loyaltyPointsSummary == nil ? DeliveryRow.numberOfSection() : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = DeliveryRow.allValues[section]
        return rows.numberOfRowsInSection(selectedDeliverySpeed: selectedDeliverySpeed,delivery: deliveryDetails)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = DeliveryRow.allValues[indexPath.section]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: row.identifier(selectedDeliverySpeed: selectedDeliverySpeed,indexPath: indexPath,delivery: deliveryDetails) , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureDeliveryCellBlock{
            block(cell, indexPath, selectedDeliverySpeed)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rows = DeliveryRow.allValues[indexPath.section]
        return rows.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let row = DeliveryRow.allValues[section]
        return row.titleForHeaderInSection()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: 12)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}
