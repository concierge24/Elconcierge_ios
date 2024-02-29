//
//  RentalSupplierDetailViewController.swift
//  Sneni
//
//  Created by Apple on 02/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class RentalSupplierDetailViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var rating_label: UILabel!
    @IBOutlet weak var favourite_button: UIButton!
    @IBOutlet weak var supplierImage_imageView: UIImageView!
    @IBOutlet weak var supplierAddress_label: UILabel!
    @IBOutlet weak var supplierName_label: UILabel!
    @IBOutlet weak var description_textView: UITextView!
    @IBOutlet weak var carPrice_label: UILabel!
    @IBOutlet weak var carName_label: UILabel!
    @IBOutlet weak var productSpecification_collectionView: UICollectionView! {
        didSet{
            productSpecification_collectionView.register(UINib(nibName: "RentalProductSpecificationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RentalProductSpecificationCollectionViewCell")
        }
    }
    @IBOutlet weak var productImages_collectionView: UICollectionView!{
        didSet{
            productImages_collectionView.register(UINib(nibName: "RentalProductImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RentalProductImagesCollectionViewCell")
        }
    }
    
    //MARK:- Variables
    var parameters = Dictionary<String,Any>()
    let iconArray = [#imageLiteral(resourceName: "engineIcon"),#imageLiteral(resourceName: "calenderIcon"),#imageLiteral(resourceName: "automaticIcon"),#imageLiteral(resourceName: "doorIcon")]
    var productData: ProductF?
    var productObj: ProductF? {
        didSet {
            self.productImages_collectionView.reloadData()
            self.carName_label.text = productObj?.name ?? ""
            self.carPrice_label.text = ""
            self.supplierName_label.text = productData?.supplierName ?? ""
            self.supplierAddress_label.text = productData?.supplier_address ?? ""
            self.rating_label.text = String(productObj?.averageRating ?? 0)
            
            if let desc = productData?.desc {
                //self.description_textView.text = desc
                self.description_textView.attributedText = desc.htmlToAttributedString
            } else {
            }
            
            if let price = self.getPrice() {
                let str = Double(price).addCurrencyLocale + " + \("Booking fee".localized())"
                let rr = Double(price).addCurrencyLocale
                let range = (str as NSString).range(of: rr)

                var myMutableString = NSMutableAttributedString()
                myMutableString = NSMutableAttributedString(string: str)
                myMutableString.setAttributes([NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: CGFloat(18.0))!
                    , NSAttributedString.Key.foregroundColor : SKAppType.type.color], range: range) // What ever range you want to give
                self.carPrice_label.attributedText = myMutableString
                
                self.parameters["carPrice"] = Double(price).addCurrencyLocale
            }
            
        }
        
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProductDetail()
        
    }
    
    @IBAction func back_buttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continue_buttonAction(_ sender: Any) {
        self.webServiceAddToCart()
    }
    
    @IBAction func favourite_buttonAction(_ sender: UIButton) {
        self.setFavourite(sender: sender)
    }
    
    func setFavourite(sender : UIButton) {
        
        if !GDataSingleton.sharedInstance.isLoggedIn {
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            presentVC(loginVc)
            return
        }
        
        guard let data = self.productObj else { return }
        
        sender.isSelected = !sender.isSelected

        let objR = API.makeProductFav(id: /data.id, isFav: sender.isSelected)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(_):
                self.productObj?.isFav = sender.isSelected == true ? 1 : 0
                
                if /self.productObj?.isFavourite {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") added to \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }else {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") removed from \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }
                
            case .Failure(let error):
                print(error.message ?? "")
                sender.isSelected = !sender.isSelected
                self.productObj?.isFav = sender.isSelected == true ? 1 : 0
                break
            }
        }
        
    }
    
    func getPrice() -> Int?{
        
        if self.productObj?.interval_flag ?? 0 == 0 {
            if let perHour = self.productData?.required_hour {
                let ph = String(perHour)
                if let index = self.productObj?.hourly_price?.index(where: {$0.min_hour == ph}){
                    if let data = self.productObj?.hourly_price?[index] {
                        return data.price_per_hour ?? 0
                    }
                }
            }
        } else if self.productObj?.interval_flag ?? 0 == 1 {
            if let perDay = self.productData?.required_day {
                let pd = String(perDay)
                if let index = self.productObj?.hourly_price?.index(where: {$0.min_hour == pd}){
                    if let data = self.productObj?.hourly_price?[index] {
                        return data.price_per_hour ?? 0
                    }
                }
            }
            
        }
        
        return nil
    }
    
    func getProductDetail() {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ProductDetail(FormatAPIParameters.ProductDetail(productId: productData?.product_id ?? "", supplierBranchId: productData?.supplierid ?? "", offer: nil).formatParameters())) { (response) in
            
            switch response{
                
            case .Success(let listing):
                self.productObj = listing as? ProductF
                
            default :
                break
            }

        }
    }
    
   
    func webServiceAddToCart() {
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.token else {
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            presentVC(loginVc)
            return
        }
        
        guard let product = self.productObj else {return}
        let param = FormatAPIParameters.AddToCart(cart: [product], supplierBranchId: productObj?.supplierid ?? "", promotionType: nil, remarks:"" ).formatParameters()
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.AddToCart(param)) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success( let object):
                self.handleWebService(tempCartId: object)

            case .Failure(_):
                break
            }
        }
    }
    
    func handleWebService(tempCartId : Any?) {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            presentVC(loginVc)
            APIManager.sharedInstance.hideLoader()
            return
        }
        
        guard let cartId = (tempCartId as? String)?.components(separatedBy: "$").first else {
            APIManager.sharedInstance.hideLoader()
            return
        }
        
        guard let product = self.productObj else {
            APIManager.sharedInstance.hideLoader()
            return
        }
        
        var pp = ""
        if let price = self.getPrice() {
            pp = String(price)
        }
        let orderSummary: OrderSummary? = OrderSummary(items: [product], promo: nil, netTotal: pp)
        orderSummary?.cartId = cartId
        orderSummary?.isAgent = false
        orderSummary?.minOrderAmount = (tempCartId as? String)?.components(separatedBy: "$").last
        
        self.webServiceForUpdateCartInfo(orderSummary: orderSummary)
    }
    
    func webServiceForUpdateCartInfo(orderSummary : OrderSummary?){
        
        let delivery = Delivery(attributes: [:])
//        delivery.handlingSupplier = Cart.getMaxSupplier(cart: orderSummary?.items ?? []) ?? "0"
//        delivery.handlingAdmin = Cart.getMaxAdmin(cart: orderSummary?.items ?? []) ?? "0"
        delivery.deliveryCharges = "0"
        delivery.minOrderDeliveryCrossed = "0"
        
        guard let add = self.parameters["addressModal"] as? Address else {return}
        guard let pickupdate = self.parameters["pickupDateObj"] as? Date else {return}
        guard let deliverydate = self.parameters["deliveryDateObj"] as? Date else {return}
        
        delivery.pickupAddress = add
        delivery.pickupDate = pickupdate
        
        var priceDouble = Double()
        if let price = self.getPrice() {
            priceDouble = Double(price)
        }
        
        DeliveryViewController.updateCart(delivery: delivery, order: orderSummary, deliverySpeed: DeliverySpeedType.Standard, addressId: nil, deliveryDate: deliverydate, remarks: "", addOn: orderSummary?.addOnCharge, newTotal: priceDouble) {
            
            [weak self] in
            
            guard let self = self else { return }
            
            self.openRentalSummaryView(orderSummary: orderSummary)
//            let VC = StoryboardScene.Order.instantiateOrderSummaryController()
//            VC.orderSummary = orderSummary
//            VC.remarks = ""
//            VC.parameters = self.parameters
//            self.pushVC(VC)
            
        }
        
    }
    
    func openRentalSummaryView(orderSummary : OrderSummary?) {
        
        let vc = RentalPaymentSummaryViewController.getVC(.main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.parameters = self.parameters
        vc.orderSummary = orderSummary
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

//MARK:- UICollectionViewDelegate,UICollectionViewDataSource
extension RentalSupplierDetailViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.productSpecification_collectionView {
            return iconArray.count
        } else {
            return self.productObj?.images?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.productSpecification_collectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RentalProductSpecificationCollectionViewCell", for: indexPath) as! RentalProductSpecificationCollectionViewCell
            
            cell.specificationImage_imageView.image = iconArray[indexPath.item]
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RentalProductImagesCollectionViewCell", for: indexPath) as! RentalProductImagesCollectionViewCell
            
            if let data = self.productObj?.images?[indexPath.item]{
                cell.productImage_imageView.loadImage(thumbnail: data, original: nil)
            }

            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.productSpecification_collectionView {
            return CGSize(width: collectionView.frame.width/4.5, height: collectionView.frame.height)
            
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        }
        
    }
    
}

//MARK:- UIViewControllerTransitioningDelegate
extension RentalSupplierDetailViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
