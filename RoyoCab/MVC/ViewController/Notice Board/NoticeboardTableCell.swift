//
//  NoticeboardTableCell.swift
//  TravaDriver
//
//  Created by Apple on 20/02/20.
//  Copyright © 2020 OSX. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationModel: NSObject, Mappable {
    var message:String?
    var data : [NotificationData]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data <- map ["result"]
        message <- map["msg"]
    }
}

class NotificationData: NSObject, Mappable {
    var message:String?
    var createdAt : String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        createdAt <- map ["created_at"]
        message <- map["message"]
    }
}


class NoticeboardTableCell: UITableViewCell {
    
    //MARK:-IBOutlets.
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lblHead: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
