//
//  EnvironmentEditor.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 19/04/2023.
//

public class RootSettings: ObservableObject {
    @Published public var isTextAloudPro: Bool
    @Published public var groupName: String
    @Published public var appName: String
    
    public init(isTextAloudPro: Bool, groupName: String, appName: String) {
        self.isTextAloudPro = isTextAloudPro
        self.groupName = groupName
        self.appName = appName
    }
}
