//
//  GracefulFeedbackProvider.swift
//  Pods
//
//  Created by Spring on 2018/1/14.
//

import Foundation

public class GracefulFeedbackProvider {
    
    var uid: String?
    
    let userDefault = UserDefaults(suiteName: "org.swiftcafe.feedback")
    
    
    public var getItems : (  (String, @escaping ([ChatItem]) -> Void  ) -> Void)?
    
    public var refreshUID : ((@escaping (String) -> Void) -> Void)?
    
    public var sendFeedback: (  (String, String, @escaping () -> Void  ) -> Void)?
    
    private var savedUID: String?
    
    public func getUID(callback: @escaping (String) -> Void) {
        
        if let uid = self.uid {
            
            // if UID has already fetched.
            callback(uid)
            return
            
        }
        
        self.refreshUID? { uid in
        
            callback(uid)
            self.userDefault?.set(uid, forKey: "feedback_uid")
            self.userDefault?.synchronize()
            
        }
        
    }
    
    public init() {
        
        // fetch UID from user default system first.
        self.uid = userDefault?.string(forKey: "feedback_uid")
        
    }
    
    
    
}
