//
//  ChatAccessory.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 04/08/18.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos
import SwiftyJSON
import DBAttachmentPickerController
import EZSwiftExtensions

protocol SendMessagedDelegate: class {
    func newMessageAppendCall(message: MessageChat)
    func updateUploadingCompleted(with message: MessageChat)
    func updateUploadingFail(with message: MessageChat)
}

class ChatAccessory: UIView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnChat: UIButton!{
        didSet{
            btnChat?.backgroundColor = SKAppType.type.color
            btnChat.imageView?.mirrorTransform()
        }
    }
    @IBOutlet weak var textView: GrowingTextView! {
        didSet {
            textView.delegate = self
            textView.tintColor = .black
            textView.setAlignment()
            textView.placeholder = "Write something".localized()
        }
    }
    @IBOutlet weak var btnAttach: UIButton!{
        didSet{
            btnAttach?.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var indicatorUpload: UIActivityIndicatorView!
    
    
    //MARK:- PROPERTIES
    weak var delegate: SendMessagedDelegate?
    var mediaPicker: DBAttachmentPickerController?
    var messageType: ChatListing?
    var mediaPickerVC: MediaPickerController?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK:- for iPhoneX Spacing bottom
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    //MARK::- FUNCTIONS
    
    func configurePickr(){
        self.btnAttach.isEnabled = false
        indicatorUpload.startAnimating()
        
        
        if PHPhotoLibrary.authorizationStatus() == .authorized &&
            CheckPermission.shared.status(For: .camera) == 3 {
            //both allow
            self.configProceed(isVideo: false, isImage: false, isBoth: true)
        }else{
            //check for camera
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response { //true
                    //check for photos
                    let photos = PHPhotoLibrary.authorizationStatus()
                    if photos == .notDetermined || photos == .denied{
                        PHPhotoLibrary.requestAuthorization({status in
                            if status == .authorized{
                                self.configProceed(isVideo: false, isImage: false, isBoth: true)
                            } else {
                                ez.runThisAfterDelay(seconds: 2.0, after: {
                                    UtilityFunctions.show(alert: "", message: "You need to enable Photos access from app settings to share image".localized(), buttonOk: {
                                        self.btnAttach.isEnabled = true
                                        self.indicatorUpload.stopAnimating()
                                        CheckPermission.shared.openAppSettings()
                                        return
                                    }, buttonCancel: { [weak self] in
                                        self?.configProceed(isVideo: true, isImage: false, isBoth: false)
                                        }, viewController: UIApplication.topViewController()!, buttonText: "ios.ZDCChat.yes".localized(), cancelButtonText: "ios.ZDCChat.no".localized())
                                })
                                
                                
                            }
                        })
                    }else{
                        self.configProceed(isVideo: false, isImage: true, isBoth: false)
                    }
                    
                } else {//false
                    //request access
                    ez.runThisAfterDelay(seconds: 1.0, after: {
                        UtilityFunctions.show(alert: "", message:"You need to enable camera access from app settings to share image from camera".localized() , buttonOk: {
                            self.btnAttach.isEnabled = true
                            self.indicatorUpload.stopAnimating()
                            CheckPermission.shared.openAppSettings()
                            return
                        }, buttonCancel: { [weak self] in
                            let photos = PHPhotoLibrary.authorizationStatus()
                            if photos == .notDetermined || photos == .denied{
                                PHPhotoLibrary.requestAuthorization({ [weak self]  status in
                                    if status == .authorized{
                                        self?.configProceed(isVideo: false, isImage: true, isBoth: false)
                                    } else {
                                        
                                        ez.runThisAfterDelay(seconds: 1.0, after: {
                                            
                                            UtilityFunctions.show(alert: "", message: "Please give permissions from app settings to share media".localized() , buttonOk: {
                                                self?.btnAttach.isEnabled = true
                                                self?.indicatorUpload.stopAnimating()
                                                CheckPermission.shared.openAppSettings()
                                                return
                                            }, buttonCancel: { [weak self] in
                                                self?.btnAttach.isEnabled = true
                                                self?.indicatorUpload.stopAnimating()
                                                
                                                
                                                //                                                UtilityFunctions.show(alert: "", message: "Kindly give permissions from app settings to share media" , buttonOk: {
                                                ////_________________________________________
                                                ////                                                    UtilityFunctions.makeToast(text: "", type: .info)
                                                //                                                }, viewController: UIApplication.topViewController() ?? UIViewController(), buttonText: "Ok")
                                                
                                                //                                                self?.configProceed(isVideo: false, isImage: false, isBoth: false)
                                                }, viewController: UIApplication.topViewController() ?? UIViewController(), buttonText: "okBtn".localized() , cancelButtonText: "Cancel".localized())
                                        })
                                    }
                                })
                            }else{
                                self?.configProceed(isVideo: false, isImage: true, isBoth: false)
                            }
                            
                            }, viewController: UIApplication.topViewController()!, buttonText: "ios.ZDCChat.yes".localized(), cancelButtonText: "ios.ZDCChat.no".localized())
                    })
                }
            }
        }
        
    }
    
    
    func configProceed(isVideo: Bool?, isImage: Bool?, isBoth: Bool?){
        
        mediaPicker = DBAttachmentPickerController.init(finishPicking: { (attachement) in
            self.mediaPicked(mediaArray: attachement)
        }, cancel: {
            
        })
        if /isVideo {
            mediaPicker?.mediaType = [   .image , .video , .other]
            openDBAttachmentMediaPicker()
        }
        if /isImage {
            openCustomPhotosPicker()
        }
        if /isBoth {
            mediaPicker?.mediaType = [.image  , .video , .other]
            openDBAttachmentMediaPicker()
        }
        
        if !(/isVideo) && !(/isImage) && !(/isBoth) {
            mediaPicker?.mediaType = [ .other]
            openDBAttachmentMediaPicker()
        }
        
    }
    
    func openDBAttachmentMediaPicker(){
        
        mediaPicker?.allowsMultipleSelection = false
        mediaPicker?.allowsSelectionFromOtherApps = true
        
        ez.runThisInMainThread { [ unowned self] in
            self.btnAttach.isEnabled = true
            self.indicatorUpload.stopAnimating()
            guard let vc = UIApplication.topViewController() else { return }
            self.mediaPicker?.present(on: vc.self)
        }
    }
    
    func openCustomPhotosPicker(){
        btnAttach.isEnabled = true
        indicatorUpload.stopAnimating()
        openMediaPicker()
    }
    
    
    
    
    func sendInfo(_ sender: UIButton){
        switch sender.tag {
        case 0: //Attach
            self.textView.resignFirstResponder()
            self.configurePickr()
            
            
            //use this code if you want to share other detailed modal
            //here is example of sharing a property in chat
            
//            UtilityFunctions.show(nativeActionSheet: "", subTitle: "", vc: UIApplication.topViewController(), senders: ["Share property", "Share Media"]) { [weak self] (value, index) in
//                switch index{
//                case 0:
//                    let vc = StoryboardScene.Search.searchHomeViewController.instantiate()
//                    vc.isChat = true
//                    vc.isLocSearch = false
//                    UIApplication.topViewController()?.pushVC(vc)
//                default:
//                    self?.configurePickr()
//                }
//            }
            
            
            
            
        case 1: //Send Txt Message
            if (/textView.text).trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                let msg = MessageChat.init(userID: "", message: (/textView.text).trimmingCharacters(in: .whitespacesAndNewlines), image: nil, video: nil, atch: nil, type: .Text, messageID: UUID().uuidString)
                delegate?.newMessageAppendCall(message: msg )
                self.sendMessage(messageModal: msg, chatId: /self.messageType?.convoId , message: /msg.message, messageType: "1" , image:  "" , video: "")
                self.textView.text = nil
            }
            
        default: break
        }
    }
    
    //MARK:- IBAction
    @IBAction func btnAction(_ sender: UIButton) {
        if !isConnectedToNetwork(){
            SKToast.makeToast("You need to enable internet connection".localized())
            return
        }
        sendInfo(sender)
    }
}

