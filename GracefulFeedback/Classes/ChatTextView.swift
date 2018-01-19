//
//  ChatTextView.swift
//  ninegrid
//
//  Created by marspro on 2017/11/3.
//  Copyright © 2017年 mars. All rights reserved.
//

import UIKit

//意见反馈 底部聊天框
class ChatTextView: UIView {

    var bgView: UIImageView?
    var textView: UITextView?
    
    var labelHint : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)                
        
        let bgImage = UIImageView(image: ImageLoader.image(named: "chat_text_bg")?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 20))
        self.bgView = bgImage
        self.addSubview(bgImage)
        
        let textView = UITextView(frame: CGRect.zero)
        self.textView = textView
        self.textView?.isScrollEnabled = false
        self.textView?.font = UIFont.systemFont(ofSize: 18)
        self.textView?.autoresizingMask = .flexibleHeight
        self.textView?.returnKeyType = .send
        self.textView?.backgroundColor = UIColor.clear
//        self.textView.hi
//        self.textView?.inputAccessoryView
        self.addSubview(textView)
        
        let labelHint = UILabel(frame: CGRect.zero)
        labelHint.text = "请输入你的反馈"
        labelHint.font = UIFont.systemFont(ofSize: 16)
        labelHint.textColor = UIColor.lightGray
        self.addSubview(labelHint)
        self.labelHint = labelHint
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.bgView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.textView?.frame = CGRect(x: 5, y: 4, width: self.frame.size.width - 10, height: self.frame.size.height - 8)
        self.labelHint?.frame = CGRect(x: 10, y: 4, width: self.frame.size.width - 10, height: self.frame.size.height - 8)
        
    }

}
