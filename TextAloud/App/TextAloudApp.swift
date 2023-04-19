//
//  TextAloudApp.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 26.10.2022.
//

import SwiftUI
import TextAloudKit

@main
struct TextAloudApp: App {
    @StateObject var settings = RootSettings(isTextAloudPro: false)
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
        }
    }
}
