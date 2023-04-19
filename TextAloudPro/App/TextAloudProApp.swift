//
//  TextAloudProApp.swift
//  TextAloudPro
//
//  Created by Gavin Henderson on 18/04/2023.
//

import SwiftUI
import TextAloudKit

@main
struct TextAloudProApp: App {
    
    @StateObject var rootSettings: RootSettings = RootSettings(isTextAloudPro: true)
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootSettings)
        }
    }
}
