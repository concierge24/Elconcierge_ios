//
//  RentalSupplierListingViewController.swift
//  Sneni
//
//  Created by Apple on 01/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class RentalSupplierListingViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var map_button: UIButton!
    @IBOutlet weak var filters_button: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "RentalSupplierListingTableViewCell", bundle: nil), forCellReuseIdentifier: "RentalSupplierListingTableViewCell")
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    //MARK:- Variables
    var filteredDataObj: RentalFilterData?
    var parameters = Dictionary<String,Any>()

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        if let obj = self.filteredDataObj?.products,obj.count > 0{
            self.tableView.reloadData()
            self.showData()
        }
        
    }

    //MARK:- Button Action
    @IBAction func back_buttonAction(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func filters_buttonAction(_ sender: Any) {
        
    }
    
    @IBAction func map_buttonAction(_ sender: Any) {
    
    
    }
    
    func showData() {
        
        if let pickupAddress = self.parameters["pickupAddress"] as? String {
            self.address_label.text = pickupAddress
        }
        
        if let selectedDates = self.parameters["selectedDates"] as? [Int] {
            
            let firstIndex = selectedDates[0]
            let lastIndex = selectedDates.last ?? 0
            
            if let modalObj = self.parameters["modalObj"] as? [RentalDateModalClass] {
                
                var startDate = modalObj[firstIndex].month ?? ""
                startDate = startDate + " " + /(modalObj[firstIndex].date)
                
                var endDate = modalObj[lastIndex].month ?? ""
                endDate = endDate + " " + /(modalObj[lastIndex].date)
                
                self.date_label.text = startDate + " - " + endDate
            }
            
        }
        
    }
    
    @objc func setFavourite(_ sender: UIButton) {
        self.setFavourite(tag: sender.tag)
    }
    
    func setFavourite(tag : Int) {

        if !GDataSingleton.sharedInstance.isLoggedIn {
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            presentVC(loginVc)
            return
        }
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row:tag, section: 0)) as? RentalSupplierListingTableViewCell else {return}
        cell.favourite_button.isSelected = !cell.favourite_button.isSelected
        
        guard let data = self.filteredDataObj?.products?[tag] else { return }
        
        let objR = API.makeProductFav(id: /data.id, isFav: cell.favourite_button.isSelected)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(_):
                self.filteredDataObj?.products?[tag].isFav = cell.favourite_button.isSelected == true ? 1 : 0
                if /self.filteredDataObj?.products?[tag].isFavourite {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") added to \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }else {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") removed from \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }
                
            case .Failure(let error):
                print(error.message ?? "")
                cell.favourite_button.isSelected = !cell.favourite_button.isSelected
                self.filteredDataObj?.products?[tag].isFav = cell.favourite_button.isSelected == true ? 1 : 0
                break
            }
        }

    }
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension RentalSupplierListingViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataObj?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentalSupplierListingTableViewCell", for: indexPath) as! RentalSupplierListingTableViewCell
        
        if let data = self.filteredDataObj?.products?[indexPath.row] {
            
            cell.productImage_imageView.loadImage(thumbnail: data.image_path, original: nil)
            cell.supplierName_label.text = data.supplierName ?? ""
            cell.carName_label.text = data.name ?? ""
            cell.address_label.text = data.supplier_address ?? ""
            cell.rating_label.text = String(data.averageRating ?? 0)
            
            cell.favourite_button.isSelected = data.isFavourite
            cell.favourite_button.tag = indexPath.row
            cell.favourite_button.addTarget(self, action: #selector(self.setFavourite(_:)), for: .touchUpInside)
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/2.2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = self.filteredDataObj?.products?[indexPath.row] {
            let vc = StoryboardScene.Main.instantiateRentalSupplierDetailController()
            vc.productData = data
            vc.parameters = self.parameters
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
