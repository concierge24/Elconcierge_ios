//
//  CategoryMapping.swift
//  Clikat
//
//  Created by cbl73 on 5/3/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit
//"category_flow" : "Category>Services>PickUpTime>Suppliers>SupplierInfo>LaundryOrder",
//Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl
enum CategoryFlowMap : String {
    
    case Category = "Category"
    case SubCategory = "SubCategory"
    case DetailedSubCategory = "Ds-Pl"
//    case DetailedSubCategory = "DetailedSubCategory"
    case Suppliers = "Suppliers"
    case SupplierInfo = "SupplierInfo"
    case ProductListing = "Pl"
    case Services = "Services"
    case PackageSupplierListing = "PackageSL"
    case PackageSupplierInfo = "PackageSI"
    case PackageProducts = "PackageProducts"
    
    case PickUpTime = "PickUpTime"
    case LaundryOrder = "LaundryOrder"
    case CategorySelection = "CategorySelectionController"
    
    
    func viewControllerIntance() -> UIViewController?{
        
        switch self {
        case .Category:
            return StoryboardScene.Main.instantiateHomeViewController()
        case .SubCategory:
            return StoryboardScene.Main.instantiateSubcategoryViewController()
        case .DetailedSubCategory:
            return ItemListingViewController.getVC(.main)
        case .Suppliers:
            return StoryboardScene.Main.instantiateSupplierListingViewController()
        case .PackageSupplierListing:
            return StoryboardScene.Main.instantiatePackageSupplierListingViewController()
        case .SupplierInfo , .PackageSupplierInfo :
            
            if SKAppType.type.isFood {
//                let supplierInfoVC = StoryboardScene.Main.instantiateSupplierInfoViewController()
                var supplierInfoVC = UIViewController()
                if /AppSettings.shared.appThemeData?.app_selected_template == "1" {
                    supplierInfoVC = RestaurantMenuVC.getVC(.splash)
                }else {
                    supplierInfoVC = RestaurantDetailVC.getVC(.splash)
                }
                return supplierInfoVC

            } else {
                let supplierInfoVC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                return supplierInfoVC

            }
            
        case .ProductListing:
            let productListingVc = ItemListingViewController.getVC(.main)
            productListingVc.hideDetailedSubCategoriesBar = true
            return productListingVc
        case .PackageProducts:
            return StoryboardScene.Main.instantiatePackageProductListingViewController()
        case .Services :
            return ServicesViewController.getVC(.laundry)
        case .PickUpTime :
            return PickupDetailsController.getVC(.laundry)
        case .LaundryOrder:
            return OrderViewController.getVC(.laundry)
        case .CategorySelection:
            return StoryboardScene.Options.instantiateCategorySelectionController()
        }

        
    }
    
    
}

enum InstanceException: Error {
    case InstanceNotFound
    case CategoryNotFound
}

class CategoryMapping {
    
    class func nextViewController(withFlow flow : String? , hasSubCat: Bool, currentViewController : UIViewController?) throws -> UIViewController? {
        
        guard let unwrappedFlow = flow else{
            throw InstanceException.CategoryNotFound
        }
        let flowComponents = unwrappedFlow.components(separatedBy: ">")
        guard let currentViewControllerIdentifier = CategoryMapping.mapViewControllerWithIdentifier(withViewController: currentViewController ,flowComponents: flowComponents),
            let nextItemIndex = flowComponents.index(of: currentViewControllerIdentifier) else {
                
                if let vc = currentViewController as? SupplierInfoViewController
                {
                    if let supp = vc.passedData.subCats?.first?.toServiceType {
                        vc.openCategory(category: supp)
                    }
                }
                else if let vc = currentViewController as? SupplierInfoViewControllerNoFood
                {
                    if let supp = vc.passedData.subCats?.first?.toServiceType {
                        supp.supplierId = vc.passedData.supplierId
                        vc.openCategory(category: supp)
                    }
                    
                }
                return nil
                throw InstanceException.CategoryNotFound
        }
        
