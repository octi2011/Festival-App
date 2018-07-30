//
//  ChatVC.swift
//  Festival-App
//
//  Created by Duminica Octavian on 18/03/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

class ChatWindowVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typingLbl: UILabel!
    @IBOutlet weak var messageTextBox: UITextField!
    
    //Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
    
        messageTextBox.delegate = self
        
        setUpSWRevealViewController()
    
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatWindowVC.handleTap))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatWindowVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatWindowVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            
            if newMessage.channelId == MessageService.instance.selectedChannel!.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""//the names of who are typing
            var numberOfTypers = 0
            
            print(typingUsers)
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingLbl.text = "\(names) \(verb) typing a message ..."
                
            } else {
                self.typingLbl.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MessageService.instance.messages.removeAll()
        tableView.reloadData()
    }
    
    func setUpSWRevealViewController() {
        chatBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            // get channels
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0] //set first channel as selected one
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func getMessages() {
        MessageService.instance.messages.removeAll()
        tableView.reloadData()
        startSpinner()
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.getUsers(completion: { (success) in
                    if success {
                        self.stopSpinner()
                        self.tableView.reloadData()
                        if MessageService.instance.messages.count > 0 {
                            let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
                        }
                    } else {
                        self.stopSpinner()
                        self.tableView.reloadData()
                    }
                })
                
            }
        }
    }
    
    func getUsers(completion: @escaping CompletionHandler) {
        var count = 0
        if MessageService.instance.usersForChannel.count == 0 {
            completion(false)
        }
        MessageService.instance.usersForChannel.forEach { (key: String, value: User) in
            AuthService.instance.findUserById(id: key, completion: { (user) in
                if user._id != nil {
                    MessageService.instance.usersForChannel.updateValue(user, forKey: key)
                    count = count + 1
                }
                if count == MessageService.instance.usersForChannel.count {
                    completion(true)
                }
            })
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channedId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: AuthService.instance.id, channelId: channedId, completion: { (success) in
                if success {
                    self.messageTextBox.text = ""
                    self.messageTextBox.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channedId)
                }
            })
        }
    }
    
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channedId = MessageService.instance.selectedChannel?.id else { return }
        if messageTextBox.text == "" {
            isTyping = false
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channedId)
        } else {
            if isTyping == false {
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channedId)
            }
            isTyping = true
        }
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func startSpinner() {
        LoadingView.startLoading()
    }
    
    func stopSpinner() {
        LoadingView.stopLoading()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SocketService.instance.disableGetChatListener()
    }
}

extension ChatWindowVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
}

extension ChatWindowVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

