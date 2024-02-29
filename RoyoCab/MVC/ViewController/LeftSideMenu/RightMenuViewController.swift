//
//  RightMenuViewController.swift
//  Buraq24
//
//  Created by MANINDER on 21/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewTopSupport: UIView!
    @IBOutlet var collectionViewSupport: UICollectionView!
    
    //MARK:- Properties
    var collectionViewDataSource : CollectionViewDataSourceCab?
    lazy var supportList : [SupportCab] = [SupportCab]()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.perform(#selector(createGradient), with: nil, afterDelay: 0.0)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let supports = UDSingleton.shared.userData?.support {
            supportList.removeAll()
            supportList.append(contentsOf: supports)
        }
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionViewSupport.reloadData()
    }
    
    
    //MARK:- Functions
    
    @objc func createGradient(){
        viewTopSupport.setViewBackgroundColorTheme()
    }
    
    private  func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {(cell, item, indexPath) in
            if let cell = cell as? SupportOption, let model = item as? SupportCab {
                cell.configureCell(model: model)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = {  (indexPath , cell, item) in
            
            if let _ = cell as? SupportOption {
                Alerts.shared.show(alert: "AppName".localizedString, message: "coming_soon".localizedString , type: .error )

                //Toast.show(text: "coming_soon".localizedString, type: .error)
            }
        }
        
        collectionViewDataSource =  CollectionViewDataSourceCab(items: supportList, collectionView: collectionViewSupport, cellIdentifier: R.reuseIdentifier.supportOption.identifier, cellHeight: CGFloat(BookingPopUpFrames.WidthSideMenu/2) + 20, cellWidth: CGFloat(BookingPopUpFrames.WidthSideMenu/2) , configureCellBlock: configureCellBlock )
        
        collectionViewDataSource?.aRowSelectedListener = didSelectCellBlock
        
        collectionViewSupport.delegate = collectionViewDataSource
        collectionViewSupport.dataSource = collectionViewDataSource
        
        collectionViewSupport.reloadData()
    }
    
}
