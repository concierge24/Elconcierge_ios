//
//  HomeOffersHListTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 27/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeOffersHListTableCell: CustomizationBaseTableCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var imgColorBG: UIImageView? {
        didSet {
            imgColorBG?.isHidden = true
//            imgColorBG?.isHidden = !( SKAppType.type == .home)
            //Nitin
            //imgColorBG?.isHidden = !(SKAppType.type == .party || SKAppType.type == .home || SKAppType.type == .gym)
        }
    }
    @IBOutlet weak var constraintHeightCollection: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            configCollection()
        }
    }
    
    //MARK:- ======== Variables ========
    var type: HomeScreenSection = .None
    var collectionViewDataSource: SKCollectionViewDataSource?
    var arrayItems : [ProductF]? {
        didSet {
            var size = HomeProductCell.size
            if SKAppType.type == .food {
                size = HomeFoodItemCollectionCell.size
            }
            constraintHeightCollection.constant = size.height+32.0
            collectionViewDataSource?.reload(items: arrayItems)
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        if SKAppType.type.isJNJ {
            backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9843137255, alpha: 1)
        }
    }
    
    private func configCollection() {
        
        var identifier = HomeProductCell.identifier
        var size = HomeProductCell.size

        if SKAppType.type == .food {
            identifier = HomeFoodItemCollectionCell.identifier
            size = HomeFoodItemCollectionCell.size
        }
        collectionView?.registerCells(nibNames: [identifier])
        
        collectionViewDataSource = SKCollectionViewDataSource(collectionView: collectionView, cellIdentifier: identifier, cellHeight: size.height, cellWidth: size.width)
        
        collectionViewDataSource?.configureCellBlock = {
            (indexpath, cell, item) in
            
            if let cell = cell as? HomeProductCell, let item = item as? ProductF {
                cell.isHideStepper = !SKAppType.type.isJNJ
                cell.productListing = item
                
            } else if let cell = cell as? HomeFoodItemCollectionCell, let item = item as? ProductF {
                cell.objModel = item
                cell.addonsCompletionBlock = {[weak self] data in
                    guard let self = self else {return}
                  //  guard let addonBlock = self.addonsCompletionBlock else {return}

                    if let value = data as? (ProductF,Bool,Double) {
                        //addonBlock(value)
                        self.openCustomizationView(cell: cell, product: value.0, cartData: nil, quantity: value.2, index: indexpath.item)
                    } else if let value = data as? (ProductF,Cart,Bool,Double) {
                      //  addonBlock(value)
                        self.openCheckCustomizationController(cell: cell, productData: value.0, cartData: value.1, shouldShow: value.2, index: indexpath.item)
                    }
                }
            }
            
        }
        
        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
        
            if SKAppType.type.isFood {
                return
            }
            //Nitin Check
            if let objB = self.arrayItems?[indexpath.row] {
                objB.openDetail()
//                self.blockSelect?(objB)
            }
        }
        collectionViewDataSource?.reload(items: arrayItems)
    }

    
  
}

class CustomizationBaseTableCell: UITableViewCell {
    
    func openCustomizationView(cell:Any?,product: ProductF?,cartData: Cart?,quantity: Double?,shouldHide:Bool = false,index:Int?) {
            
          let vc = StoryboardScene.Options.instantiateCustomizationViewController()
          vc.transitioningDelegate = self
          vc.modalPresentationStyle = .custom
          vc.product = product
          vc.hideAddCustom = shouldHide
          vc.index = index
          vc.cartData = cartData
            
          vc.completionBlock = { [weak self] data in
              guard let self = self else {return}
              if let obj = data as? (Bool,ProductF) {
                  if let _ = quantity { // called when add to card button is added
                      (cell as? HomeFoodItemCollectionCell)?.objModel = obj.1
                    (cell as? DoctorHomeProductCell)?.product = obj.1
                  }
              }
                self.removeViewAndSaveData()
          }
            
          if let parent = self.parentContainerViewController as? MainTabBarViewController {
              if let selectedVc = parent.selectedViewController as? HomeViewController {
                  selectedVc.present(vc, animated: true) {
                      self.createTempView()
                  }
              }
            else if let selectedVc = parent.selectedViewController as? DoctorHomeVC {
                selectedVc.present(vc, animated: true) {
                    self.createTempView()
                }
            }
          }
            
      }
        
      func openCheckCustomizationController(cell:Any?,productData: ProductF?,cartData: Cart?, shouldShow: Bool, index:Int?) {
            
          let vc = StoryboardScene.Options.instantiateCheckCustomizationViewController()
          vc.transitioningDelegate = self
          vc.modalPresentationStyle = .custom
          vc.cartProdcuts = cartData
          vc.product = productData
          vc.completionBlock = {[weak self] data in
              guard let self = self else {return}
              guard let productCell = cell else {return}
              if let dataValue = data as? (Bool,ProductF) {
                  (productCell as? HomeFoodItemCollectionCell)?.objModel = dataValue.1
                (productCell as? DoctorHomeProductCell)?.product = dataValue.1
                  if !dataValue.0 {
                      self.removeViewAndSaveData()
                  }
              } else if let dataValue = data as? (ProductF,Cart,Bool) {
                  let obj = ProductF(cart: dataValue.1)
                  dataValue.0.addOnValue?.removeAll()
                  let addonId = Int(obj.addOnId ?? "0")
                if let cell = productCell as? HomeFoodItemCollectionCell {
                    self.openCustomizationView(cell: cell, product: dataValue.0,cartData: dataValue.1, quantity: cell.stepper?.value ?? 0.0, index: addonId)
                }
                else if let cell = productCell as? DoctorHomeProductCell {
                    self.openCustomizationView(cell: cell, product: dataValue.0,cartData: dataValue.1, quantity: cell.stepper?.value ?? 0.0, index: addonId)

                }
              } else if let _ = data as? Bool{
                    //productCell.stepper?.stepperState = !obj ? .ShouldDecrease : .ShouldIncrease
                  self.removeViewAndSaveData()
              } else if let obj = data as? ProductF {
                   (productCell as? HomeFoodItemCollectionCell)?.objModel = obj
                                 (productCell as? DoctorHomeProductCell)?.product = obj
              } else if let _ = data as? Int {
                  self.removeViewAndSaveData()
              } else if let value = data as? (Bool,Double) {
                  if value.1 == 0 {
                      self.removeViewAndSaveData()
                  }
                  (productCell as? HomeFoodItemCollectionCell)?.stepper?.stepperState = .ShouldDecrease
                (productCell as? DoctorHomeProductCell)?.stepper?.stepperState = .ShouldDecrease
              }
          }
            
          if let parent = self.parentContainerViewController as? MainTabBarViewController {
              if let selectedVc = parent.selectedViewController as? HomeViewController {
                  selectedVc.present(vc, animated: true) {
                      self.createTempView()
                  }
              }
          }
            
      }
        
      func removeViewAndSaveData() {
          self.parentContainerViewController?.view.subviews.forEach { (view) in
              if view.tag == 10001 {
                  view.removeFromSuperview()
              }
          }
      }
        
      func createTempView(){
          let view = UIView()
          view.frame = self.parentContainerViewController?.view.frame ?? CGRect.zero
          view.backgroundColor = UIColor(white: 0.10, alpha: 0.8)
          view.tag = 10001
          self.parentContainerViewController?.view.addSubview(view)
      }
      
}

//MARK:- UIViewControllerTransitioningDelegate
extension CustomizationBaseTableCell : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
