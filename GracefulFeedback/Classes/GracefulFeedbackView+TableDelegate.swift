//
//  GracefulFeedbackView+TableDelegate.swift
//  Pods
//
//  Created by Spring on 2018/1/13.
//

import Foundation

extension GracefulFeedbackView {
    
    
    // MARK: UITableView Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chatList?.count ?? 0
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let chatItem = self.chatList?[indexPath.row] {
            
            if let content = chatItem.content {
                
                return ChatTableViewCell.calcRowHeight(forText: content)
                
            }
            
        }
        
        return ChatTableViewCell.minHeight
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let chatCell = cell as? ChatTableViewCell {
            
            if let chatItem = self.chatList?[indexPath.row] {
                
                chatCell.bindChatItem(chatItem: chatItem)
                
            }
            
        }
        
        return cell
        
    }
    
    
}
