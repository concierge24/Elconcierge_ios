//
//  PackageDetailViewController.swift
//  Trava
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class PackageDetailViewController: BaseVCCab {

    //MARK:- Outlet
    @IBOutlet var tableView: UITableView?
    @IBOutlet weak var textViewPackageDesc: UITextView!
    @IBOutlet weak var constraintHeightTable: NSLayoutConstraint!
    @IBOutlet weak var buttonPlaceRequest: UIButton!
    
    //MARK:- Properties
    var tableDataSource : TableViewDataSourceCab?
    var object : TravelPackages?
    var selectedOptionIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    
}

// MARK:- Functions
extension PackageDetailViewController {
    
    
    func initialSetup() {
        
        var imgBack = R.image.ic_back_arrow_black()
        
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            switch intVal{
            case 3, 5:
                imgBack = #imageLiteral(resourceName: "Back_New")
            default :
                imgBack = R.image.ic_back_arrow_black()
            }
        }
        
       // btnBack.setImage(imgBack?.setLocalizedImage(), for: .normal)
        setupUI()
        setupData()
        configureTableView()
    }
    
    func setupUI() {
        
        view.layoutIfNeeded()
        buttonPlaceRequest.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
    }
    
    func setupData() {
        
        textViewPackageDesc.text = object?.descriptionField
        
    }
    
    func configureTableView() {
        
        // tableView?.register(R.nib.travelPackages(), forCellReuseIdentifier: R.reuseIdentifier.travelPackagesCell.identifier )
        
        tableView?.register(UINib(nibName: R.reuseIdentifier.travelPackagesCell.identifier, bundle:nil), forCellReuseIdentifier: R.reuseIdentifier.travelPackagesCell.identifier)
        
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? TravelPackagesTableViewCell {
                cell.assignData(indexPath: indexpath, item: item as? TravelPackages, isDetailPage: true, isGreenImageBG: /self?.selectedOptionIndexPath?.row % 2 == 0)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { (indexPath , cell, item) in
            if cell is SelectionCell {
                //  self?.didSelectRowPressed(index: indexPath.row)
                // cell.setSelected(true, animated: true)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: [object as Any], tableView: tableView, cellIdentifier: R.reuseIdentifier.travelPackagesCell.identifier, cellHeight: UITableView.automaticDimension)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView?.delegate = tableDataSource
        tableView?.dataSource = tableDataSource
        tableView?.reloadData()
        
       /* let height = tableView?.contentSize.height
        constraintHeightTable.constant = /height
        view.layoutIfNeeded() */
        
    }
    
    
}


extension PackageDetailViewController {
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        popVC()
    }
    
    @IBAction func buttonTermsClicked(_ sender: Any) {
    }

    @IBAction func buttonPlaceRequestClicked(_ sender: Any) {
        
        guard let vc = R.storyboard.bookService.homeVC() else { return }
        vc.isFromPackage = true
        vc.modalPackages = object
        pushVC(vc)

    }
}


