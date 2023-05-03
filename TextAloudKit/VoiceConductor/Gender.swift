//
//  Gender.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 02/05/2023.
//

import Foundation

enum Gender {
    case male, female, unspecified, alternative(String)
    
    var title: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .unspecified: return "Unspecified"
        case .alternative(let givenTitle): return givenTitle
        }
    }
}
