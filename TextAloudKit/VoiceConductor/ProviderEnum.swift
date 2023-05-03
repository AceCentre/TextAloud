//
//  ProviderEnum.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 02/05/2023.
//

import Foundation

enum ProviderEnum {
    case system, azure
    
    var title: String {
        switch self {
        case .azure: return "Microsoft Azure"
        case .system: return "Apple System"
        }
    }
}
