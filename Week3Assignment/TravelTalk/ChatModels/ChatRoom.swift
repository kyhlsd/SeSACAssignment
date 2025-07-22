//
//  ChatRoom.swift
//  SeSAC7Step1Remind
//
//  Created by Jack on 7/18/25.
//

import Foundation

//트래블톡 화면에서 사용할 데이터 구조체
final class ChatRoom {
    let chatroomId: Int //채팅방 고유 ID
    let chatroomImage: String //채팅방 이미지
    let chatroomName: String //채팅방 이름
    var chatList: [Chat] //채팅 화면에서 사용할 데이터
    var lastChatMessage: String? {
        return chatList.last?.message
    }
    var lastChatDate: String? {
        return chatList.last?.date
    }
    
    init(chatroomId: Int, chatroomImage: String, chatroomName: String, chatList: [Chat] = []) {
        self.chatroomId = chatroomId
        self.chatroomImage = chatroomImage
        self.chatroomName = chatroomName
        self.chatList = chatList
    }
    
    func matches(keyword: String) -> Bool {
        if chatroomName.localizedCaseInsensitiveContains(keyword) {
            return true
        }
        return false
    }
}
