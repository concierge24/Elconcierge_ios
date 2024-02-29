//
//  FilterSliderCell.swift
//  Clikat
//
//  Created by cblmacmini on 7/12/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
typealias SliderValueChangedBlock = (_ value : Float,_ state : Filter) -> ()

class FilterSliderCell: ThemeTableCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var value: UILabel!
    
    var sliderValueChangedBlock : SliderValueChangedBlock?
    
    var selectedPath : [[Int]]?{
        didSet{
//            switch currentState {
//            case .MinDeliveryTime:
//                slider.value = selectedPath?[5][0].toFloat ?? 0
//                labelTitle.text = L10n.MinDeliveryTime.string
//            case .MinOrderAmount:
//                slider.value = selectedPath?[4][0].toFloat ?? 0
//                labelTitle.text = L10n.MinOrderAmount.string
//            default:
//                break
//            }
            
//            let sliderInt = Int(slider.value)
//            value.text = currentState == .MinOrderAmount ? L10n.AED.string + sliderInt.toString :  sliderInt.toString + " " + L10n.Days.string
        }
    }
    
    
    
    
    var currentState : Filter = .Discoverability{
        didSet{
//            slider.minimumValue = 0
//            if currentState == .MinOrderAmount {
//                slider.maximumValue = 10000
//            }else {
//                slider.maximumValue = 30
//            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sliderChanged(sender: UISlider) {
    
//        if currentState == .MinOrderAmount {
//            value.text = L10n.AED.string + Int(sender.value).toString
//        }else {
//            value.text = Int(sender.value).toString + " " + L10n.Days.string
//        }
//        guard let block = sliderValueChangedBlock else { return }
//        block(value: sender.value, state: currentState)
    }
}
