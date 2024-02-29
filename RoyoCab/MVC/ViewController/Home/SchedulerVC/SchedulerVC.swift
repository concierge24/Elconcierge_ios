//
//  SchedulerVC.swift
//  Buraq24
//
//  Created by MANINDER on 13/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

protocol DateSelectedlDelegate {
    
    func didSelectedDate(date: Date)
}

class SchedulerVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var viewOuter: UIView!
    @IBOutlet var viewDatePicker: UIDatePicker!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    
    //MARK:- PROPERTIES
    
    var delegateDate: DateSelectedlDelegate?
    var minDate: Date = Date()
    var previousSeletectedDate: Date?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    //MARK:- Actions
    
    @IBAction func actionBtnCancel(_ sender: UIButton) {
        dismissVC()
    }
    
    @IBAction func actionBtnDonePressed(_ sender: UIButton) {
        
        let selectedDate = viewDatePicker.date
        self.delegateDate?.didSelectedDate(date: selectedDate)
        dismissVC()
        
//        if Validations.sharedInstance.validateSchedulingDate(date: selectedDate, minDate: minDate) {
//            self.delegateDate?.didSelectedDate(date: selectedDate)
//            dismissVC()
//        }
    }
    
    //MARK:- Function
    
    func setUpUI() {
        viewDatePicker.minimumDate = minDate
        
        if let date = previousSeletectedDate {
            viewDatePicker.setDate(date, animated: true)
        }
        viewDatePicker.locale = Locale(identifier: /UserDefaultsManager.localeIdentifierCustom)
        
        buttonCancel.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
        buttonDone.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            if hitView === viewOuter {
                dismissVC()
            }
        }
    }
    
    func dismissVC() {
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.dismissVC(completion: nil)
        }
    }
}
