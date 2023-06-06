//
//  Text.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 17/05/2023.
//

import Foundation

public class TextState: ObservableObject {
    @Published var rawText: String
    @Published var refreshRawText: Bool
    
    public init() {
        self.rawText = ""
        self.refreshRawText = false
    }
    
    public func clear() {
        self.rawText = ""
        self.refreshRawText = true
    }
}
