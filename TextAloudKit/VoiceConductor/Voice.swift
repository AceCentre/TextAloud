//
//  Voice.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 02/05/2023.
//

import Foundation

class Voice {
    let shortName: String
    let longName: String
    let language: Language
    let provider: ProviderEnum
    let connectionType: ConnectionType
    let gender: Gender
    let id: String
    
    init(id: String, shortName: String, longName: String, language: Language, provider: ProviderEnum, connectionType: ConnectionType, gender: Gender) {
        self.id = id
        self.shortName = shortName
        self.longName = longName
        self.language = language
        self.provider = provider
        self.connectionType = connectionType
        self.gender = gender
    }
}
