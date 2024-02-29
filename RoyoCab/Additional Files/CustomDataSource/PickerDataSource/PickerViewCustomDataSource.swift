//
//  PickerViewCustomDataSource.swift
//  Grintafy
//
//  Created by Sierra 4 on 20/07/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import Foundation
import UIKit

typealias  SelectedRowBlock = (_ selectedRow: Int , _ item: Any) -> ()
typealias  titleForrow = (_ row: Int , _ item: Any) -> String
class PickerViewCustomDataSource: NSObject{
    
    var picker: UIPickerView?
    var pickerData:[Any]?
    var aSelectedBlock: SelectedRowBlock?
    var titleForRow: titleForrow?
    var columns: Int?
    let toolBar = UIToolbar()
    var textField: UITextField?
    
    init(picker: UIPickerView? , items: [Any]?, columns: Int? , aSelectedStringBlock: SelectedRowBlock?, textFieldForInputView: UITextField?) {
        
        super.init()
        
        self.picker = picker
        self.pickerData = items
        self.aSelectedBlock = aSelectedStringBlock
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.columns = columns
        self.textField = textFieldForInputView
//        self.textField?.delegate = self
    }
    
    override init() {
        super.init()
    }
    
    //MARK:- ======== Functions ========
    func reload(items: [Any]?) {
        
        self.pickerData = items ?? []
        
        picker?.dataSource = self
        picker?.delegate = self
        picker?.reloadAllComponents()
    }
}

extension PickerViewCustomDataSource:UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate {
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return columns ?? 0
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return columns ?? 0
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerData?.count ?? 0
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let block = self.titleForRow {
            return block( row , pickerData?[row]  as Any )
            
        }
        guard let safeData = self.pickerData?[row] as? String else{return ""}
        return safeData
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let block = self.aSelectedBlock{
            block( row , pickerData?[row]  as Any )
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if /pickerData?.count != 0 {
            if let row = picker?.selectedRow(inComponent: 0) {
                if let block = self.aSelectedBlock{
                    block( row , pickerData?[row]  as Any )
                }
            }
        }
        
    }
}