//MARK:- Growing TextView Delegate
extension ChatAccessory: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        // invalidateIntrinsicContentSize()
        // https://developer.apple.com/documentation/uikit/uiview/1622457-invalidateintrinsiccontentsize
        // to reflect height changes
        textView.invalidateIntrinsicContentSize()
    }
}

//MARK:- ChatAccessory Functions
extension ChatAccessory {
    
    //MARK:- Media Selected
    func mediaPicked(mediaArray: [DBAttachment]) {
        
        guard let type = mediaArray.first?.mediaType else { return }
        switch type {
        case .image:
            
            mediaArray.first?.loadOriginalImage(completion: { (img) in
                let imgData = (img ?? UIImage()).jpegData(compressionQuality: 1)?.count
                let mbs = /imgData?.toDouble / (1048576.0)
                if mbs > 25.0 {
                    SKToast.makeToast("The file you have selected is too large, the max size is 25MB".localized())
                    return
                }
                let imageModel = MessageImage.init(image: img, url: "")
                let message = MessageChat.init(userID: "", message: nil, image: imageModel, video: nil, atch: nil, type: .Image, messageID: UUID().uuidString)
                self.delegate?.newMessageAppendCall(message:message)
                self.uploadImage(image: [img ?? UIImage() ], message: message)
            })
            
        case .video:
            
            if let phAsset = mediaArray.first?.originalFileResource() as? PHAsset  {
                PHCachingImageManager().requestAVAsset(forVideo: phAsset, options: PHVideoRequestOptions(), resultHandler: { (asset, audiomix, info) in
                    let asset = asset as? AVURLAsset
                    do {
                        let data = try Data(contentsOf: (asset?.url)!)
                        
                        let videoMb = data.count.toDouble / (1048576.0)
                        print("=======Video Size======" , videoMb)
                        if videoMb > 25.0 {
                            SKToast.makeToast("The file you have selected is too large, the max size is 25MB".localized())
                            return
                        }
                        let videoModel = MessageVideo.init(url: asset?.url.absoluteString, data: data, thumb: (asset?.url)!.generateThumbnailChat())
                        let message = MessageChat.init(userID: nil, message: nil, image: nil, video: videoModel, atch: nil, type: .Video, messageID: UUID().uuidString)
                        self.uploadVideo(message: message)
                        self.delegate?.newMessageAppendCall(message: message)
                    } catch _ { }
                })
            } else if let urlString = mediaArray.first?.originalFileResource() as? String {
                let url = URL(fileURLWithPath: urlString)
                     //  URL(fileURLWithPath: /(mediaArray.first?.originalFileResource() as? String)) {
               do {
                   let data = try? Data(contentsOf: url)
                   let videoMb = /data?.count.toDouble / (1048576.0)
                   if videoMb > 25.0 {
                       SKToast.makeToast("The file you have selected is too large, the max size is 25MB".localized())
                       return
                   }
                   let videoModel = MessageVideo.init(url: url.absoluteString , data: data, thumb: url.generateThumbnail())
                   let message = MessageChat.init(userID: nil, message: nil, image: nil, video: videoModel, atch: nil, type: .Video , messageID: UUID().uuidString)
                   self.uploadVideo(message: message)
                   self.delegate?.newMessageAppendCall(message: message)
               } catch _ { }
           }

            
        case .other:
            let url = URL(fileURLWithPath: /(mediaArray.first?.originalFileResource() as? String))
            let data = try? Data(contentsOf: url, options: [])
            
            let videoMb = /data?.count.toDouble / (1048576.0)
            print("=======Document Size======" , videoMb)
            if videoMb > 25.0 {
                SKToast.makeToast("The file you have selected is too large, the max size is 25MB".localized())
                return
            }
            let docModel = MessageDoc.init(url: url.description, data: data, fileName: mediaArray.first?.fileName)
            let message = MessageChat.init(userID: "", message: nil, image: nil, video: nil, atch: docModel, type: .Attachement, messageID: UUID().uuidString)
            self.uploadDocument(message: message)
            self.delegate?.newMessageAppendCall(message: message)
        default:
            break
        }
    }
    
