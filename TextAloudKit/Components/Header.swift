//
//  Header.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 11/05/2023.
//

import Foundation
import SwiftUI

struct Header<Destination>: View where Destination: View {
    var appName: String
    
    var clearAction: () -> Void
    var importAction: () -> Void
    
    @ViewBuilder var settingsView: () -> Destination
    
    public var body: some View {
            HStack {
                NavigationLinkWithIconAndText(
                    title: UIScreen.main.bounds.width < 500 ? nil : "Settings",
                    image: "slider.horizontal.3",
                    type: .primary,
                    destination: {
                        settingsView()
                    }
                )

                Text(appName)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.heavy)
                Spacer()
                ButtonWithIconAndText(title: UIScreen.main.bounds.width < 500 ? nil : "Clear", image: "trash.fill", type: .secondary, action: clearAction)
                    .padding(.horizontal)
                ButtonWithIconAndText(title: UIScreen.main.bounds.width < 500 ? nil : "Import", image:"plus", type: .secondary, action: importAction)
            }.padding(.horizontal)


        
        
      
        
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Header(appName: "TextAloud", clearAction: {}, importAction: {}, settingsView: { Text("Settings") })
            Header(appName: "TextAloud Pro", clearAction: {}, importAction: {}, settingsView: { Text("Settings") })
            Spacer().frame(maxHeight: .infinity)
            
        }.background(LinearGradient.fullBackground)

    
    
    }
}
