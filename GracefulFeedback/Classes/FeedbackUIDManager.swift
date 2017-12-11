//
//  FeedbackUIDManager.swift
//  ninegrid
//
//  Created by marspro on 2017/11/3.
//  Copyright © 2017年 mars. All rights reserved.
//

import UIKit
//import

class FeedbackUIDManager: NSObject {

    static let sharedInstance = FeedbackUIDManager()
    
    var uid: String?
    
    override init() {
        
        super.init()
        self.uid = UserDefaults.standard.string(forKey: "feedback_uid")
        
    }
    
    func getUID(callback: @escaping (String) -> Void) {
        
        if let uid = self.uid {
            
            //如果本地已经存在
            print("uid cached: \(uid)")
            callback(uid)
            return
            
        }
        
        let url = FeedbackURLManager.requestUserID()
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