    // Performs the initial setup.
    private func setupView() {
        
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        // to dynamically increase height of text view
        // http://ticketmastermobilestudio.com/blog/translating-autoresizing-masks-into-constraints
        //if textView.translatesAutoresizingMaskIntoConstraints = true then height will not increase automatically
        // translatesAutoresizingMaskIntoConstraints default = true
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}


//MARK::- API HANDLER
extension ChatAccessory {
    
    func uploadImage(image:[UIImage], message: MessageChat , propertyId: String = ""){
        //S3 upload class is in ChatModel
        //uncomment the code if you want to share image
//        Upload.postRequestWithImages(type: .Image  , withApi: APIConstants.uploadImage, parameters: [:], images: image, success: { [ weak self ] (data, code) in
//            self?.delegate?.updateUploadingCompleted(with: message)
//            self?.sendMessage(messageModal: message ,chatId: /self?.messageType?.convoId , message: /message.message, messageType: "2" , image: data as? String ?? "" , video: "" , propertyId: propertyId)
//            }, failure: { [ weak self ]  (error) in
//                self?.delegate?.updateUploadingFail(with: message)
//                ez..show(alert: .oops, message:  error , type: .error)
//            }, header: [:])
    }
    
    //API HIT TO SEND MESSAGE
    
    func sendProperty(messageModal: MessageChat ,propertyId: String?){
        let msg = messageModal
        msg.propertyId = propertyId
        self.sendMessage(messageModal: msg , chatId: /messageType?.convoId , message: /messageModal.message , messageType: "5" , image: /messageModal.image?.url , video: "" , propertyId: /propertyId)
    }
    
