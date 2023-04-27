//
//  EnvironmentEditor.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 19/04/2023.
//

public class RootSettings: ObservableObject {
    @Published public var isTextAloudPro = false
    
    public init(isTextAloudPro: Bool) {
        self.isTextAloudPro = isTextAloudPro
    }
}
