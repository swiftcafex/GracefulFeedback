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
    
    var feedbackProvider : GracefulFeedbackProvider?
    
    
    public init(frame: CGRect, provider: GracefulFeedbackProvider) {
        
        super.init(frame: frame)
     
        self.backgroundColor = UIColor("#ebebeb")
        self.feedbackProvider = provider
        
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
        
        self.chatTableView?.frame = CGRect(x: 0, y: top, width: self.frame.size.width, height: self.frame.size.height - charViewHeight - bottom - top - self.keyboardHeight)
        self.chatView?.frame = CGRect(x: 0, y: self.frame.size.height - charViewHeight - bottom - self.keyboardHeight, width: self.frame.size.width, height: charViewHeight)
        
        self.connectView?.frame = CGRect(x: 0, y: top, width: self.frame.size.width, height: 50)
        
    }
    
    // MARK: Utils
    func loadData() {
        
        self.feedbackProvider?.getUID { uid in
            
            self.feedbackProvider?.getItems?(uid) { items in
                
                DispatchQueue.main.async {
                    
                    self.connectView?.isHidden = true
                    self.chatList = items
                    self.chatTableView?.reloadData()
                    
                }
                
            }
            
        }

    }
    
    func sendFeedBack() {
        
        FeedbackUIDManager.sharedInstance.getUID { (uid) in
            
            if uid.count > 0 {
                
                if let content = self.chatView?.textView?.text {
                    
                    self.chatView?.textView?.text = ""
                    
                    self.feedbackProvider?.sendFeedback?(uid, content ) {
                        
                        self.loadData()
                        
                    }
                    
                    
//                    Just.post(url, data: ["userID":uid, "content": content, "deviceInfo" : UIDevice.current.platformString()], asyncCompletionHandler: { (result) in
//
//                        DispatchQueue.main.async {
//
//                    
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
            self.setNeedsLayout()
            
        }
        
    }
    
    @objc func keyboardHide(notification: Notification) {
        
        self.keyboardHeight = 0
        self.setNeedsLayout()
        
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
  
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.chatView?.textView?.resignFirstResponder()
        self.chatTableView?.becomeFirstResponder()
        
    }
    

}
