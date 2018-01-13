//
//  ConnectIndicatorView.swift
//  Pods
//
//  Created by marspro on 2018/1/12.
//

import UIKit

class ConnectIndicatorView: UIView {

    var indicator: UIActivityIndicatorView?
    var connectText: UILabel?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.startAnimating()
        self.addSubview(indicator)
        
        self.indicator = indicator
        
        let connectText = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        connectText.text = NSLocalizedString("feedback.connect", comment: "")
        connectText.text = "Connecting..."
        connectText.font = UIFont.systemFont(ofSize: 14)
        connectText.textColor = UIColor.darkGray
        self.addSubview(connectText)
        
        self.connectText = connectText
        
        
    }
     
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.indicator?.center = CGPoint(x: self.frame.size.width / 2 - 50, y: self.frame.size.height / 2)
        self.connectText?.center = CGPoint(x: self.frame.size.width / 2 + 15, y: self.frame.size.height / 2)
        
    }

}
