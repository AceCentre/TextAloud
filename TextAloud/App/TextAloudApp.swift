//
//  TextAloudApp.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 26.10.2022.
//

import SwiftUI

@main
struct TextAloudApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .defaultAppStorage(UserDefaults(suiteName: "group.uk.org.acecentre.Text.Aloud")!)
        }
    }
}
