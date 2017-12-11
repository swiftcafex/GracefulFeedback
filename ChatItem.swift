//
//  ChatItem.swift
//  ninegrid
//
//  Created by marspro on 2017/11/3.
//  Copyright © 2017年 mars. All rights reserved.
//

import UIKit
import Just

struct ChatItem {

    var userID: String?
    var content: String?
    var contentType: Int?
    var pubDate: Date?
    var deviceInfo: String?
    
    static func getItems(callback: @escaping ([ChatItem]) -> Void) {
        
        FeedbackUIDManager.sharedInstance.getUID { (uid) in
            
            if uid.characters.count > 0 {
                
                let url = FeedbackURLManager.getFeedkback(byUserID: uid)
                
                Just.get(url) { (result) in
                    
                    if let responseData = result.content {
                        
                        do {
                            
                            if let jsonObj = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                                
                                if let data = jsonObj["data"] as? NSArray {
                                    
                                    var items = [ChatItem]()
                                    
                                    data.enumerateObjects({ (dataItem, index, stop) in
                                        
                                        if let obj = dataItem as? NSDictionary {
                                            
                                            var item = ChatItem()
                                            item.userID = obj["user_id"] as? String
                                            item.content = obj["content"] as? String
                                            item.deviceInfo = obj["device_info"] as? String
                                            item.contentType = obj["content_type"] as? Int
                                            
                                            if let dateString = obj["pub_date"] as? String {
                                                
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                                                let date = dateFormatter.date(from: dateString)
                                                item.pubDate = date
                                                
                                            }
                                            
                                            items.append(item)
                                        }
                                        
                                        
                                    })
                                    
                                    callback(items)
                                    
                                }
                                
                            }
                            
                        } catch {
                            
                        }
                        
                    }
                    
                }
                
            }else {
                
                callback([ChatItem]())
                
            }
            
        }
        
        
    }
    
}
