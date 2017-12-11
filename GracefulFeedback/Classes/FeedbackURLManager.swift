//
//  FeedbackURLManager.swift
//  ninegrid
//
//  Created by marspro on 2017/11/3.
//  Copyright © 2017年 mars. All rights reserved.
//

import UIKit

class FeedbackURLManager: NSObject {

    private static var host = "dropletapps.com"
    
    static func getFeedkback(byUserID userID: String) -> String {
        
        return "http://\(host)/getFeedback/\(userID)"
        
    }
    
    static func addFeedBack() -> String {
    
        return "http://\(host)/addFeedback"
        
    }
    
    static func requestUserID() -> String {
        
        return "http://\(host)/requestUID"
        
    }
    
}
