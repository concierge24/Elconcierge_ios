//
//  chatVC.swift
//  Buraq24
//
//  Created by Apple on 05/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

import IQKeyboardManager
enum CallType : String {
    case Audio = "0"
    case Video = "1"
}
enum ChatMessageType : Int {
    case Text  = 1
    case Attachment = 2
    case Audio = 3
    case Video = 4
}
class ChatVC: BaseVCCab {
    
    //MARK:- Properties
    var otherUserId:String?
    var otherUserDetailId:String?
    //MARK:- Properties\
    var driverDtaGet = driverDta()
    var uploadDta : imgeUpload?
    var chatDta :[Chat]?
    var name : String = ""
    var profilePic : String = ""
    var tableDataSource : TableViewDataSourceCab?
    
    //OUTLETS
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet weak var txtMsg: TextViewplaceholder!{
        didSet{
            txtMsg.placeholder = "typeHere".localizedString
        }
    }
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnOpenGallery: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtInputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewNavigation: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // SocketIOManager.shared.initialiseSocketManager()
        btnSend.addTarget(self, action: #selector(btnSendAct(_:)), for: .touchUpInside)
        if #available(iOS 16.0, *) {
            btnOpenGallery.addTarget(self, action: #selector(btnOpenGalleryAct(_:)), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        btnAudio.addTarget(self, action: #selector(btnAudioAct(_:)), for: .touchUpInside)
        getChatDta()
//        imgProfile.sd_setImage(with:URL(string:  "\(APIBasePath.basePath)/" + "images/" + self.profilePic), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
        imgProfile.sd_setImage(with:URL(string: self.profilePic), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
        var name = self.name
        
        if name.components(separatedBy: " ") != nil {
            name = /name.components(separatedBy: " ").first
        }
        else {
            name = self.name
        }
        
        lblName.text = name
        
        configureTableView()
        emitRecieve()
        viewNavigation.setViewBackgroundColorHeader()
        btnSend.setButtonWithTintColorHeaderText()
        
        addKeyboardWillShowNotification()
        addKeyboardWillHideNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    deinit {
        removeKeyboardWillHideNotification()
        removeKeyboardWillShowNotification()
    }
    
    //MARK: - Update Chat Array
    func updateChat(_ messages: [Chat]) {
        self.tableDataSource?.items = messages
        self.tblView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            guard let self = self else { return }
            if self.tblView.contentSize.height < self.tblView.frame.height {
                return
            }
            self.scrollToBottom()
        }
    }
}

//MARK:- VIDEO CALL VC DELEGATES
extension ChatVC /*VideoCallVcCallStatusDelegates */ {
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.chatDta?.count != 0{
                let indexPath = IndexPath(row: /self.chatDta?.count-1, section: 0)
                self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    func didDisconnectCall(callType: Int, isMissedCall: Bool) {
        //        let chatMessage = ChatVC()
        //        chatMessage.msg_type = callType
        //        chatMessage.is_missed = isMissedCall ? 1 : 0
        //        chatMessage.user_id = /UserSingleton.shared.loggedInUser?.data?.user_id
        //        chatMessage.created_at = Date().toGlobalTime().dateToString(currentFormat: EnumDateFormat.yyyyMMddHHmmssZ.rawValue, newFormat:  EnumDateFormat.yyyyMMddHHmmss.rawValue)
        //        arrChatMessages?.append(chatMessage)
        //        tableView.reloadData()
        //        tableView.scrollToRow(at: IndexPath(row: /arrChatMessages?.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func consultationTimeOver() {
        
        Timer.runThisAfterDelay(seconds: 1.0) {
            self.view.endEditing(true)
        }
        //        tableView.reloadData()
        //        UtilityFunctions.showAlertMessage(alert: R.string.localizable.note(), message: R.string.localizable.yourConsultationTimeGotOver(), viewController: self, buttonText: R.string.localizable.ok())
        
    }
    
}
//MARK:- EXTERNAL FUNCTION

extension ChatVC{
    @objc func btnAudioAct(_ sender : UIButton){
        //   hitApiMakeCall()
        /*let vc = R.storyboard.main.videoCallVC()
         vc?.callType = CallType.Audio.rawValue
         vc?.kSessionId = otherUserId
         vc?.name = name
         vc?.delegate = self
         // vc?.timeLeft = self.timeLeft
         self.present(vc!, animated: true, completion: nil)*/
        
//        guard let vc = R.storyboard.main.voipViewController() else { return }
//        vc.caller = Caller(name: /name, userId: /otherUserId)
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    /*func hitApiMakeCall() {
     let token = /UDSingleton.shared.userData?.userDetails?.accessToken
     let purchasedTokenList = BookServiceEndPoint.makeCall("1", "\(otherUserId)")
     
     purchasedTokenList.request(header: ["access_token" :  "\(token)"]) { [weak self] (response)  in
     switch response{
     case .success(let responseValue):
     let dta = responseValue as! MakeCallModel
     sessionId = /dta.session_id
     
     guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
     
     print("appdelegate is missing")
     return
     }
     appdelegate.callManager.startCall(handle: "user")
     //   self?.handleResponse(response: responseValue as! Response)
     
     case .failure(let err):
     Alerts.shared.show(alert: "AppName".localizedString, message: /err , type: .error )
     }
     }
     //        APIManager.shared.request(with: HomeEndpoint.makeCall(chat_id: /chatID), isLoaderNeeded : false , completion: { (response) in
     //            self.handleResponse(response: response)
     //        }, header: ["authorization" : "Bearer \(/UserData.share.accessToken)"])
     }*/
    
    @available(iOS 16.0, *)
    @objc func btnOpenGalleryAct(_ sender : UIButton){
        
        CameraImage.shared.captureImage(from: self, At: tblView , mediaType: nil, captureOptions: [.camera, .photoLibrary], allowEditting: true) { [unowned self] (image) in
            guard let img = image else { return }
            let token = /UDSingleton.shared.userData?.userDetails?.accessToken

            let objEdit = BookServiceEndPoint.uploadImge
            objEdit.request(isImage: true, images: [img], isLoaderNeeded: true, header: ["access_token" :  token]) {[weak self] (response) in
                switch response {
                case .success(let data):
                    print(data as Any)
                    let userId = /UDSingleton.shared.userData?.userDetails?.userDetailId
                    
                    self?.uploadDta = data as? imgeUpload
                    if /self?.txtMsg.text != "Type Message"{
                        SocketIOManagerCab.shared.sendChatsMessage(userDetailId: "\(userId)", text: /self?.txtMsg.text!, to: /self?.otherUserId, sendAt: "2019-01-12 3:27:10", originalIMage: "", thumbnailImage: "",chat_type : "image")
                    }else{
                        SocketIOManagerCab.shared.sendChatsMessage(userDetailId: "\(userId)", text: "", to: /self?.otherUserId, sendAt: "2019-01-12 3:27:10", originalIMage: "\(APIBasePath.basePath)/" + "images/" + (self?.uploadDta?.original)!, thumbnailImage: APIBasePath.basePath + "/images/" + /self?.uploadDta?.thumbnail,chat_type : "image")
                    }
                    let dte = Date()
                    let format = DateFormatter()
                    format.timeZone = TimeZone.current
                    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dteGet = format.string(from: dte) as AnyObject
                    let time = Utility.dteGetConvert(string: dteGet as! String, fromFormat: "yyyy-MM-dd HH:mm:ss", "HH:mm")
                    let chat = Chat(cid: 0, conversationId: 0, send_to: Int(/self?.otherUserId), send_by: /UDSingleton.shared.userData?.userDetails?.userId, text: "", sent_at: time,original : /self?.uploadDta?.original,thumbnail : /self?.uploadDta?.thumbnail,chat_type : "image")
                    self?.chatDta?.append(chat)
                    self?.updateChat(self?.chatDta ?? [])

                case .failure(let strError):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
        }
    }
    
    @objc func btnSendAct(_ sender : UIButton){
        txtMsg.text = txtMsg.text.trailingSpacesTrimmed
        txtMsg.text = txtMsg.text.removingLeadingSpaces()
        
        let userId = /UDSingleton.shared.userData?.userDetails?.userDetailId
        
        
        if txtMsg.text != "" && txtMsg.textColor != UIColor.lightGray && txtMsg.text != txtMsg.placeholder! {
            SocketIOManagerCab.shared.sendChatsMessage(userDetailId: /otherUserDetailId, text: /txtMsg.text, to: /otherUserId, sendAt: "2019-01-12 3:27:10", originalIMage: "", thumbnailImage: "",chat_type : "text")
            let dte = Date()
            let format = DateFormatter()
            format.timeZone = TimeZone.current
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dteGet = format.string(from: dte) as AnyObject
            let time = Utility.dteGetConvert(string: dteGet as! String, fromFormat: "yyyy-MM-dd HH:mm:ss", "HH:mm")
            let chat = Chat(cid: 0, conversationId: 0, send_to: Int(/otherUserId), send_by: /UDSingleton.shared.userData?.userDetails?.userId, text: /self.txtMsg.text!, sent_at: dteGet as? String,original : nil,thumbnail : nil,chat_type : "text")
            chatDta?.append(chat)
            //configureTableView()
            //scrollToBottom()
            updateChat(chatDta ?? [])
            txtMsg.text = ""
            
        }
        
        
        
    }
}
//MARK:- DATA SOURCE FUNCTION
extension ChatVC{
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            guard let object  = self?.chatDta?[indexpath.row] else  {return}
            if /object.send_by == UDSingleton.shared.userData?.userDetails?.userId!{
                if /object.chat_type == "text"{
                    if let cell = cell as? chatRightTVC {
                        cell.lblChatMsg.text = /object.text
                        let dteGet = Utility.dteGetConvert(string: /object.sent_at, fromFormat: "yyyy-MM-dd HH:mm:ss", "HH:mm")
                        cell.lblTime.text = dteGet
                    }
                }else{
                    if let cell = cell as? chatImgeRightTVC {
                        cell.imgeViewRight.sd_setImage(with:URL(string:  /object.original), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)//(with:URL(string:  "\(APIBasePath.basePath)/" + "images/" + /self?.uploadDta?.original), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
                        
                        let dteGet = Utility.dteGetConvert(string: /object.sent_at, fromFormat: "yyyy-MM-dd HH:mm:ss", "HH:mm")
                        cell.lblTime.text = dteGet
                    }
                }
            }else{
                if /object.chat_type == "text"{
                    if let cell = cell as? chatLeftTVC {
                        cell.lblChatMsg.text = /object.text
                        let dteGet = Utility.dteGetConvert(string: /object.sent_at, fromFormat: "yyyy-MM-dd HH:mm:ss", "HH:mm")
                        cell.lblTime.text = dteGet
                    }
                    
                }else{
                    if let cell = cell as? chatImageLeftCell {
                        cell.imgeViewLeft.sd_setImage(with:URL(string:  /object.original), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)//(with:URL(fileURLWithPath: "\(APIBasePath.basePath)/" + "images/" + /self?.uploadDta?.original) as URL, placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
                        
                        let dteGet = Utility.dteGetConvert(string: /object.sent_at, fromFormat: "yyyy-MM-dd HH:mm:ss", "HH:mm")
                        cell.lblTime.text = dteGet
                    }
                    
                }
            }
            
        }
        
        
        
        let didSelectCellBlock : DidSelectedRowCab = {  (indexPath , cell, item) in
            if let cell = cell as? eTokenCellToBuy {
                cell.setSelected(false, animated: true)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: chatDta, tableView: tblView, cellIdentifier: "chatLeftTVC", cellHeight: UITableView.automaticDimension) //  cellHeight: nil
        
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tblView.delegate = tableDataSource
        tblView.dataSource = tableDataSource
        tableDataSource?.identifier1 = ({ indexPath in
            
            switch indexPath?.row {
            case 0:
                // return "chatTimeHeaderTVC"
                let obj = self.chatDta?[indexPath?.row ?? 0]
                if /obj?.chat_type == "text"{
                    if /obj?.send_by == UDSingleton.shared.userData?.userDetails?.userId!{
                        return "chatRightTVC"
                    }else{
                        return "chatLeftTVC"
                    }
                }else{
                    if /obj?.send_by == UDSingleton.shared.userData?.userDetails?.userId!{
                        return "chatImgeRightTVC"
                    }else{
                        return "chatImageLeftCell"
                    }
                }
                
            default:
                let obj = self.chatDta?[indexPath?.row ?? 0]
                if /obj?.chat_type == "text"{
                    if /obj?.send_by == UDSingleton.shared.userData?.userDetails?.userId!{
                        return "chatRightTVC"
                    }else{
                        return "chatLeftTVC"
                    }
                }else{
                    if /obj?.send_by == UDSingleton.shared.userData?.userDetails?.userId!{
                        return "chatImgeRightTVC"
                    }else{
                        return "chatImageLeftCell"
                    }
                }
            }
        })
        tblView.reloadData()
    }
    
}

//MARK:- API HIT FUNCTION
extension ChatVC{
    func emitRecieve(){
        SocketIOManagerCab.shared.getChatsMessage { [weak self] (data) in
            guard let self = self , let data = data else { return }
            self.chatDta?.append(data)
            self.updateChat(self.chatDta ?? [])
        }
        
    }
    func getChatDta(){
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let purchasedTokenList = BookServiceEndPoint.pssChatListing("1", "\(/otherUserId)", 10000, 0)
        
        if #available(iOS 16.0, *) {
            purchasedTokenList.request(header: ["access_token" :  "\(token)"]) { [weak self] (response)  in
                switch response{
                case .success(let responseValue):
                    self?.chatDta = responseValue as? [Chat]
                    self?.updateChat(self?.chatDta ?? [])
                    
                case .failure(let err):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /err , type: .error )
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}

//MARK: - Keyboard observers
extension ChatVC {
    
    override func keyboardDidShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let frame = value.cgRectValue
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
              //  self?.tblView.contentInset.bottom = frame.height
                self?.txtInputBottomConstraint.constant = frame.height
                self?.view.layoutIfNeeded()
                }, completion: { [weak self] bool in
                    if bool {
                        self?.scrollToBottom()
                       // self?.tblView.scrollTo(direction: .Bottom, animated: true)
                    }
            })
            
            
        }
    }
    
    override func keyboardWillHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let frame = value.cgRectValue
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
                self?.tblView.contentInset.bottom = 0.0
                self?.txtInputBottomConstraint.constant = 0.0 //frame.height
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
}

