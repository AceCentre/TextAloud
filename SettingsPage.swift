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
    @State var currentSettings: SettingsOptions = SettingsOptions.about
    
    public var body: some View {
   
                NavigationView {
                    ZStack {
                        Color(UIColor.systemGray6)
                            .edgesIgnoringSafeArea(.all)
                        ScrollView {
                            HStack{
                                GroupBox() {
                                    NavigationLink("Help Vidoes") {
                                        Text("Help Videos")
                                    }
                                    Divider()
                                    NavigationLink("About") {
                                        Text("About")
                                    }
                                }
                                .groupBoxStyle(WhiteGroupBox())
                                .padding()
                                
                            }
                            .navigationTitle("Settings")
                          
                        }
                    }
                }
    
       
        
    }
}

struct WhiteGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing:8) {
            configuration.content
        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white))
    
    }
}

enum SettingsOptions {
    case about, help
    
    var id: Self { self }
}

struct SettingsPreview: View {
    @StateObject var settings = SettingsState(isOpen: true)
    
    var body: some View {
        VStack {
            Text("Background")
        }.sheet(isPresented: .constant(true), content: {
            SettingsPage(settings: settings)
        })
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPreview()
    }
}
