//
//  ChatListManager.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/22/25.
//

import Foundation

struct ChatListManager {
    var chatRoomId: Int
    @ChatListBinding(defaultValue: [])
    var chatList: [Chat]
    init(chatRoomId: Int) {
        self.chatRoomId = chatRoomId
        self._chatList.chatRoomId = chatRoomId
    }
}

@propertyWrapper
struct ChatListBinding {
    var chatRoomId: Int?
    let defaultValue: [Chat]
    
    var wrappedValue: [Chat] {
        get {
            guard let chatRoomId else { return defaultValue }
            
            if let index = ChatList.getIndexWithId(with: chatRoomId) {
                return ChatList.list[index].chatList
            } else {
                return defaultValue
            }
        }
        set {
            guard let chatRoomId else { return }
            
            if let index = ChatList.getIndexWithId(with: chatRoomId) {
                ChatList.list[index].chatList = newValue
            }
        }
    }
}
