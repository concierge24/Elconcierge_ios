//
//  IntroductionVC.swift
//  Buraq24
//
//  Created by Maninder on 30/07/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit


struct WalkThroughModel {
    var title:String
    var subtitle:String
    var image:UIImage
}

class IntroductionVC: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var collectionViewIntro: UICollectionView!
    @IBOutlet weak var pagingControl: UIPageControl!
    @IBOutlet var btnNext: UIButton!
    
    //MARK:- Properties
    
    var collectionViewDataSource : CollectionViewDataSourceCab?
    var items = [
        WalkThroughModel.init(title:"IntroductionVC.TitleFirst".localizedString  , subtitle: "IntroductionVC.TitleDescription".localizedString, image:  R.image.wt1() ?? UIImage())
       
        ]
    
    
    //MARK:- ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagingControl.currentPage = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureCollectionView()
    }
    
    //MARK:- IBOutlet Action Method
    
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        UDSingleton.shared.isOnBoardingDone = true
        guard let vc =  R.storyboard.mainCab.landingAndPhoneInputVC()else{ return }
        self.pushVC(vc)
    }
    
}
//MARK: - Configure collectionview

extension IntroductionVC {
    
    
    func configureCollectionView() {
        
        
        btnNext.setImage(#imageLiteral(resourceName: "Next").setLocalizedImage(), for: .normal)

        let configureCellBlock : ListCellConfigureBlockCab = {(cell, item, indexPath) in
            let cell = cell as? WalkThroughCell
            if let model = item as? WalkThroughModel {
                cell?.configureCell(item: model)
            }
        }
        
        let centreCellBlock : DidCellIndexInCenter = { [weak self] (indexPath) in
            self?.pagingControl.currentPage = indexPath.row
        }
        
        
       
        collectionViewDataSource =  CollectionViewDataSourceCab(items: items, collectionView: collectionViewIntro, cellIdentifier: R.reuseIdentifier.walkThroughCell.identifier, cellHeight: self.collectionViewIntro.frame.size.height, cellWidth: ez.screenWidth, configureCellBlock: configureCellBlock )
        
        collectionViewDataSource?.centreCellListener = centreCellBlock
        
        collectionViewIntro.delegate = collectionViewDataSource
        collectionViewIntro.dataSource = collectionViewDataSource
        
        collectionViewIntro.reloadData()
    }
    
}




