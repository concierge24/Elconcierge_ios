//
//  ScannerViewController.swift
//  Trava
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController:  UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var labelText: UILabel!
    
 /* @IBOutlet weak var previewView: QRCodeReaderView! {
    didSet {
      previewView.setupComponents(with: QRCodeReaderViewControllerBuilder {
        $0.reader                 = reader
        $0.showTorchButton        = false
        $0.showSwitchCameraButton = false
        $0.showCancelButton       = false
        $0.showOverlayView        = true
        $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
      })
    }
  } */
    
    var delegate: BookRequestDelegate?
    
  lazy var reader: QRCodeReader = QRCodeReader()
  lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
      $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
      $0.showTorchButton         = false
      $0.preferredStatusBarStyle = .lightContent
      $0.showOverlayView         = true
      $0.showSwitchCameraButton = false
      $0.showCancelButton       = false
      $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
      
      $0.reader.stopScanningWhenCodeIsFound = true
    }
    
    return QRCodeReaderViewController(builder: builder)
  }()

    override func viewDidLoad() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initialSetup()
    }
    
    func initialSetup() {
        
        guard checkScanPermissions() else { return }

        readerVC.modalPresentationStyle = .overFullScreen
        readerVC.delegate               = self

        labelText.isHidden = false
        
        readerVC.completionBlock = {[weak self] (result: QRCodeReaderResult?) in
          if let result = result {
            print("Completion with result: \(result.value) of type \(result.metadataType)")
            
            DispatchQueue.main.async {[weak self] in
               // self?.reader.stopScanning()
                self?.readerVC.stopScanning()
                debugPrint(result.value)
            }
            
             self?.apiGetDriverDetails(driverId: /result.value)
          }
        }

        readerVC.view.frame = cameraView.bounds
        cameraView.addSubview(readerVC.view)
        
       // present(readerVC, animated: true, completion: nil)
    }
    
  // MARK: - Actions

  private func checkScanPermissions() -> Bool {
    do {
      return try QRCodeReader.supportsMetadataObjectTypes()
    } catch let error as NSError {
      let alert: UIAlertController

      switch error.code {
      case -11852:
        alert = UIAlertController(title: "AppName".localizedString, message: "You've forcefully denied Camera service. Please enable to continue.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
          DispatchQueue.main.async {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.openURL(settingsURL)
            }
          }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      default:
        alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      }

      present(alert, animated: true, completion: nil)

      return false
    }
  }

    @IBAction func buttonCancelClicked(_ sender: Any) {
      //  reader.stopScanning()
        
        readerVC.stopScanning()
        dismissVC(completion: nil)
    }
    
    
 /* @IBAction func scanInModalAction(_ sender: AnyObject) {
    guard checkScanPermissions() else { return }

    readerVC.modalPresentationStyle = .overFullScreen
    readerVC.delegate               = self

    readerVC.completionBlock = { (result: QRCodeReaderResult?) in
      if let result = result {
        print("Completion with result: \(result.value) of type \(result.metadataType)")
      }
    }

    present(readerVC, animated: true, completion: nil)
  } */

/*  @IBAction func scanInPreviewAction(_ sender: Any) {
    guard checkScanPermissions(), !reader.isRunning else { return }

    reader.didFindCode = { result in
      print("Completion with result: \(result.value) of type \(result.metadataType)")
    }

    reader.startScanning()
  } */

}

extension ScannerViewController {
    
    func apiGetDriverDetails(driverId: String?) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.scanQrCode(user_id: driverId)
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token,"secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(let data):
                debugPrint("Successs")
                
                guard let modal = data as? RoadPickupModal else{return}
                
                DispatchQueue.main.async { [weak self] in
                    self?.dismissVC(completion: nil)
                    self?.delegate?.didScanRoadPickUPQRCode(object: modal)
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
}


// MARK: - QRCodeReaderViewControllerDelegate Methods


extension ScannerViewController: QRCodeReaderViewControllerDelegate  {
    

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
     
        
     /* dismiss(animated: true) { [weak self] in
        let alert = UIAlertController(
          title: "QRCodeReader",
          message: String (format:"%@ (of type %@)", result.value, result.metadataType),
          preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self?.present(alert, animated: true, completion: nil)
      } */
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
     // print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
     // reader.stopScanning()

     // dismiss(animated: true, completion: nil)
    }
}
