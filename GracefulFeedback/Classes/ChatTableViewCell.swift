//
//  ChatTableViewCell.swift
//  ninegrid
//
//  Created by marspro on 2017/11/3.
//  Copyright © 2017年 mars. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class ChatTableViewCell: UITableViewCell {

    var photoView: UIImageView?
    var messageView: UIImageView?
    
    var textView: UITextView?
    
    var chatItem: ChatItem?
    
    static var maxTextWidth: CGFloat {
        
        get {
            
            return (UIScreen.main.bounds.width - 60) * 0.8
            
        }
        
    }
    
    static var minHeight: CGFloat {
        
        get {
            
            return paddingTop + paddingBottom + 35
            
        }
        
    }
    
    
    
    static var paddingTop: CGFloat = 15.0
    static var paddingBottom: CGFloat = 15.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {    
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        let photoView = UIImageView(image: ImageLoader.image(named: "ic_photo"))
        self.addSubview(photoView)
        self.photoView = photoView
        
        let messageView = UIImageView()
        
        messageView.image = ImageLoader.image(named: "chat_msg_bg")?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 5)
        self.addSubview(messageView)
        self.messageView = messageView
        
        let textView = UITextView(frame: CGRect.zero)
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor("#444")
        textView.backgroundColor = UIColor.clear
        messageView.addSubview(textView)
        self.textView = textView
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    func bindChatItem(chatItem: ChatItem) {
        
        self.chatItem = chatItem
        self.textView?.text = chatItem.content
        self.setNeedsLayout()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.chatItem?.contentType == 0 {
        
            //用户留言
            
            self.messageView?.image = ImageLoader.image(named: "chat_msg_usr_bg")?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 5)
            self.photoView?.frame = CGRect(x: self.frame.size.width - 50, y: ChatTableViewCell.paddingTop + 5, width: 40, height: 40)            
            self.messageView?.frame = CGRect(x: self.photoView!.frame.origin.x - ChatTableViewCell.maxTextWidth - 10, y: ChatTableViewCell.paddingTop, width: ChatTableViewCell.maxTextWidth, height: self.frame.size.height - ChatTableViewCell.paddingBottom)
            
        }else {
            
            //管理回复
            self.messageView?.image = ImageLoader.image(named: "chat_msg_bg")?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 5)
            self.photoView?.frame = CGRect(x: 10, y: ChatTableViewCell.paddingTop + 5, width: 40, height: 40)
            self.messageView?.frame = CGRect(x: 60, y: ChatTableViewCell.paddingTop, width: ChatTableViewCell.maxTextWidth, height: self.frame.size.height - ChatTableViewCell.paddingBottom)
            
            
        }
        self.textView?.frame = CGRect(x: 6, y: 6, width: self.messageView!.frame.size.width - 12, height: self.messageView!.frame.size.height - 12)
        
    }
    
    static func calcRowHeight(forText text: String) -> CGFloat {
     
        print("\(text) height: \(text.height(withConstrainedWidth: maxTextWidth, font: UIFont.systemFont(ofSize: 18)))")
        return text.height(withConstrainedWidth: maxTextWidth, font: UIFont.systemFont(ofSize: 16)) + paddingTop + paddingBottom + 14
        
    }

}
