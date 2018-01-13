//
//  ViewController.swift
//  GracefulFeedback
//
//  Created by SwiftCafe on 12/10/2017.
//  Copyright (c) 2017 SwiftCafe. All rights reserved.
//

import UIKit
import GracefulFeedback

class ViewController: UIViewController {

    var feedbackView: GracefulFeedbackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "feedback"
        
        let feedbackView = GracefulFeedbackView(frame: CGRect.zero)
        self.view.addSubview(feedbackView)
        
        self.feedbackView = feedbackView
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        var top = UIApplication.shared.statusBarFrame.size.height
        var bottom = CGFloat(0.0)
        
        if #available(iOS 11, *) {
            
            top = self.view.safeAreaInsets.top
            bottom = self.view.safeAreaInsets.bottom
            
        }
        
        self.feedbackView?.frame = CGRect(x: 0, y: top, width: self.view.frame.size.width, height: self.view.frame.size.height - bottom - top)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
}

