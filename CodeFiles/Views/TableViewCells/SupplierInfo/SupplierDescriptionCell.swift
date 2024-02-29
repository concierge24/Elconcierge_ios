//
//  SupplierDescriptionCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/4/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class SupplierDescriptionCell: ThemeTableCell {

    @IBOutlet weak var lblDisc: UILabel? {
        didSet {
            if SKAppType.type == .home {
                lblDisc?.text = "Service Description".localized()
            }
            else {
                lblDisc?.text = "Product Description".localized()
            }
            lblDisc?.textColor = SKAppType.type.color
        }
    }
    
    @IBOutlet weak var textView: ThemeTextView!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet var lblPlaceholder: UILabel!{
        didSet{
            lblPlaceholder.kern(kerningValue: ButtonKernValue)
        }
    }
    
    var htmlString : String?{
        didSet{
//            if (/htmlString).contains("<div", compareOption: .caseInsensitive) || (/htmlString).contains("<html", compareOption: .caseInsensitive) {
//                guard let htmlStr = htmlString,let data = htmlStr.data(using: String.Encoding.utf8) else { return }
//                do {
//                    let attributedString = try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],documentAttributes: nil)
//
//                   /*theme*/
//                   textView?.attributedText = attributedString.color(LabelThemeColor.shared.lblSubTitleClr)
//
//                } catch {
//
//                }
//            }
//            else {
//                textView?.text = htmlString
//            }
            textView?.attributedText = htmlString?.htmlToAttributedString(textView: textView)
            viewPlaceholder?.isHidden = htmlString?.trim().count == 0 ? false : true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
