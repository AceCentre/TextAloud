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
    // Root Settings stores the app level settings
    // This is designed to store variables to differentiate between the Free and Pro version of the app
    @StateObject var rootSettings = RootSettings(
        isTextAloudPro: false,
        groupName: "uk.org.acecentre.Text.Aloud",
        appName: "TextAloud"
    )
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environmentObject(rootSettings)
        }
    }
}
