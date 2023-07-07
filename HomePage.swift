//
//  RootPage.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 11/05/2023.
//

import Foundation
import SwiftUI

public struct HomePage: View {
    @EnvironmentObject var rootSettings: RootSettings
    @StateObject var text: TextState = TextState()
    @StateObject var settings = SettingsState()
    @State var settingsModalOpen = true
    
    public init() {}
    
    public var body: some View {
        
            VStack {
                Header(
                    appName: rootSettings.appName,
                    clearAction: {
                        text.clear()
                    },
                    importAction: {},
                    settingsAction: {
                        settingsModalOpen = true
                    }
                )
                TextInputArea(text: text)
                Controls()
            }
            .background(LinearGradient(gradient: Gradient(colors: [.deepOcean, .lightOcean]), startPoint: .top, endPoint: .bottom))
            .sheet(isPresented: $settingsModalOpen, content: {
                SettingsPage(settings: settings)
            })
        

        
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(
                RootSettings(
                    isTextAloudPro: false,
                    groupName: "Preview",
                    appName: "TextAloud"
                )
            )
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("Home - iPhone")
        
        HomePage()
            .environmentObject(
                RootSettings(
                    isTextAloudPro: false,
                    groupName: "Preview",
                    appName: "TextAloud"
                )
            )
            .previewDevice(PreviewDevice(rawValue: "iPad (10th generation)"))
            .previewDisplayName("Home - iPad")
    }
}
