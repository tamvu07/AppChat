//
//  ChatModels.swift
//  AppChat
//
//  Created by Vu Minh Tam on 7/26/21.
//

import Foundation
import CoreLocation
import MessageKit

struct Message: MessageType {
    public var messageId: String
   
    public var sentDate: Date
    
    public var kind: MessageKind
    
    public var sender: SenderType
}

extension MessageKind {
    var messageKindString: String {
        switch  self {
        
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var senderId: String
    
    public var displayName: String
    
    public var photURL: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}
