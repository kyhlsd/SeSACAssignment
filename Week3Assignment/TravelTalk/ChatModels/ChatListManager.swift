//
//  ChatListManager.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/22/25.
//

import Foundation

struct ChatListManager {
    @ChatListBinding(defaultValue: [])
    var chatList: [Chat]
    init(chatRoomId: Int) {
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
            
            if let index = ChatList.list.firstIndex(where: { chatRoom in
                chatRoom.chatroomId == chatRoomId
            }) {
                return ChatList.list[index].chatList
            } else {
                return defaultValue
            }
        }
        set {
            guard let chatRoomId else { return }
            
            if let index = ChatList.list.firstIndex(where: { chatRoom in
                chatRoom.chatroomId == chatRoomId
            }) {
                ChatList.list[index].chatList = newValue
            }
        }
    }
}
