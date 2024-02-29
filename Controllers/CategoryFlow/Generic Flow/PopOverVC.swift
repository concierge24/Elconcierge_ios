//
//  PopOverVC.swift
//  Sneni
//
//  Created by Apple on 03/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class PopOverVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblMenu: UILabel! {
        didSet{
            if let term = TerminologyKeys.catalogue.localizedValue() as? String{
                lblMenu.text = term
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "my")
        }
    }
    //MARK:- Variables
    var filterData : [ProductList]?
    var blockSelectSection: ((_ section: Int) -> ())?

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = true
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
    }
    
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension PopOverVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my", for: indexPath)
        
        let obj = filterData?[indexPath.row]
        cell.textLabel?.text = /obj?.catName
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissVC {
            [weak self] in
            self?.blockSelectSection?(indexPath.row)
        }
    }
}
