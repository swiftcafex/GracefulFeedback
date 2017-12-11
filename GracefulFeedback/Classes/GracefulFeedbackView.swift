//
//  GracefulFeedbackView.swift
//  GracefulFeedback
//
//  Created by marspro on 2017/12/10.
//

import UIKit

public class GracefulFeedbackView: UIView {

    var chatTableView: UITableView?
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
     
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height - charViewHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor("#ebebeb")
        tableView.separatorColor = UIColor.clear
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsSelection = false
        self.chatTableView = tableView
        self.addSubview(tableView)
        
        let chatView = ChatTextView(frame: CGRect(x: 0, y: self.containerView!.frame.size.height - charViewHeight, width: self.containerView!.frame.size.width, height: charViewHeight))
        chatView.textView?.delegate = self
        self.chatView = chatView
        self.containerView.addSubview(chatView)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }

}