    func sendMessage(messageModal: MessageChat , chatId: String , message: String , messageType: String , image: String , video: String , attachmentName: String = "" , attahment: String = "" , propertyId: String = ""){
        
        //send message thru socket
//        let date = calculateTime(time: )
        let date = /Date().changeFormat(newFormat: "yyyy-MM-dd HH:mm:ss")
        print(date)
        let dict = ["chat_type":"text","text": /message , "type" : "1" , "order_id": /UserData.share.currentConversationId , "receiver_created_id": /UserData.share.currentAgentId , "sent_at" : date  , "offset": TimeZone.current.offsetInHours()]
        SocketIOManager.shared.addMessage(dict)
        
        //do in case of api
//        ChatEndPoint.sendMessage(convoId: chatId, message: message, messageType: messageType , image: image, video: video, attachmentName: attachmentName, attachment: attahment, propertyId: propertyId).request(isImage: false, images: [], isLoaderNeeded: false , header: ["Authorization":"Bearer " + /GDataSingleton.sharedInstance.loggedInUser?.token ]) { [ weak self ] (response) in
//            switch response{
//            case .success(let response):
//                guard let msg = response as? MessageChat else { return }
//                messageModal.propertyId = msg.propertyId
//                messageModal.video = msg.video
//                messageModal.attachement = msg.attachement
//                self?.delegate?.updateUploadingCompleted(with: messageModal)
//            case .failure(let str):
//                self?.sendMessage(messageModal: messageModal ,chatId: chatId , message: message , messageType: messageType, image: image, video: video, propertyId: propertyId)
//                ez..show(alert: .oops, message:  str as? String , type: .error)
//            }
//        }
    }
    
