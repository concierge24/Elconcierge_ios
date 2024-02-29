//
//  PackageSupplierListingController+TableView.swift
//  Clikat
//
//  Created by Night Reaper on 23/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import EZSwiftExtensions

//MARK: - TableView Configuration Methods
extension PackageSupplierListingViewController {
    
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 124.0
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return suppliers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let items = suppliers else{
            return 0
        }
        if (!items.isEmpty) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
                return items[section].categories?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let categories = suppliers?[indexPath.section].categories
        cell.textLabel?.text = categories?[indexPath.row].category_name
        cell.textLabel?.font = UIFont(name: Fonts.ProximaNova.Regular, size: Size.Medium.rawValue)
        cell.textLabel?.backgroundColor = UIColor.clear
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(tableView: self.tableView, section: section)

        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SupplierListingCell) as! SupplierListingCell
        cell.frame = headerView.bounds
        cell.supplier = suppliers?[section]
        headerView.addSubview(cell)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let supplier = suppliers?[indexPath.section] , let supplierId = supplier.id , let supplierBranchId = supplier.supplierBranchId, let category = supplier.categories?[indexPath.row] else{
            return
        }
        GDataSingleton.sharedInstance.currentSupplier = supplier
        ez.runThisInMainThread { [weak self] in
            self?.passedData.supplierId = supplierId
            self?.passedData.categoryId = category.category_id
            self?.passedData.categoryOrder = category.order
            self?.passedData.supplierBranchId = supplierBranchId
            self?.pushNextVc()
        }

        
    }

}

extension PackageSupplierListingViewController : FilterViewControllerDelegate {
    func filterApplied (withFilter filter : FilterAssocitedValue){
        
        filters = filter
        if case .Filter(let status ,let delivery , let commission , let rating,let sortBy) = filter {
            var filterSuppliers = suppliers?.filter({ (supplier) -> Bool in
                
                
                var statusBool = false
                var paymentBool = false
                var commissionBool = false
                var ratingBool = false
                
                if status.isEmpty || status.contains(supplier.status) || supplier.status == .DoesntMatter {
                    statusBool = true
                }
                if delivery.isEmpty || delivery.contains(supplier.paymentMethod) || supplier.paymentMethod == .DoesntMatter {
                    paymentBool = true
                }
                if commission.isEmpty || commission.contains(supplier.commissionPackage) || supplier.commissionPackage == .DoesntMatter {
                    commissionBool = true
                }
                let supplierRating = supplier.rating?.toInt() ?? 0
                
                if rating.isEmpty || rating.contains(Rating(rawValue: supplierRating) ?? .DoesntMatter) || (supplierRating >= 4 && rating.last == .Star4Above){
                    ratingBool = true
                }
                return statusBool && paymentBool && commissionBool && ratingBool 
            })
            filterSuppliers?.sort(by: {
                switch sortBy {
                case .MinOrderAmount:
                    return ($0.minOrder?.toInt() ?? 0) < ($1.minOrder?.toInt() ?? 0)
                case .MinDelTime:
                    return ($0.minimumDeliveryTime?.toInt() ?? 0) < ($1.minimumDeliveryTime?.toInt() ?? 0)
                default:
                    break
                }
                return false
            })
            tableViewDataSource.items = filterSuppliers
            tableView.reloadData()
        }
    }
    
}
