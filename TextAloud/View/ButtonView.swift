//
//  ButtonView.swift
//  TextAloud
//
//  Created by Will Wade on 26.10.2022.
//

import SwiftUI

struct ButtonView: View {
    
    var buttonText:String
    var buttonIcon:String
    var withIcon:Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            HStack(spacing: 8) {
                Text(buttonText)
                    .fontWeight(.heavy)
                
                if withIcon {
                    Image(systemName: buttonIcon)
                        .imageScale(.large)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color("Lime Chalk"), lineWidth: 30)
            )
        })
        .accentColor(Color.white)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 4, x: 2, y: 4)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(buttonText: "Play", buttonIcon: "play.circle", withIcon: true, action: {})
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