    func uploadVideo( message: MessageChat){
        guard let thumbImage = message.video?.thumbnail as? UIImage else { return }
//        Upload.sendVideo(video: message.video?.data, header: [:] , image: thumbImage , parameters: [:], success: { [ weak self ] (video,thumb) in
//            print(video)
//            print(thumb)
//
//            //            self?.delegate?.updateUploadingCompleted(with: message)
//            self?.sendMessage(messageModal: message , chatId: /self?.messageType?.convoId , message: /message.message, messageType: "3" , image: /thumb  , video: /video)
//            }, failure: { [ weak self] (error) in
//                self?.delegate?.updateUploadingFail(with: message)
//                ez..show(alert: .oops, message:  error.localizedDescription , type: .error)
//            }, url: APIConstants.basePath + APIConstants.saveVideo)
        
        
    }
    
    
    func uploadDocument( message: MessageChat){
        guard let doc = message.attachement else { return }
//        Upload.uploadDocument(doc:  doc , parameters: [:], success: { [weak self] (attachment) in
//            print(attachment)
//            self?.sendMessage(messageModal: message ,chatId: /self?.messageType?.convoId , message: /message.message, messageType: "4" , image: "" , video:  "", attachmentName: /doc.fileName , attahment: /attachment )
//            }, failure: { [ weak self ] (error) in
//                self?.delegate?.updateUploadingFail(with: message)
//                ez..show(alert: .oops, message:  error.localizedDescription , type: .error)
//            }, url: APIConstants.basePath + APIConstants.saveDocs)
    }
    
    
}


extension ChatAccessory : MediaPickerControllerDelegate {
    
    
    /** Pick photo **/
    func openMediaPicker() {
        
        ez.runThisInMainThread { [ unowned self] in
            self.btnAttach.isEnabled = true
            self.indicatorUpload.stopAnimating()
        }
        mediaPickerVC = MediaPickerController(type: .imageOnly, presentingViewController: UIApplication.topViewController() ?? UIViewController())
        mediaPickerVC?.delegate = self
        mediaPickerVC?.show()
    }
    
    func mediaPickerControllerDidPickImage(_ img: UIImage) {
        let imgData = (img ?? UIImage()).jpegData(compressionQuality: 1)?.count
        let mbs = /imgData?.toDouble / (1048576.0)
        if mbs > 25.0 {
            SKToast.makeToast("The file you have selected is too large, the max size is 25MB".localized())
            return
        }
        let imageModel = MessageImage.init(image: img, url: "")
        let message = MessageChat.init(userID: "", message: nil, image: imageModel, video: nil, atch: nil, type: .Image, messageID: UUID().uuidString)
        self.delegate?.newMessageAppendCall(message:message)
        self.uploadImage(image: [img ?? UIImage() ], message: message)
    }
    
}


public enum MediaPickerControllerType {
    case imageOnly
    case imageAndVideo
    case videoOnly
}

@objc public protocol MediaPickerControllerDelegate {
    @objc optional func mediaPickerControllerDidPickImage(_ image: UIImage)
    @objc optional func mediaPickerControllerDidPickVideo(url: URL, data: Data, thumbnail: UIImage)
}
typealias DidPickImage = (_ image: UIImage) -> ()

open class MediaPickerController: NSObject {
    
    // MARK: - Public
    open weak var delegate: MediaPickerControllerDelegate?
    var didSelectImage: DidPickImage?
    // MARK: - Private
    fileprivate let presentingController: UIViewController
    fileprivate let type: MediaPickerControllerType
    let mediaPicker: UIImagePickerController
    
    public init(type: MediaPickerControllerType, presentingViewController controller: UIViewController) {
        self.type = type
        self.presentingController = controller
        self.mediaPicker = UIImagePickerController()
        super.init()
        self.mediaPicker.delegate = self
    }
    
