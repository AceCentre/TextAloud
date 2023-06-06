//
//  Settings.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 25/05/2023.
//

import Foundation
import SwiftUI

public struct SettingsPage: View {
    @ObservedObject var settings: SettingsState
    
    public var body: some View {
        NavigationView {
            HStack{
                
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Close") {  }
            }
        }
    }
}

struct SettingsPreview: View {
    @StateObject var settings = SettingsState(isOpen: true)
    
    var body: some View {
        HStack {
        }.sheet(isPresented: .constant(true)) {
            SettingsPage(settings: settings)
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPreview()
    }
}
