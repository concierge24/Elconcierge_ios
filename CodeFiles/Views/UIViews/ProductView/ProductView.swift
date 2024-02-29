//
//  ProductView.swift
//  Clikat
//
//  Created by cblmacmini on 5/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

protocol ReturnStatusProtocol {
    func updateReturnStatus()
}

class ProductView: UIView ,ReturnStatusProtocol {

    @IBOutlet var btnRateProduct: ThemeButton!
    {
        didSet {
            btnRateProduct.setTitle(RateType.product.title, for: .normal)
        }
    }
    @IBOutlet weak var btnReturn: UIButton! {
        didSet {
            btnReturn.setTitle("Request Return".localized(), for: .normal)
        }
    }
    @IBOutlet weak var btnDownloadRecipe: UIButton! {
        didSet {
            btnDownloadRecipe.isHidden = /AppSettings.shared.appThemeData?.product_pdf_upload != "1"
            btnDownloadRecipe.setTitle(TerminologyKeys.product_file_upload.localizedValue() as? String, for: .normal)
        }
    }
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelProductmodel: UILabel!
    @IBOutlet weak var labelProductCode: UILabel!
    @IBOutlet weak var labelPrice: UILabel!{
        didSet{
            labelPrice.textColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var stackDetails: UIStackView!
    let documentInteractionController = UIDocumentInteractionController()

    
    var pdfUrl : String?
    var order_price_id : Int?
    var product_id : String?
    var rateProductPressed: EmptyBlock?
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        self.removeFromSuperview()
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: CellIdentifiers.ProductView , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func configureProductView(product : ProductDetailData?, isDelivered: Bool){
        
        defer {
            if /AppSettings.shared.appThemeData?.is_return_request == "1" {
                self.btnReturn.isHidden = isDelivered
            }
            else {
                self.btnReturn.isHidden = true
            }
            self.btnReturn.isUserInteractionEnabled = /product?.return_data?.count == 0
            if /product?.return_data?.count == 0 {
                btnReturn.setTitle("Request Return".localized(), for: .normal)
            }
            else {
                self.btnReturn.setTitle(product?.return_data?.first?.status, for: .normal)
            }

            self.product_id = product?.product_id
            self.order_price_id = product?.order_price_id
            self.pdfUrl = product?.recipe_pdf
            labelTitle.text = product?.name
            labelProductmodel?.text = product?.measuringUnit
            labelQuantity?.text = UtilityFunctions.appendOptionalStrings(withArray: [L10n.Quantity.string,product?.quantity])
            
            var name = ""
            var totalPrice:Double = 0.0
            var totalPriceDouble:Double = (/product?.price?.toDouble())
            
            for addonData in product?.productDetailAddson ?? [] {
                if let addonName = addonData.adds_on_type_name {
                    name = name + "," + addonName
                }
                if let price = addonData.price {
                    if let priceDouble = Double(price) {
                        totalPrice += priceDouble
                    }
                }
            }
            if name.first == "," {
                name.removeFirst()
            }
            if name.last == "," {
                name.removeLast()
            }
            labelPrice.text = (totalPrice + totalPriceDouble).addCurrencyLocale
            labelProductCode?.text = name.count == 0 ? "" : "Addons: " + name
            
            if SKAppType.type == .eCom {
                labelProductmodel.isHidden = AppSettings.shared.isSingleVendor
            }
            
            for view in stackDetails.arrangedSubviews {
               if view is VariantView {
                   view.removeFromSuperview()
               }
           }
           
           for variant in product?.variants ?? [] {
               let variantView = VariantView(frame: CGRect(x: 0, y: 0, w: stackDetails.size.width, h: 16))
               variantView.configureVariant(variant)
               stackDetails.addArrangedSubview(variantView)
           }
        
        }
        
        imageViewProduct.loadImage(thumbnail: product?.image, original: nil)
    }
    
    @IBAction func rateProduct(_ sender: Any) {
        rateProductPressed?()
    }
    
    @IBAction func actionReturn(_ sender: Any) {
        let returnPopupVc = ProductReturnPopupVC.getVC(.moreScreen)
        returnPopupVc.orderPriceId = self.order_price_id
        returnPopupVc.productId = self.product_id
        returnPopupVc.delegate = self
        ez.topMostVC?.presentVC(returnPopupVc)
    }
    
    func updateReturnStatus() {
        self.btnReturn.setTitle("Return Requested".localized(), for: .normal)
        self.btnReturn.isUserInteractionEnabled = false
    }
    
    @IBAction func actionDownloadRecipe(_ sender: Any) {
        guard let url = URL(string: /pdfUrl) else {
             SKToast.makeToast("No file added!".localized())
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.pdf")
            do {
                try data.write(to: tmpURL)
                DispatchQueue.main.async {
                        self.share(url: tmpURL)
                }
            } catch {
                print(error)
            }

        }.resume()

    }
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentOptionsMenu(from: (ez.topMostVC?.view.frame)!, in: ez.topMostVC!.view, animated: true)
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