    open func show() {
        let actionSheet = self.optionsActionSheet
        self.presentingController.present(actionSheet, animated: true, completion: nil)
    }
    
    open func openCameraForImageAndVideo() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied {
            self.presentingController.alertBoxOkCancel(message: "Camera Denied".localized(), title: "Permission Denied".localized() , ok: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        } else {
            self.mediaPicker.sourceType = UIImagePickerController.SourceType.camera
            self.mediaPicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
        }
    }
    
    open func openGalleryToPickVideoAndImage() {
        if PHPhotoLibrary.authorizationStatus() == .denied {
            self.presentingController.alertBoxOkCancel(message: "Media Picker Denied".localized(), title: "Permission Denied".localized(), ok: {
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
        } else {
            self.mediaPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.mediaPicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
        }
    }
    func showImagePicker(selected: @escaping DidPickImage) {
        
        let actionSheet = self.optionsActionSheet
        self.didSelectImage = selected
        self.presentingController.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
}

extension MediaPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss()
        let mediaType = info[.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            let chosenImage = info[.originalImage] as! UIImage
            
            self.delegate?.mediaPickerControllerDidPickImage?(chosenImage.fixOrientation())
            if let item = didSelectImage {
                item(chosenImage.fixOrientation())
            }
        } else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
            // Is Video
            let url: URL = info[.mediaURL] as! URL
            let chosenVideo = info[.mediaURL] as! URL
            let videoData = try! Data(contentsOf: chosenVideo, options: [])
            let thumbnail = url.generateThumbnailChat()
            self.delegate?.mediaPickerControllerDidPickVideo?(url: url, data: videoData, thumbnail: thumbnail)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss()
    }
    
    // MARK: - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}

// MARK: - Private
private extension MediaPickerController {
    
    var optionsActionSheet: UIAlertController {
        let actionSheet = UIAlertController(title: Strings.Title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        self.addChooseExistingMediaActionToSheet(actionSheet)
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            switch self.type {
            case .imageAndVideo:
                self.addTakePhotoActionToSheet(actionSheet)
                self.addTakeVideoActionToSheet(actionSheet)
            case .imageOnly:
                self.addTakePhotoActionToSheet(actionSheet)
            case .videoOnly:
                self.addTakeVideoActionToSheet(actionSheet)
            }
        }
        self.addCancelActionToSheet(actionSheet)
        return actionSheet
    }
    
    func addChooseExistingMediaActionToSheet(_ actionSheet: UIAlertController) {
        let chooseExistingAction = UIAlertAction(title: self.chooseExistingText, style: UIAlertAction.Style.default) { (_) -> Void in
            if PHPhotoLibrary.authorizationStatus() == .denied {
                self.presentingController.alertBoxOkCancel(message: "Media Picker Denied".localized(), title: "Permission Denied".localized() , ok: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
            } else {
                self.mediaPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.mediaPicker.mediaTypes = self.chooseExistingMediaTypes
                self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(chooseExistingAction)
    }
    
    func addTakePhotoActionToSheet(_ actionSheet: UIAlertController) {
        let takePhotoAction = UIAlertAction(title: Strings.TakePhoto, style: UIAlertAction.Style.default) { (_) -> Void in
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied {
                self.presentingController.alertBoxOkCancel(message: "Camera Denied".localized(), title: "Permission Denied".localized(), ok: {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })
            } else {
                self.mediaPicker.sourceType = UIImagePickerController.SourceType.camera
                self.mediaPicker.mediaTypes = [kUTTypeImage as String]
                self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(takePhotoAction)
    }
    
    func addTakeVideoActionToSheet(_ actionSheet: UIAlertController) {
        let takeVideoAction = UIAlertAction(title: Strings.TakeVideo, style: UIAlertAction.Style.default) { (_) -> Void in
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied {
                self.presentingController.alertBoxOkCancel(message: "Camera Denied".localized(), title: "Permission Denied".localized() , ok: {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })
            } else {
                self.mediaPicker.sourceType = UIImagePickerController.SourceType.camera
                self.mediaPicker.mediaTypes = [kUTTypeMovie as String]
                self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(takeVideoAction)
    }
    
    func addCancelActionToSheet(_ actionSheet: UIAlertController) {
        let cancel = Strings.Cancel
        let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel, handler: nil)
        actionSheet.addAction(cancelAction)
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.presentingController.dismiss(animated: true, completion: nil)
        }
    }
    
    var chooseExistingText: String {
        switch self.type {
        case .imageOnly: return Strings.ChoosePhoto
        case .imageAndVideo: return Strings.ChoosePhotoOrVideo
        case .videoOnly: return Strings.ChooseVideo
        }
    }
    
    var chooseExistingMediaTypes: [String] {
        switch self.type {
        case .imageOnly: return [kUTTypeImage as String]
        case .imageAndVideo: return [kUTTypeImage as String, kUTTypeMovie as String]
        case .videoOnly: return [kUTTypeMovie as String]
        }
    }
    
    // MARK: - Constants
    
    struct Strings {
        static let Title = NSLocalizedString("Attach image from".localized(), comment: "Title for a generic action sheet for picking media from the device.".localized())
        static let ChoosePhoto = NSLocalizedString("Gallery".localized(), comment: "Text for an option that lets the user choose an existing photo in a generic action sheet for picking media from the device.".localized())
        static let ChoosePhotoOrVideo = NSLocalizedString("Choose existing photo or video".localized(), comment: "Text for an option that lets the user choose an existing photo or video in a generic action sheet for picking media from the device.".localized())
        static let TakePhoto = NSLocalizedString("Camera".localized(), comment: "Text for an option that lets the user take a picture with the device camera in a generic action sheet for picking media from the device.".localized())
        static let TakeVideo = NSLocalizedString("Take a video".localized(), comment: "Text for an option that lets the user take a video with the device camera in a generic action sheet for picking media from the device.".localized())
        static let Cancel = NSLocalizedString("Cancel".localized(), comment: "Text for the 'cancel' action in a generic action sheet for picking media from the device.".localized())
        static let ChooseVideo = NSLocalizedString("Choose Video".localized(), comment: "Choose Video".localized())
    }
    
}

public extension URL {
    
    func generateThumbnailChat() -> UIImage {
        let asset = AVAsset(url: self)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = 0
        let imageRef = try? generator.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: imageRef!)
        return thumbnail
    }
    
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}


class ChatTable: UITableView {
    
    lazy var inputAccessory: ChatAccessory = {
        let rect = CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width, height: 192)
        let inputAccessory = ChatAccessory(frame: rect)
        return inputAccessory
    }()
    
    override var inputAccessoryView: UIView? {
        return inputAccessory
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.keyboardDismissMode = .interactive
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.contentInset.bottom = keyboardHeight
            if keyboardHeight > 100 {
                scrollToBottom()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.contentInset.bottom = keyboardHeight
        }
    }
}

//MARK:- Scroll to bottom function
extension UITableView {
    func scrollToBottom(animated: Bool = true, scrollPostion: UITableView.ScrollPosition = .bottom) {
        let no = self.numberOfRows(inSection: 0)
        if no > 0 {
            let index = IndexPath(row: no - 1, section: 0)
            scrollToRow(at: index, at: scrollPostion, animated: animated)
        }
    }
}

extension UITableView {
    func sizeHeaderToFit() {
        guard let headerView = self.tableHeaderView else { return }
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height 
        headerView.frame = frame 
        self.tableHeaderView = headerView
    }
    
    func registerXIB(_ nibName: String) {
        self.register(UINib.init(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func registerXIBForHeaderFooter(_ nibName: String) {
        self.register(UINib.init(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
    }
}
