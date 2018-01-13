//
//  GracefulFeedbackView.swift
//  GracefulFeedback
//
//  Created by marspro on 2017/12/10.
//

import UIKit

public class GracefulFeedbackView: UIView, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate {

    var chatTableView: UITableView?
    var connectView: ConnectIndicatorView?
    
    var chatView : ChatTextView?
    
    var charViewHeight = CGFloat(50)
    var keyboardHeight = CGFloat(0)
    
    var chatList: [ChatItem]?
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
     
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor("#ebebeb")
        tableView.separatorColor = UIColor.clear
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsSelection = false
        self.chatTableView = tableView
        self.addSubview(tableView)
        
        let chatView = ChatTextView(frame: CGRect.zero)
        chatView.textView?.delegate = self
        self.chatView = chatView
        self.addSubview(chatView)
        
        let connectView = ConnectIndicatorView(frame: CGRect.zero)
        self.connectView = connectView
        self.addSubview(connectView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.loadData()
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var top = CGFloat(0.0)
        var bottom = CGFloat(0.0)
        
        if #available(iOS 11, *) {
            
            top = self.safeAreaInsets.top
            bottom = self.safeAreaInsets.bottom
            
        }
        
        self.chatTableView?.frame = CGRect(x: 0, y: top, width: self.frame.size.width, height: self.frame.size.height - charViewHeight - bottom - top)
        self.chatView?.frame = CGRect(x: 0, y: self.frame.size.height - charViewHeight - bottom, width: self.frame.size.width, height: charViewHeight)
        
        self.connectView?.frame = CGRect(x: 0, y: top, width: self.frame.size.width, height: 50)
        
    }
    
    // MARK: Utils
    
    func loadData() {
        
        ChatItem.getItems { (items) in
            
            DispatchQueue.main.async {
                
                self.connectView?.isHidden = true
                self.chatList = items
                self.chatTableView?.reloadData()
                
            }
            
        }
        
    }
    
    
    func sendFeedBack() {
        
        let url = FeedbackURLManager.addFeedBack()
        
        FeedbackUIDManager.sharedInstance.getUID { (uid) in
            
            if uid.characters.count > 0 {
                
                if let content = self.chatView?.textView?.text {
                    
                    self.chatView?.textView?.text = ""
                    
                    
//                    Just.post(url, data: ["userID":uid, "content": content, "deviceInfo" : UIDevice.current.platformString()], asyncCompletionHandler: { (result) in
//
//                        DispatchQueue.main.async {
//
//                            self.loadDate()
//
//                        }
//
//                    })
                    
                }
                
            }
            
        }
        
    }
    
    @objc func keyboardShown(notification: Notification) {
        
        let userInfo = notification.userInfo
        
        if let val = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRect = val.cgRectValue
            let keyboardHeight = keyboardRect.height
            self.keyboardHeight = keyboardHeight
            self.chatTableView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - charViewHeight - keyboardHeight)
            self.chatView?.frame = CGRect(x: 0.0, y: self.frame.size.height - charViewHeight - keyboardHeight, width: self.frame.size.width, height: charViewHeight)
            
        }
        
    }
    
    @objc func keyboardHide(notification: Notification) {
        
        self.keyboardHeight = 0
        self.chatTableView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - charViewHeight)
        self.chatView?.frame = CGRect(x: 0.0, y: self.frame.size.height - charViewHeight, width: self.frame.size.width, height: charViewHeight)
        
    }
    
    // MARK: UITextView Delegate
    public func textViewDidChange(_ textView: UITextView) {
        
        if let _ = self.chatView {
            
            let size = textView.sizeThatFits(CGSize(width: self.frame.size.width, height: 1000))
            self.chatTableView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - size.height - self.keyboardHeight)
            self.chatView?.frame = CGRect(x: 0.0, y: self.frame.size.height - size.height - self.keyboardHeight, width: self.frame.size.width, height: self.keyboardHeight)
            print("content height \(size)")
            
        }
        
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            self.chatView?.textView?.resignFirstResponder()
            self.sendFeedBack()
            return false
        }
        return true
        
    }
    
    // MARK: UITableView Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chatList?.count ?? 0
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let chatItem = self.chatList?[indexPath.row] {
            
            if let content = chatItem.content {
                
                return ChatTableViewCell.calcRowHeight(forText: content)
                
            }
            
        }
        
        return ChatTableViewCell.minHeight
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let chatCell = cell as? ChatTableViewCell {
            
            if let chatItem = self.chatList?[indexPath.row] {
                
                chatCell.bindChatItem(chatItem: chatItem)
                
            }
            
        }
        
        return cell
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.chatView?.textView?.resignFirstResponder()
        self.chatTableView?.becomeFirstResponder()
        
    }
    

}
