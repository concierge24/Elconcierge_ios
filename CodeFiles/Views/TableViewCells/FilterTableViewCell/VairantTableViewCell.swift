//
//  VairantTableViewCell.swift
//  Sneni
//
//  Created by MAc_mini on 17/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit



class VairantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var heightConstrantVarient: NSLayoutConstraint?
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var lblVaraintName:UILabel!
    @IBOutlet weak var stackLabels: UIStackView!

    var arrVariant = [ProductVariantValue]()
    var isFilterProduct:Bool?
    var isTableReload:Bool = false
    var level: Int = 0
    weak var vcFilter: FilterVC?

    var sectionData:SectionData? {
        didSet{
            isFilterProduct = true
            self.updateUI()
        }
    }
    
    var productVariantModel:ProductVariantModel?{
        didSet{
            stackLabels.isHidden = (/productVariantModel?.variantName).isEmpty
            lblVaraintName.text = productVariantModel?.variantName
            isFilterProduct = false
            self.updateUI()
        }
    }
    
    var collectionViewDataSource: CollectionViewDataSource? {
        didSet{
            collectionView.dataSource = collectionViewDataSource
            collectionView.delegate = collectionViewDataSource
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
    
}

extension VairantTableViewCell{
    
    private func updateUI(){
        
        if isFilterProduct == false {
            self.arrVariant.removeAll()
            filterVariantsBasedOnPreviousLevel()
            self.configureCollectionView()
        }
        else{
            self.configureCollectionView()
        }
    }
    
    func filterVariantsBasedOnPreviousLevel() {
        guard let vc = self.superview?.superview?.next as? ProductVariantVC else { return }

        if level == 0 {
            self.arrVariant = productVariantModel?.variantValues ?? []
        }
        else {
            let previousVariantArr = vc.product?.variants?[level-1].filteredValues ?? []
            //select first object from previous section filtered variants
            var previousVariantSelected = (vc.product?.variants?[level-1].filteredUniqueValues ?? []).first
            if vc.productVariantValue.count >= level {
                previousVariantSelected = vc.productVariantValue[level-1]
            }
            
            //1. Filter variant values of previous based on selected value
            let arrVariantValues = previousVariantArr.filter({$0.variantValue == previousVariantSelected?.variantValue})

            //2. Match product ids of previous section variant arr with current section variant arr
            for obj in arrVariantValues {

                if let arrVariantValues = self.productVariantModel?.variantValues.filter({$0.productId == obj.productId}) {
                    self.arrVariant.append(contentsOf: arrVariantValues)
                }
            }
        }

        vc.product?.variants?[level].filteredValues = arrVariant

        //3. Filter unique variantValue
        var filteredArr = [ProductVariantValue]()
        self.arrVariant.forEach({ (obj) in
            let arr = filteredArr.filter({$0.variantValue == obj.variantValue})
            if arr.count == 0 {
                filteredArr.append(obj)
            }
        })
        
       self.arrVariant =  filteredArr
        vc.product?.variants?[level].filteredUniqueValues = arrVariant
    }

    func configureCollectionView(){
        let type = self.isFilterProduct == true ? self.sectionData?.title : self.productVariantModel?.variantName

        var  width =  90.0//(/isFilterProduct ? (UIScreen.main.bounds.width-128.0)-32.0 : 90.0)
        let height = 40.0
        
        if type?.capitalizedFirst() == "Color" {
            width = 40.0//(/isFilterProduct ? ((UIScreen.main.bounds.width-128.0)-80.0)/4.0 : 40.0)
        } else if type?.capitalizedFirst() == "Size" {
            width = 40.0
        }
        
        let arrayVariant:[Any] = (isFilterProduct == true ? sectionData?.title == "Brands" ? (sectionData?.cells?[level] as? [Brands] ?? [])  : sectionData?.cells?[level] as? [VariantValue] ?? [] : arrVariant)
        
       // let text = isFilterVariant == true ? variantValue?.value.capitalized : productVariantValue?.variantValue.capitalized
        
        if collectionViewDataSource != nil {
            collectionViewDataSource?.items = arrayVariant
            collectionView.reloadData()
            return
        }
        collectionViewDataSource = CollectionViewDataSource(items: arrayVariant, tableView: collectionView, cellIdentifier: CellIdentifiers.VariantCollectionViewCell , headerIdentifier: nil, cellHeight:CGFloat(height), cellWidth: CGFloat(width), configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
            guard let cell = cell as? VariantCollectionViewCell else { return }

            let type = self.isFilterProduct == true ? self.sectionData?.title?.capitalizedFirst() : self.productVariantModel?.variantName?.capitalizedFirst()

            if self.isFilterProduct ==  true {
                
                if type == "Brands" , let item = item as? Brands
                {
                    cell.brand = item
                    cell.borderColor = self.vcFilter?.objFilter.arrayBrandId.firstIndex(where: { $0 == /item.id }) == nil ? CollectionThemeColor.shared.cellUnSelectedBorderClr : CollectionThemeColor.shared.cellSelectedBorderClr
                }
                else if let item = item as? VariantValue
                {
                    cell.variantValue = item
                    cell.borderColor = self.vcFilter?.objFilter.variantIdArray.firstIndex(where: { $0 == /item.id }) == nil ? CollectionThemeColor.shared.cellUnSelectedBorderClr : CollectionThemeColor.shared.cellSelectedBorderClr
                    
                }
                cell.isFilterVariant = true
            }
            else
            {
                cell.productVariantValue =  item as? ProductVariantValue
                cell.isFilterVariant = false
                guard let vc = self.superview?.superview?.next as? ProductVariantVC else { return }
                if vc.productVariantValue.count > self.level, vc.productVariantValue[self.level].unid == cell.productVariantValue?.unid {
                    
                    cell.borderColor = CollectionThemeColor.shared.cellSelectedBorderClr
                }
                else{
                    cell.borderColor = CollectionThemeColor.shared.cellUnSelectedBorderClr
                }
                self.cellForRow(cell: cell)
            }
            
            cell.borderWidthW = cell.borderColor == CollectionThemeColor.shared.cellSelectedBorderClr ? 2 : 1
            cell.type = type
            
            }, aRowSelectedListener: { (indexPath) in
            
            let cell =  self.collectionView.cellForItem(at: indexPath) as? VariantCollectionViewCell
            self.setFilterVariantCellDidScelect(cell: cell)
          
        })

        if  type?.capitalizedFirst() != "Color"  || type?.capitalizedFirst() != "Size" {
                collectionViewDataSource?.blockSizeCell = {
                    [weak self] (index) -> CGSize in
                    guard let self = self else { return CGSize(width: CGFloat(width), height: CGFloat(height)) }
    
                    if let arrayVariant = self.sectionData?.cells?[self.level] as? [Brands] {
    
                        let str = /arrayVariant[index.row].name.capitalized
                        return CGSize(width: CGFloat(str.width(font: UIFont.systemFont(ofSize: 15.0))+10.0), height: CGFloat(height))
                    } else if let arrayVariant = self.sectionData?.cells?[self.level] as? [VariantValue] {
                        return CGSize(width: CGFloat(width), height: CGFloat(height))
                    }
                    return CGSize(width: CGFloat(width), height: CGFloat(height))
                }
            }
        
//        if /self.isFilterProduct && type == "Brands" {
//            collectionViewDataSource?.blockSizeCell = {
//                [weak self] (index) -> CGSize in
//                guard let self = self else { return CGSize(width: CGFloat(width), height: CGFloat(height)) }
//
//                if let arrayVariant = self.sectionData?.cells?[self.level] as? [Brands] {
//
//                    let str = /arrayVariant[index.row].name.capitalized
//                    return CGSize(width: CGFloat(str.width(font: UIFont.systemFont(ofSize: 15.0))+10.0), height: CGFloat(height))
//                } else if let arrayVariant = self.sectionData?.cells?[self.level] as? [VariantValue] {
//                    return CGSize(width: CGFloat(width), height: CGFloat(height))
//                }
//                return CGSize(width: CGFloat(width), height: CGFloat(height))
//            }
//        }
    }
    
    
    
    func cellForRow(cell:VariantCollectionViewCell?)  {
        
        if isFilterProduct == true{
            
            if FilterCategory.shared.variantIdArray.contains(/cell?.variantValue?.id) || FilterCategory.shared.arrayBrandId.contains(/cell?.brand?.id) {
                cell?.borderColor = CollectionThemeColor.shared.cellSelectedBorderClr
            }
            else{
                cell?.borderColor = CollectionThemeColor.shared.cellUnSelectedBorderClr
            }
            
        }
    }
    
    
    func setFilterVariantCellDidScelect(cell:VariantCollectionViewCell?)  {
        
        if isFilterProduct == true
        {
            if cell?.type == "Brands"
            {
                if let index = vcFilter?.objFilter.arrayBrandId.firstIndex(where: { $0 == /cell?.brand?.id })
                {
                    vcFilter?.objFilter.arrayBrandId.remove(at: index)
                    cell?.borderColor = CollectionThemeColor.shared.cellUnSelectedBorderClr
                }
                else
                {
                    vcFilter?.objFilter.arrayBrandId.append(/cell?.brand?.id)
                    cell?.borderColor = CollectionThemeColor.shared.cellSelectedBorderClr
                }
            }
            else
            {
                if let index = vcFilter?.objFilter.variantIdArray.firstIndex(where: { $0 == /cell?.variantValue?.id })
                {
                    vcFilter?.objFilter.variantIdArray.remove(at: index)
                    cell?.borderColor = CollectionThemeColor.shared.cellUnSelectedBorderClr
                }
                else
                {
                    vcFilter?.objFilter.variantIdArray.append(/cell?.variantValue?.id)
                    cell?.borderColor = CollectionThemeColor.shared.cellSelectedBorderClr
                }
            }
            cell?.borderWidthW = cell?.borderColor == CollectionThemeColor.shared.cellSelectedBorderClr ? 2 : 1
        }
        else
        {
            guard let vc = self.superview?.superview?.next as? ProductVariantVC else { return }

            //Couldn not select level if previous level not selected
            if vc.productVariantValue.count < level {
                return
            }
            //Remove selected values of all sub levels
                while vc.productVariantValue.count > level {
                    vc.productVariantValue.removeLast()
                }
                if let value = cell?.productVariantValue {
                    vc.productVariantValue.append(value)
                }
                isTableReload = true
                vc.tableView.reloadData()
            if level == (vc.productVariantValue.count-1) && level == (/vc.product?.variants?.count-1) {
                    vc.passedData.productId = cell?.productVariantValue?.productId.toString
                    vc.webServiceProductDetail()
                }

        }
        
    }
    
}




