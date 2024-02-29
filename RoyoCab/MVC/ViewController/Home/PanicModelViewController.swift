
import UIKit
import Kingfisher
import IBAnimatable
import AVFoundation
import CoreLocation
import SwiftyJSON
import AVKit

protocol SeviceRequestDelegate: class {
    func acceptedRequest()
}

struct currentPopRequest {
    static var arrAllRequest = [ServiceRequest?]()
    static var requests = [String: ServiceRequest?]()
}

class PanicModelViewController: UIViewController {
    //MARK: ---------------Outlets-------------
   
    @IBOutlet weak var leftImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var rightImageViewLeading: NSLayoutConstraint!
  
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var leftImageView: AnimatableImageView!
    @IBOutlet weak var rightImageView: AnimatableImageView!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: AnimatableButton!
   
    
    //MARK: ---------------Variables-------------
    
    var serviceRequest : ServiceRequest?
    weak var delegate: SeviceRequestDelegate?
    
    //MARK: ---------------ViewController LifeCycle Functions-------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.rightImageView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.leftImageView.addGestureRecognizer(swipeLeft)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @objc func handleSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                
                debugPrint("Swiped right")
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.rightImageViewLeading.constant = self.btnAccept.frame.width - self.rightImageView.frame.width
                    self.view.updateConstraintsIfNeeded()
                    self.view.layoutIfNeeded()
                }) { [weak self] (true) in
                    self?.apiPanic()
                }
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                
            case UISwipeGestureRecognizer.Direction.left:
                
                debugPrint("Swiped left")
                UIView.animate(withDuration: 1.0, animations: {
                    self.leftImageViewLeading.constant = -(self.btnReject.frame.width - self.leftImageView.frame.width)
                    self.view.updateConstraintsIfNeeded()
                    self.view.layoutIfNeeded()
                }) { [weak self] (true) in
                    self?.removeChildViewController()
                }
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    deinit {
        
    }
    
    
    //MARK: ---------------To dismiss service request view when tapped outside-------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == viewOuter {
            removeChildViewController()
        }
    }
    
}

//MARK:- API
extension PanicModelViewController {
    
    func apiPanic() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.panic
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(_):
                debugPrint("Successs")
                
                self?.removeChildViewController()
                Alerts.shared.show(alert: "AppName".localizedString, message: "Please wait. we'll contact you shortly.".localizedString , type: .success )
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
}
