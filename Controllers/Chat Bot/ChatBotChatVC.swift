
//
//  ChatBotChatVC.swift
//  Sneni
//
//  Created by Sandeep Kumar on 16/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import ApiAI
import Speech

struct ChatBotMessage {
    
    var message: String = ""
    var isSender: Bool = false
    
}

struct ChatBotProductMessage {
    
    var message: ProductF?
    var indexType: ChatIndexType = .first
    
}

class ChatBotChatVC: UIViewController {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var constraintBottomText: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightText: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView? {
        didSet {
            configTable()
        }
    }
    
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnMic: UIButton!

    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }

    //MARK:- ======== Variables ========
    var tableDataSource: SKTableViewDataSource?
    var items: [Any] = [] {
        didSet {
            tableDataSource?.reloadTable(items: items)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.scrollToLast()
            }
        }
    }
    
    func scrollToLast() {
        if !self.items.isEmpty {
            self.tableView?.scrollToRow(at: IndexPath(row: self.items.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    //Audio
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    
    //MARK:- ======== LifeCycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    
    @objc func keyboardWillAppear(_ notification: NSNotification){
        
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height
        constraintBottomText.constant = -((keyboardFrame ?? 0.0) + 44.0)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification){
        // Do something here
        constraintBottomText.constant = 0.0
        view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- ======== Actions ========
    
    @IBAction func didTapSubmit(_ sender: Any) {
        
        let txt = /txtMessage?.text.trimmingCharacters(in: .whitespaces)
        if txt.isEmpty {
            return
        }
        txtMessage?.text = ""
        var arr = items
        arr.append(ChatBotMessage(message: txt, isSender: true))
        items = arr
        getResponce(txt)
        
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {

        items = [
            ChatBotMessage(message: "Welcome!".localized(), isSender: true),
            ChatBotMessage(message: "What can i help you with?".localized(), isSender: true),
        ]
        
        speechAndText(text: "Welcome!\nWhat can i help you with?".localized())
//        items = [
//            ChatBotMessage(message: "Hello", isSender: true),
//            ChatBotMessage(message: "Hi", isSender: false),
//            ChatBotMessage(message: "I want to order a burger from Burger Grill", isSender: true),
//            ChatBotMessage(message: "Choose the item from the list", isSender: false),
//            ChatIndexType.top,
//            ChatBotProductMessage(message: Product(attributes: [:]), indexType: .first),
//            ChatBotProductMessage(message: Product(attributes: [:]), indexType: .middel),
//            ChatBotProductMessage(message: Product(attributes: [:]), indexType: .middel),
//            ChatBotProductMessage(message: Product(attributes: [:]), indexType: .last),
//            ChatIndexType.bottom,
//            ChatBotMessage(message: "That's so cool", isSender: true),
//            ChatBotMessage(message: "Ordering via chat is really amazing and easy", isSender: true),
//        ]
        
//        items = [TableViewHeaderObjectType(header: "123", footer: "", rows: ["", "", "", ""], type: nil, subHeader: "")]
        
        setUpAudio()
    }
    
    func setUpAudio() {
        btnMic.isEnabled = false
        btnMic.isSelected = false

        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.btnMic.isEnabled = isButtonEnabled
                self.btnMic.isHidden = !isButtonEnabled

            }
        }
    }
}

//MARK:- ======== SFSpeechRecognizerDelegate ========
extension ChatBotChatVC: SFSpeechRecognizerDelegate {
    @IBAction func microphoneDown(_ sender: AnyObject) {
        if !audioEngine.isRunning {
            microphoneEnd(sender)
        }
        startRecording()
        btnMic.isSelected = true
    }
    
    @IBAction func microphoneEnd(_ sender: AnyObject) {
        
        if txtMessage.text == "Say something, I'm listening!".localized() {
            txtMessage.text = ""
        }
        audioEngine.stop()
        recognitionRequest?.endAudio()
        btnMic.isEnabled = false
        btnMic.isSelected = false
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        txtMessage?.text = ""
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(.record, mode: .measurement)
            try audioSession.setActive(true)
            
//            audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.)
//            try audioSession.setCategory(AVAudioSession.Category.record)
//            try audioSession.setMode(AVAudioSession.Mode.measurement)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode//4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object".localized())
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: {
            (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                self.txtMessage?.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.btnMic.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        txtMessage.text = "Say something, I'm listening!".localized()
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            btnMic.isEnabled = true
            btnMic.isSelected = true
        } else {
            btnMic.isEnabled = false
            btnMic.isSelected = false
        }
    }
    
    
}
//MARK:- ======== TableView Configration ========
extension ChatBotChatVC {
    func configTable() {
        
        tableView?.tableFooterView = UIView()
        
        let identifier = [ChatBotMessageTableCell.identifier, ChatBotProductTableCell.identifier, ChatBotProductsHeaderTableCell.identifier]
        tableView?.registerCells(nibNames: identifier)
        
        tableDataSource = SKTableViewDataSource(items: items, tableView: tableView)
        
        tableDataSource?.block_HeightForRowAt = {
            (index) in
            let item = self.items[index.row]
            if item is ChatIndexType {
                return 24.0
            }
            return UITableView.automaticDimension
        }
        
        tableDataSource?.blockCellIdentifier = {
            (index) in
            let item = self.items[index.row]
            if item is ChatBotMessage {
                return ChatBotMessageTableCell.identifier
            } else if item is ChatBotProductMessage {
                return ChatBotProductTableCell.identifier
            } else if item is ChatIndexType {
                return ChatBotProductsHeaderTableCell.identifier
            }
            return ""
        }
        
        tableDataSource?.configureCellBlock = {
            (index, cell, item) in
            
            if let cell = cell as? ChatBotMessageTableCell,
                let item = item as? ChatBotMessage {
                cell.message = item.message
                cell.isSender = item.isSender
            } else if let cell = cell as? ChatBotProductTableCell,
                let item = item as? ChatBotProductMessage {
                //                let sect = self.items[index.section]
                cell.objModel = item.message
                cell.indexType = item.indexType
                
            } else if let cell = cell as? ChatBotProductsHeaderTableCell,
                let item = item as? ChatIndexType {
                cell.isHeader = item == .top
            }
            
        }
        
        //        tableDataSource?.heightForHeaderInSection = {
        //            (_ section: Int, _ sectionObj: TableViewHeaderObjectType) in
        //            return 24.0
        //        }
        //
        //        tableDataSource?.viewforHeaderInSection = {
        //            (_ section: Int, _ sectionObj: TableViewHeaderObjectType) in
        //            let viewH = self.tableView?.dequeueReusableCell(withIdentifier: identifierH) as? ChatBotProductsHeaderTableCell
        //            viewH?.isHeader = true
        //            return viewH
        //        }
        //
        //        tableDataSource?.heightForFooterInSection = {
        //            (_ section: Int, _ sectionObj: TableViewHeaderObjectType) in
        //            return 24.0
        //        }
        //
        //        tableDataSource?.viewForFooterInSection = {
        //            (_ section: Int, _ sectionObj: TableViewHeaderObjectType) in
        //            let viewH = self.tableView?.dequeueReusableCell(withIdentifier: identifierH) as? ChatBotProductsHeaderTableCell
        //            viewH?.isHeader = false
        //            return viewH
        //        }
        
        tableDataSource?.aRowSelectedListener = {
            [weak self] (index, cell) in
            guard let self = self else { return }
            
            if let cell = cell as? ChatBotProductTableCell {
                cell.stepper?.rightButtonTouchDown(button: UIButton())
                self.pushVC(StoryboardScene.Options.instantiateCartViewController())
            }
            
        }
        
        //        tableDataSource?.scrollDidEndDraging = {
        //            [weak self] (scrollView: UIScrollView) in
        //            guard let self = self else { return }
        //
        //            if scrollView == self.tableView,
        //                (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 15
        ////                /self.tenantData?.tenantList?.count < /self.tenantData?.count
        //            {
        //                 //next page load Api
        //            }
        //        }
        //        tableDataSource?.reloadTable(items: items)
        
        //        tableDataSource?.refreshTable = {
        //            [weak self] in
        //            guard let self = self else { return }
        //             //load Api
        //
        //        }
    }
}

extension ChatBotChatVC {
    func getResponce(_ text: String)  {
        let objR = API.getBotResponce(query: text)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response{
            case APIResponse.Success(let object):
                
                if let object = object as? BotResult {
                    print(object.type.rawValue)
                    
                    if object.type == .message {
                        var txt = /object.message
                        if txt.isEmpty {
                            txt = "Say Again!!!".localized()
                        }
                        var arr = self.items
                        arr.append(ChatBotMessage(message: txt, isSender: false))
                        self.items = arr
                        self.speechAndText(text: txt)
                        
                    } else if object.type == .products {
                        var arr:[Any] = self.items

                        let txt = /object.message
                        if !txt.isEmpty {
                            arr.append(ChatBotMessage(message: txt, isSender: false))
                            self.speechAndText(text: txt)
                        }
                        arr.append(ChatIndexType.top)
                        
                        let array = object.items ?? []
                        if array.count == 1 {
                            arr.append(ChatBotProductMessage(message: array.first, indexType: .countOne))
                        } else {
                            for obj in array.enumerated() {
                                let type: ChatIndexType = obj.offset == 0 ? .first : (obj.offset == (array.count - 1) ? .last : .middel)
                                arr.append(ChatBotProductMessage(message: obj.element, indexType: type))
                            }
                        }
                        arr.append(ChatIndexType.bottom)
                        self.items = arr
                        
                    }
                    
                }
                
            default :
                break
            }
        }
    }
}


extension ChatBotChatVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
}
