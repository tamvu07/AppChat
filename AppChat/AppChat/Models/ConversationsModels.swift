//
//  ConversationsModels.swift
//  AppChat
//
//  Created by Vu Minh Tam on 7/26/21.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
