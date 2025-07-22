//
//  ChatRoom.swift
//  SeSAC7Step1Remind
//
//  Created by Jack on 7/18/25.
//

import Foundation

//트래블톡 화면에서 사용할 데이터 구조체
struct ChatRoom: Equatable {
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
    
    func matches(keyword: String) -> Bool {
        if chatroomName.localizedCaseInsensitiveContains(keyword) {
            return true
        }
        return false
    }
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.chatroomId == rhs.chatroomId
    }
}
