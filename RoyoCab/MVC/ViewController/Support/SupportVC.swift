//
//  SupportVC.swift
//  Buraq24
//
//  Created by MANINDER on 03/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class SupportVC: BaseVCCab {

    
    //MARK:- Outlets
    @IBOutlet var collectionViewSupport: UICollectionView!
    
    //MARK:- Properties
    var collectionViewDataSource : CollectionViewDataSourceCab?
    lazy var supportList : [SupportCab] = [SupportCab]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let supports = UDSingleton.shared.userData?.support {
            supportList.append(contentsOf: supports)
        }
        
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    
    private  func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {(cell, item, indexPath) in
            if let cell = cell as? SupportOption, let model = item as? SupportCab {
                cell.configureCell(model: model)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { (indexPath , cell, item) in
            if let _ = cell as? SupportOption {
                Alerts.shared.show(alert: "AppName".localizedString, message: "coming_soon".localizedString , type: .error )
            }
        }
      
    let widthPara = ez.screenWidth/2
      let heightPara = collectionViewSupport.frame.size.width/2.3
        collectionViewDataSource =  CollectionViewDataSourceCab(items: supportList, collectionView: collectionViewSupport, cellIdentifier: R.reuseIdentifier.supportOption.identifier, cellHeight: heightPara, cellWidth: widthPara , configureCellBlock: configureCellBlock )
       
        collectionViewDataSource?.aRowSelectedListener = didSelectCellBlock
        collectionViewSupport.delegate = collectionViewDataSource
        collectionViewSupport.dataSource = collectionViewDataSource
        collectionViewSupport.reloadData()
    }
    
    
    
    
    
  

}
