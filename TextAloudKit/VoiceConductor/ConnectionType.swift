//
//  ConnectionType.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 02/05/2023.
//

import Foundation

enum ConnectionType {
    case online, offline
    
    var title: String {
        switch self {
        case .online: return "Online"
        case .offline: return "Offline"
        }
    }
}
