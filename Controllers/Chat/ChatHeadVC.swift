//
//  ChatHeadVC.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 04/08/18.
//

import UIKit
import IQKeyboardManager
import Lightbox
import ESPullToRefresh


class ChatHeadVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton! {
        didSet {
            btnBack.imageView?.mirrorTransform()
        }
    }
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: ChatTable! {
        didSet {
            tableView.registerXIB(MessageType.Text.cellID(isOwn: false))
            tableView.registerXIB(MessageType.Text.cellID(isOwn: true))
            tableView.registerXIB(MessageType.Image.cellID(isOwn: false))
            tableView.registerXIB(MessageType.Image.cellID(isOwn: true))
            tableView.registerXIB(MessageType.Attachement.cellID(isOwn: true))
            tableView.registerXIB(MessageType.Attachement.cellID(isOwn: false))
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNoData: UILabel!
    
    //MARK::- PROPERTIES
    lazy var messages = [MessageChat]()
    var messageType: ChatListing?
    var agent: CblUser?
    var isInProgress = false
    var orderId = ""
    var agentId = ""
    var skip = 0
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        UserData.share.currentConversationId = orderId
        UserData.share.currentAgentId = agentId
        skip = 0
        onLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = false
        if messages.count != 0{
            tableView.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .default
       }
    
    //MARK::- FUNCTIONS
    
    func onLoad(){
        establishSocket()
        SocketIOManager.shared.setUpListeners()
        SocketIOManager.shared.addHandlers()
        refreshHeader()
        labelName?.text = /agent?.name
        imageUser.loadImage(thumbnail: /agent?.image , original: nil)
        IQKeyboardManager.shared().isEnabled = false
        tableView.inputAccessory.delegate = self
        retrieveAllMessages()
    }
    
    //MARK::- ACTIONS
    @IBAction func btnBackAction(_ sender: Any) {
        //        SocketIOManager.shared.disconnect()
        UserData.share.currentConversationId = ""
        UserData.share.currentAgentId = ""
        SocketIOManager.shared.disConnectMsgEvent()
        self.popVC()
    }
}

//MARK:- New Message Append Delegate
extension ChatHeadVC: SendMessagedDelegate {
    
    func updateUploadingFail(with message: MessageChat){
        let failedMessage = message
        failedMessage.isFail = true
        let messageArray = messages.reversed()
        messageArray.forEach { (messag) in
            if messag.messageID == failedMessage.messageID{
                //asign true to the uploaded item and reload
                messag.uploaded = false
                messag.isFail = true
            }
        }
        messages = messageArray.reversed()
        tableView.reloadData()
        tableView.scrollToBottom(animated: false, scrollPostion: .bottom)
    }
    
    
    func updateUploadingCompleted(with message: MessageChat) {
        let messageArray = messages.reversed()
        messageArray.forEach { (messag) in
            if messag.messageID == message.messageID{
                //asign true to the uploaded item and reload
                messag.uploaded = true
                messag.isFail = false
                let video1 = message.video
                video1?.thumbnail = messag.video?.thumbnail
                messag.video = video1
                messag.attachement = message.attachement
            }
        }
        messages = messageArray.reversed()
        tableView.reloadData()
        tableView.scrollToBottom(animated: false, scrollPostion: .bottom)
    }
    
    
    func newMessageAppendCall(message: MessageChat) {
        self.messages.append(message)
        DispatchQueue.main.async { [ weak self ] in
            self?.labelNoData.isHidden = true
            self?.tableView.insertRows(at: [IndexPath.init(row: /self?.messages.count - 1, section: 0)], with: .none)
            self?.tableView.reloadRows(at: [IndexPath.init(row: /self?.messages.count - 1, section: 0)], with: .none)
            self?.tableView.scrollToBottom(animated: false, scrollPostion: .bottom)
            //            self?.sendMessage(chatId: /self?.messageType?.convoId , message: /message.message, messageType: /message.type?.rawValue.toString, image: /message.image?.url , video: "")
        }
        
    }
}

//MARK:- Chat Table Delegate & DataSource
extension ChatHeadVC: UITableViewDelegate, UITableViewDataSource {
    
    func refreshHeader(){
        tableView.es.addPullToRefresh { [weak self] in
            if /self?.messages.count >= 30 && ((self?.isInProgress) == nil)  {
                self?.skip = /self?.skip + 1
                self?.retrieveAllMessages()
            }else{
                self?.tableView.es.stopPullToRefresh()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: /messages[indexPath.row].getCellID, for: indexPath)
        switch item.type ?? .Text {
        case .Text:
            if /item.isOwnMessage {
                (cell as? SenderTxtCell)?.item = item
            } else {
                (cell as? ReceiverTxtCell)?.item = item
            }
        case .Image, .Video , .Property:
            if /item.isOwnMessage {
                (cell as? SenderImgCell)?.delegate = self
                (cell as? SenderImgCell)?.item = item
                (cell as? SenderImgCell)?.btnUpload.tag = indexPath.row
            } else {
                (cell as? ReceiverImgCell)?.item = item
            }
        case .Attachement:
            if /item.isOwnMessage {
                (cell as? SenderAtchCell)?.item = item
            } else {
                (cell as? ReceiverAtchCell)?.item = item
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.messages[indexPath.row].type?.height ?? 10.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = messages[indexPath.row]
        switch item.type ?? .Text {
        case .Text:
            break
        case .Video:
            showLightbox(video: item.video , image: item.image , isVideo: true)
        case .Image:
            showLightbox(video: item.video , image: item.image , isVideo: false)
        case .Attachement:
            break
        //            self.showDoc(url: /item.attachement?.url )
        case .Property:
            break
            //            let vc = StoryboardScene.ProjectDetail.propertyDetailViewController.instantiate()
            //            let recom = Recommend()
            //            recom.id = item.propertyId
            //            vc.property = recom
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

//MARK::- API HANDLER
extension ChatHeadVC {
    
    //API HIT TO GET ALL MESSAGE
    
    func reverse(chat : [MessageChat]) -> [MessageChat]{
        var chats1 = [MessageChat]()
        for item in chat.reversed() {
            chats1.append(item)
        }
        return chats1
    }
    
    func retrieveAllMessages(){
        isInProgress = true
        
        ChatEndPoint.getConversation(limit: "30", skip: self.skip.toString , order_id: self.orderId  , receiver_created_id: /GDataSingleton.sharedInstance.loggedInUser?.user_created_id ).request(isImage: false, images: [], isLoaderNeeded: true , header: [
            "secretdbkey":AgentCodeClass.shared.clientSecretKey,
            "Authorization": /(GDataSingleton.sharedInstance.loggedInUser?.token),
        ]) { [ weak self ] (response) in
            switch response{
            case .success(let response ):
                guard let chats = response as? [MessageChat] else { return }
                let reversedChat = self?.reverse(chat: chats)
                if /self?.skip == 0{
                    print("Socket Called in chat once")
                    //                    SocketIOManager.shared.connect()
                }
                self?.messageSource(messagess: reversedChat ?? [])
                
                self?.tableView.reloadData()
                self?.tableView.inputAccessory.messageType = self?.messageType
                self?.isInProgress = false
                self?.tableView.becomeFirstResponder()
                DispatchQueue.main.async { [ weak self ] in
                    if /self?.messages.count > 0 && /self?.skip == 0{
                        self?.tableView.scrollToBottom(animated: false, scrollPostion: .bottom)
                    }else{
                        self?.tableView.es.stopPullToRefresh()
                        self?.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
                    }
                }
                self?.labelNoData.isHidden = self?.messages.count != 0
            case .failure(let str):
                self?.tableView.es.stopPullToRefresh()
                self?.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
                SKToast.makeToast(/(str as? String))
            }
        }
        
    }
    
    
    func messageSource(messagess: [MessageChat]){
        let oldMessages = messages
        if oldMessages.count == 0{
            self.messages = messagess
        }else{
            let newMesssages = messagess + oldMessages
            self.messages = newMesssages
        }
        
    }
    
}

//MARK::- SOCKET CONNECTION
extension ChatHeadVC {
    
    func establishSocket(){
        listenMessages()
    }
    
    func listenMessages(){
        
        SocketIOManager.shared.msg = { [ weak self ] message in
            guard let msg = message else { return }
            if msg.order_id ==  UserData.share.currentConversationId{
                self?.messages.append(msg)
                self?.tableView.reloadData()
                self?.tableView.scrollToBottom(animated: false, scrollPostion: .bottom)
            }
        }
        
    }
    
}

//MARK::- CELL ACTIONS
extension ChatHeadVC : DelegateUploadItem  {
    
    func uploadItem(index: Int){
        let msg = self.messages[index]
        switch msg.type ?? .Text {
        case .Text : break
        case .Image , .Property:
            self.tableView.inputAccessory.uploadImage(image: [msg.image?.image as? UIImage ?? UIImage() ], message: msg)
        case .Video :
            messages[index].isFail = false
            messages[index].uploaded = false
            self.tableView.reloadData()
            self.tableView.inputAccessory.uploadVideo(message: msg)
        case .Attachement:
            self.tableView.inputAccessory.uploadDocument(message: msg)
        }
        
    }
    
}

//MARK::- SHOW IMAGE, VIDEO, DOCS
extension ChatHeadVC  {
    
    func showLightbox(video: MessageVideo? , image: MessageImage? , isVideo: Bool) {
        var data = [LightboxImage]()
        if isVideo{
            if let _ : UIImage = video?.thumbnail as? UIImage {
                //                self.playLocalVideo(/video?.url)
                return
            } else {
                guard let imgUrl = URL.init(string: /(video?.thumbnail as? String)) , let videoUrl = URL.init(string: /(video?.url as? String))  else { return }
                data = [ LightboxImage(
                    imageURL: imgUrl ,
                    text: "",
                    videoURL: videoUrl)
                ]
            }
        }else{
            if let image: UIImage = image?.image as? UIImage {
                data = [ LightboxImage(
                    image: image,
                    text: ""
                    )]
            } else {
                guard let imgUrl = URL.init(string: /(image?.image as? String)) else { return }
                data = [LightboxImage(imageURL: imgUrl)]
            }
        }
        
        let controller = LightboxController(images: data )
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
    }
    
}
