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
        
        let feedbackProvider = GracefulFeedbackProvider()
        feedbackProvider.getItems = { uid, callback in
            
            let urlString = "http://dropletapps.com/getFeedback/\(uid)"
            
            if let url = URL(string: urlString) {
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    do {
                        
                        if let responseData = data {
                        
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
                        
                        }
                        
                        
                        
                    } catch {
                        
                    }

                    
                }).resume()
                
            }
            
        }
        
        feedbackProvider.refreshUID = { callback in
            
            let urlString = "http://dropletapps.com/requestUID"
            
            if let url = URL(string: urlString) {
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if let realData = data {
                        
                        if let uid = String(data: realData, encoding: String.Encoding.utf8) {
                            
                            if(uid.characters.count > 0) {
                                
                                //如果 UID 有内容                                                                
                                callback(uid)
                                
                                return
                                
                            }
                            
                        }

                    }
                 
                    
                }).resume()
                
            }
            
        }
        
        feedbackProvider.sendFeedback = { uid, content, callback in
            
            let urlString = "http://dropletapps.com/addFeedback"
            
            if let url = URL(string: urlString) {
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let bodyString = "userID=\(uid)&content=\(content)&deviceInfo=1"
                request.httpBody = bodyString.data(using: String.Encoding.utf8)
                
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    
                    callback()
                    
                }).resume()
                
            }
            
        }
        
        let feedbackView = GracefulFeedbackView(frame: CGRect.zero, provider: feedbackProvider)
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

