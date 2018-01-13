//
//  FeedbackUIDManager.swift
//  ninegrid
//
//  Created by marspro on 2017/11/3.
//  Copyright © 2017年 mars. All rights reserved.
//

import UIKit
//import

public class FeedbackUIDManager: NSObject {

    public static let sharedInstance = FeedbackUIDManager()
    
    var uid: String?
    
    let userDefault = UserDefaults(suiteName: "org.swiftcafe.feedback")
    
    override init() {
        
        super.init()
        
        // fetch UID from user default system first.
        self.uid = userDefault?.string(forKey: "feedback_uid")
        
    }
    
    public func getUID(callback: @escaping (String) -> Void) {
        
        if let uid = self.uid {
            
            // if UID has already fetched.
            callback(uid)
            return
            
        }
        
        let urlString = FeedbackURLManager.requestUserID()
        
        if let url = URL(string: urlString) {
        
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
              
                print("result")
                
            })
            
        }
        
//        Just.get(url) { (result) in
//         
//            DispatchQueue.main.async {
//                
//                if let data = result.content {
//                    
//                    if let uid = String(data: data, encoding: String.Encoding.utf8) {
//                        
//                        if(uid.characters.count > 0) {
//                            
//                            //如果 UID 有内容
//                            UserDefaults.standard.set(uid, forKey: "feedback_uid")
//                            UserDefaults.standard.synchronize()
//                            self.uid = uid
//                            print("uid get: \(uid)")
//                            callback(uid)
//                            
//                            return
//                            
//                        }
//                        
//                    }
//                    
//                    callback("")
//                    
//                }
//            }
//            
//        }
        
    }
    
}
