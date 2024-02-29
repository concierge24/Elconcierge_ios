//
//  PickupDetailsDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 5/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

typealias PickupDetailCellConfigureBlock = (_ cell : Any, _ indexPath : IndexPath?) -> ()

class PickupDetailsDataSource: TableViewDataSource {
    
    var pickupDetails : PickupDetails?
    
    var configurepickupCellBlock : PickupDetailCellConfigureBlock?
    
    init(pickUpDetails: PickupDetails?, height: CGFloat, tableView: UITableView?, cellIdentifier: String?, configureCellBlock: PickupDetailCellConfigureBlock?, aRowSelectedListener: @escaping DidSelectedRow) {
        super.init(items: nil, height: height, tableView: tableView, cellIdentifier: cellIdentifier, configureCellBlock: nil, aRowSelectedListener: aRowSelectedListener)
        self.pickupDetails = pickUpDetails
        self.configurepickupCellBlock = configureCellBlock
    }
    
    override init() {
        super.init()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: indexPath.section != 0 ? CellIdentifiers.PickupDateCell : CellIdentifiers.DeliveryAddressCell , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configurepickupCellBlock {
            block(cell ,indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
     
        guard let header = view as? UITableViewHeaderFooterView else { return }
        print(view.frame.height)
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: 12)
        header.textLabel?.text = " " + (section != 0 ? L10n.WhenDoYouWantTheService.string : L10n.PickupLocation.string)
        header.backgroundColor = .red
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section != 0 ? 72 : 170.0//ScreenSize.SCREEN_WIDTH * 0.5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}
