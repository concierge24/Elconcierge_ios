//
//  LocationDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 8/11/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LocationDataSource: TableViewDataSource {

    var myLocations : Array<Any>?
    
    override init(){
        super.init()
    }
    
    init (items : Array<Any>?,myLocations : Array<AnyObject>? , height : CGFloat , tableView : UITableView? , cellIdentifier : String?  , configureCellBlock : ListCellConfigureBlock? , aRowSelectedListener : @escaping DidSelectedRow) {
        self.myLocations = myLocations
        super.init(items: items, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: cellIdentifier, configureCellBlock: configureCellBlock, aRowSelectedListener: aRowSelectedListener)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let location = myLocations, location.count > 0 else { return 1 }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let location = myLocations, location.count > 0 else { return items?.count ?? 0 }
        
        return section == 0 ? location.count : items?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let location = myLocations, location.count > 0 else { return nil }
        
        return section == 0 ? L10n.MyAddresses.string : L10n.Area.string
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let location = myLocations, location.count > 0 else { return 0 }
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
     
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: 14)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock {
            block(cell , indexPath as AnyObject)
        }
        return cell
    }
}
