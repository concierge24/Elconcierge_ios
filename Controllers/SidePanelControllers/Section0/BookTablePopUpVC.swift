//
//  BookTablePopUpVC.swift
//  Sneni
//
//  Created by Sandeep Kumar on 19/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class BookTablePopUpVC: UIViewController {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!

    @IBOutlet weak var txtSugestion: UITextField!
    @IBOutlet weak var txtReservationCode: UITextField!

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnSubtract: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTableCount: UILabel!

    //MARK:- ======== Variables ========
    var blockDone: (() -> ())?
    var datePicker = UIDatePicker()
    
    var countTable: Int = 0 {
        didSet {
            if countTable < 1 {
                countTable = 1
            } else if countTable > 99 {
                countTable = 99
            }
            
            if lblTableCount.text != "\(countTable)" {
                let oldTex = Int(/lblTableCount.text)
                UIView.transition(with: lblTableCount,
                                  duration: 0.25,
                                  options: oldTex! > countTable ? .transitionFlipFromRight : .transitionFlipFromLeft,
                                  animations: { [weak self] in
                                    self?.lblTableCount.text = "\(/self?.countTable)"
                    }, completion: nil)
            }
            

        }
    }
    
    var date: Date? {
        didSet {
            guard let date = date else { return }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            formatter.dateFormat =  "dd/MM/yyyy"
            txtDate.text = formatter.string(from: date)

            formatter.dateFormat =  "hh:mm a"
            txtTime.text = formatter.string(from: date)
            
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
        
        countTable = 1
        
        viewPopUp.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        UIView.animate(withDuration: 0.5) {
            self.viewPopUp.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    //MARK:- ======== Actions ========
    func closePopUp(block: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            [weak self] in
            guard let self = self else { return }
            
            self.viewPopUp.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            
            }, completion: {
                [weak self] (_) in
                guard let self = self else { return }
                
                self.dismissVC(completion: block)
        })
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        
        closePopUp(block: nil)
        
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        
        closePopUp {
            [weak self] in
            guard let self = self else { return }
            
            self.blockDone?()
        }
    }
    
    @IBAction func didTapSubtract(_ sender: Any) {
        countTable -= 1
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        countTable += 1
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        
        txtDate.inputView = datePicker
        txtTime.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(changeDatePicker(picker:)), for: .valueChanged)
        
        txtDate.delegate = self
        txtTime.delegate = self
    }
    
    
    
    @objc func changeDatePicker(picker: UIDatePicker) {
        
        date = picker.date
        
    }
}


extension BookTablePopUpVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDate {
            datePicker.datePickerMode = .date
        } else {
            datePicker.datePickerMode = .time
        }
        return true
    }
}
