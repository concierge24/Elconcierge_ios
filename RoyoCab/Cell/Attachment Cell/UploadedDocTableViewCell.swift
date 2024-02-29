//
//  UploadedDocTableViewCell.swift
//  Buraq24Driver
//
//  Created by Apple on 07/11/19.
//  Copyright © 2019 OSX. All rights reserved.
//

import UIKit
protocol UploadedDocTableViewCellDelegate:class {
    func deleteDoc(indexPath:IndexPath)
}

class UploadedDocTableViewCell: UITableViewCell {

    
    weak var delegate:UploadedDocTableViewCellDelegate?

    @IBOutlet weak var uploadedImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var deleteButton: CustomButton!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        fileNameLabel.setTextColorTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func deleteAction(_ sender: CustomButton) {
        self.delegate?.deleteDoc(indexPath: IndexPath(row: sender.row ?? 0, section: sender.section ?? 0))
    }
    
}

class CustomButton : UIButton {
    var row:Int?
    var section:Int?
}
