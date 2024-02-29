//
//  CodeStructure.swift
//  Sneni
//
//  Created by cbl41 on 3/6/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

// ECommerce
/*
 
 Note:- 1. Show Supplier name for multiVendor only
 2. Show popular suppliers for multiVendor only
 
 Home: HomeViewController
 Hierarchy: NavigationView
            TableView > HomeSectionHeader
                        BannerParentCell > CollectionView > BannerCell
                        OHomeOffersHListTableCell > CollectionView > HomeProductCell
                        HomeBrandsCollectionTableCell > CollectionView > HomeBrandCollectionCell
                        HomeProductParentCell > CollectionView > HomeProductCell > updateSupplierUI() (for multiVendor only)
 
 Cart: CartViewController
 Hierarchy: TableView > OrderStatusCell(stackView -> ProductView (configured in OrderDetailController)), OrderDetailCell
            OrderParentCell (For completed orders)
 
 Header Search : ItemTableViewController
 
 Flow:
 */
