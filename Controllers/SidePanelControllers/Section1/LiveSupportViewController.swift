//
//  LiveSupportViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SZTextView
import IQKeyboardManager

class LiveSupportViewController: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var imageViewUser: UIImageView!{
        didSet{
            imageViewUser.layer.cornerRadius = MidPadding
            imageViewUser.loadImage(thumbnail: GDataSingleton.sharedInstance.loggedInUser?.userImage, original: nil, placeHolder: UIImage(asset: Asset.User_placeholder))

        }
    }
    @IBOutlet weak var labelResponseTime: UILabel!
    @IBOutlet weak var tvMessage: SZTextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintBottomTableView: NSLayoutConstraint!
    
    //MARK:- Variables
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInteractive)
    var tableDataSource = ChatDataSource(){
        didSet{
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    var messages : [Message]? = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChatDataSource()

//        SocketIOManager.sharedInstance.establishConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLiveSupport()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        SocketIOManager.sharedInstance.closeConnection()
        NotificationCenter.default.removeObserver(self)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        messages = []
    }
    func setupLiveSupport(){
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        setUpKeyboardNotifications()
        fetchMessages()
        labelResponseTime.text = L10n.Online.string
    }
}

//MARK: - Configure chat Data Source
extension LiveSupportViewController {
    
    func fetchMessages(){
        
//        SocketIOManager.sharedInstance.getMessagesFromServer { [unowned self] (chat) in
//            
//            var tempmessages : [Message] = []
//            for message in chat?.messages ?? [] {
//                if message.userId != GDataSingleton.sharedInstance.loggedInUser?.id { return }
//                message.myMessage = false
//                tempmessages.append(message)
//            }
//            dispatch_group_notify(self.group, self.queue, {
//                 self.addNewMessages(tempmessages)
//            })
//           
//        }
    }
    
    func configureChatDataSource(){
        tableDataSource = ChatDataSource(items: messages, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: nil, configureCellBlock: { (cell, item) in
                weak var weakSelf = self
            weakSelf?.configureCell(cell: cell, message: item)
            }, aRowSelectedListener: { (indexPath) in
                
        })
        tableView.reloadData()
    }
    
    
    func configureCell(cell : Any,message : Any?){
        (cell as? LiveSupportChatCell)?.message = message as? Message
    }
}
//MARK: - Button Actions
extension LiveSupportViewController {
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func actionSend(sender: UIButton) {
        
        if tvMessage?.text.trimmed() == "" {
            return
        }
        sendMessage(message: tvMessage?.text)
    }
}

//MARK: - New Messages Handlers

extension LiveSupportViewController {
    
    func addNewMessages(arrMessage : [Message]?){
        
        var indexPaths : [IndexPath] = []
        guard let arrMessages = arrMessage, arrMessages.count > 0 else { return }
        for msg in arrMessages {
            messages?.append(msg)
            tableDataSource.items?.append(msg)
            indexPaths.append(IndexPath(row: (messages?.count ?? 0) - 1, section: 0))
        }
        
        if indexPaths.count > 0{
            ez.runThisInMainThread({
                weak var weakSelf = self
                weakSelf?.tableView.beginUpdates()
                weakSelf?.tableView.insertRows(at: indexPaths , with: .fade)
                weakSelf?.tableView.endUpdates()
                weakSelf?.scrollToBottom(animate: true)
            })
        }
    }
    
    func sendMessage(message : String?){
//        let params = SocketIOManager.sharedInstance.formatParameters(message?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), adminId: messages?.last?.adminId)
//        
//        guard let sentMessage = SocketIOManager.sharedInstance.convertDictToMessage(params) else { return }
//        sentMessage.myMessage = true
//        self.addNewMessages([sentMessage])
//        
//        SocketIOManager.sharedInstance.sendMessage(params)
//        tvMessage.text = ""
    }
    
}

//MARK: - Start/Stop Typing

extension LiveSupportViewController {
    func configureStartStopTypinghandlers(){
//        SocketIOManager.sharedInstance.startTypingBlock = { [weak self]() in
//            
//            self?.labelResponseTime.text = L10n.Typing.string
//        }
//        
//        SocketIOManager.sharedInstance.stopTypingBlock = {[weak self] () in
//            
//            self?.labelResponseTime.text = L10n.Online.string
//        }
    }
}