        if flowComponents.count < nextItemIndex + 1{
            if let vc = currentViewController as? SupplierInfoViewController, let supp = vc.supplier?.getCat
            {
                vc.openCategory(category: supp)
            } else if let vc = currentViewController as? SupplierInfoViewControllerNoFood, let supp = vc.supplier?.getCat
            {
                vc.openCategory(category: supp)
            }
            return nil
            throw InstanceException.InstanceNotFound
        }
        
        
        print(flowComponents[nextItemIndex + 1])
        let nextCat = CategoryFlowMap(rawValue: flowComponents[nextItemIndex + 1])
        if SKAppType.type == .home {
            //If there was one supplier, after questionare module - show product listing
            if nextCat == .Suppliers && GDataSingleton.sharedInstance.currentSupplier != nil {
                if flowComponents.count < nextItemIndex + 2 {
                    return nil
                }
                let nextViewControllerInstance =  CategoryFlowMap(rawValue: flowComponents[nextItemIndex + 2])?.viewControllerIntance()
                return nextViewControllerInstance
            }
        }
        if nextCat == .SubCategory && !hasSubCat {
            if flowComponents.count < nextItemIndex + 2 {
                return nil
            }
            let nextViewControllerInstance =  CategoryFlowMap(rawValue: flowComponents[nextItemIndex + 2])?.viewControllerIntance()
            return nextViewControllerInstance
        }
        else {
            let nextViewControllerInstance =  CategoryFlowMap(rawValue: flowComponents[nextItemIndex + 1])?.viewControllerIntance()
            return nextViewControllerInstance
        }

    }

    
    class func mapViewControllerWithIdentifier(withViewController currentViewController : UIViewController? , flowComponents : [String])  -> String? {
        
        guard let viewController = currentViewController else {
            fatalError("Invalid current ViewController")
        }
        // return current type in CategoryFlowMap
        if SKAppType.type == .eCom {
            if (viewController is HomeViewController) || (viewController is DoctorHomeVC) || (viewController is SupplierInfoViewController) || (viewController is SupplierInfoViewControllerNoFood) || (viewController is CategoryTabVC) {
                return CategoryFlowMap.Category.rawValue
            }
        } else {
            if (viewController is HomeViewController) || (viewController is DoctorHomeVC) {
                return CategoryFlowMap.Category.rawValue
            }
            else if let vc = viewController as? SubcategoryViewController {
                if (vc.objCatData?.arrayCategories?.count ?? 0) > 0 {
                    return CategoryFlowMap.Category.rawValue
                }
            }
        }
        
        if let _ = viewController as? SupplierListingViewController {
            if flowComponents.contains(CategoryFlowMap.PackageSupplierListing.rawValue){
                return CategoryFlowMap.PackageSupplierListing.rawValue
            }
            return CategoryFlowMap.Suppliers.rawValue
        }
        
        if (viewController is SupplierInfoViewController) || (viewController is SupplierInfoViewControllerNoFood) {
            
            // return CategoryFlowMap.Category.rawValue
            //TestOn Live Flow Not Working
            if flowComponents.contains(CategoryFlowMap.PackageSupplierInfo.rawValue){
                return CategoryFlowMap.PackageSupplierInfo.rawValue
            }
            return CategoryFlowMap.SupplierInfo.rawValue
        }
        if let _ = viewController as? PackageSupplierListingViewController {
            return CategoryFlowMap.PackageSupplierListing.rawValue
        }
        
        if let _ = viewController as? SubcategoryViewController {
            return CategoryFlowMap.SubCategory.rawValue
        }
        
        if let _ = viewController as? ItemListingViewController {
            if flowComponents.contains(CategoryFlowMap.PackageProducts.rawValue){
                return CategoryFlowMap.PackageProducts.rawValue
            }
            return CategoryFlowMap.DetailedSubCategory.rawValue
        }
        
        if let _ = viewController as? ProductDetailViewController {
            return CategoryFlowMap.ProductListing.rawValue
        }
        if let _ = viewController as? ServicesViewController {
            return CategoryFlowMap.Services.rawValue
        }
        if let _ = viewController as? PickupDetailsController {
            return CategoryFlowMap.PickUpTime.rawValue
        }
        
        if let _ = viewController as? OrderViewController {
            return CategoryFlowMap.LaundryOrder.rawValue
        }
        
        if viewController is CategorySelectionController {
            return CategoryFlowMap.Category.rawValue
        }
        
        if viewController is CategorySelectionController {
            return CategoryFlowMap.Category.rawValue
        }
        if viewController is OrderViewController{
            return CategoryFlowMap.LaundryOrder.rawValue
            
        }
        if viewController is CategoryTabVC {
            return CategoryFlowMap.Category.rawValue
            
        }
        if viewController is NewHomeScreenVC {
            return CategoryFlowMap.Category.rawValue
        }
        return nil
    }
    
}


