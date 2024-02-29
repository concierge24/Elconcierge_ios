
//
//  BarCodeScannerViewController.swift
//  Clikat
//
//  Created by Night Reaper on 19/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BarCodeScannerViewController: CategoryFlowBaseViewController  {

    //MARK:- IBOutlet
    @IBOutlet weak var scannerView: UIView!
   
    //MARK:- Variable
    var codeScannerView = WECodeScannerView()
    var isCompareProducts : Bool = false
    var isScanDone : Bool = false
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            
            self.isScanDone = false
            codeScannerView = WECodeScannerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
            codeScannerView.delegate = self
            scannerView.addSubview(codeScannerView)
            codeScannerView.start()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeScannerView.stop()
    }
    
}

//MARK: - Web Service Methods
extension BarCodeScannerViewController {
    func webService(withBarcode barcode : String?){
        
        guard let code = barcode else{
            return
        }
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.BarCodeSearch(FormatAPIParameters.BarCodeSearch(barCode: code, supplierBranchId: passedData.supplierBranchId).formatParameters())) { [unowned self] (response) in
            switch response{
            case .Success(let listing):
               
                guard let productListing = listing as? BarCodeProductListing , let count = productListing.arrProduct?.count, count > 0  else{
                    UtilityFunctions.showSweetAlert(title: "", message: L10n.NoProductFound.string, style: .Warning, success: {
                    self.popVC()
                    })
                    return
                }
                
                if self.isCompareProducts {
                    let VC = StoryboardScene.Options.instantiateCompareProductResultController()
                    VC.product = productListing.arrProduct?[0]
                    self.pushVC(VC)
                    return
                }
                ez.runThisInMainThread({ 
                    let productDetailVC = StoryboardScene.Main.instantiateProductDetailViewController()
                    productDetailVC.passedData.productId = productListing.arrProduct?[0].id
                    productDetailVC.suplierBranchId = productListing.arrProduct?[0].supplierBranchId
                    self.pushVC(productDetailVC)
                })
                
            default :
                self.isScanDone = false
                self.codeScannerView.start()
                break
            }
        }        
    }
}

//MARK: - Button Actions
extension BarCodeScannerViewController {
    
    @IBAction func actionBack(sender : UIButton?){
        popVC()
    }
    
}

//MARK: - Play Sound

extension BarCodeScannerViewController {
    func beep(){
        WESoundHelper.playSound(fromFile: "BEEP.mp3", from: Bundle.main, asAlert: true)
    }
}


//MARK: - BarCode scanner Delegates
extension BarCodeScannerViewController : WECodeScannerViewDelegate {
    
    func scannerView(_ scannerView : WECodeScannerView, didReadCode code : String){
        if isScanDone {
            return
        }
        
        beep()
        isScanDone = true
        codeScannerView.stop()
        webService(withBarcode: code)
    }
//
    func didScanCode(scannedCode: String!, onCodeType codeType: String!) {
        print(scannedCode)
        print(codeType)

    }
//
    func errorGeneratingCaptureSession(error: NSError!) {
        
        print(error)
    }
    
}
