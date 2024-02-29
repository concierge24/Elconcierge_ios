//
//  DoctorHomeParentCell.swift
//  Sneni
//
//  Created by Daman on 17/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import EZSwiftExtensions

typealias ItemClickedBlock = (Any) -> ()

class DoctorHomeParentCell: CustomizationBaseTableCell {

    var height: CGFloat = 220 //image, title and rating

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblTitlePrefix: UILabel!
    @IBOutlet var lblTitleSuffux: UILabel!

    @IBOutlet var constHeightCollectionView: NSLayoutConstraint!
    
     var collectionViewDataSource = CollectionViewDataSource(){
         didSet{
             collectionView.dataSource = collectionViewDataSource
             collectionView.delegate = collectionViewDataSource
         }
     }
    
    var itemClickedBlock: ItemClickedBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model: OffersByCategory?
    
    func configureCell(_ model: OffersByCategory) {
        //add stepper height and price height
        height = 220 + 24 + 15
        lblTitlePrefix.text = "Top Deals in".localized()
        lblTitleSuffux.text = model.name
        self.model = model
        updateUI(withContent: model.productValue)
    }
    
    func configureSuppliers(_ suppliers: [Supplier]?) {
        height = 220
        lblTitlePrefix.text = "Recommended".localized()
        lblTitleSuffux.text = "Suppliers".localized()
        updateUI(withContent: suppliers)
    }

     private func updateUI(withContent content : [AnyObject]?){
        
        constHeightCollectionView.constant = height
         let width = 173
         
         collectionViewDataSource = CollectionViewDataSource(
             items: content,
             tableView: collectionView,
             cellIdentifier: DoctorHomeProductCell.identifier,
             headerIdentifier: nil,
             cellHeight: CGFloat(height),
             cellWidth: CGFloat(width),
             configureCellBlock: { [weak self] (cell, item) in
                guard let self = self else { return }
                 if let item = item as? Supplier {
                     (cell as? DoctorHomeProductCell)?.supplier = item
                 } else {
                    guard let cell = cell as? DoctorHomeProductCell else { return }
                    cell.product = item as? ProductF
                    cell.addonsCompletionBlock = {[weak self] data in
                        guard let self = self else {return}
                        //  guard let addonBlock = self.addonsCompletionBlock else {returself.n}
                        guard let indexpath = self.collectionView.indexPath(for: cell) else { return }
                        if let value = data as? (ProductF,Bool,Double) {
                            //addonBlock(value)
                            self.openCustomizationView(cell: cell, product: value.0, cartData: nil, quantity: value.2, index: indexpath.item)
                        } else if let value = data as? (ProductF,Cart,Bool,Double) {
                          //  addonBlock(value)
                            self.openCheckCustomizationController(cell: cell, productData: value.0, cartData: value.1, shouldShow: value.2, index: indexpath.item)
                        }
                    }
                 }
                 
         }, aRowSelectedListener: {
             [weak self] (indexPath) in
             guard let self = self else { return }
            if let item = self.collectionViewDataSource.items?[indexPath.row] {
                self.itemClickedBlock?(item)
            }
         })
         collectionView.reloadData()
     }
    
    @IBAction func viewMore(_ sender: Any) {
        if lblTitleSuffux.text == "Suppliers".localized() {
            
        }
        else {
            //AppSettings.shared.selectedCategoryId = category
            let VC = ItemListingViewController.getVC(.main)
            VC.isOffers = true
            ez.topMostVC?.pushVC(VC)
        }

    }
}
