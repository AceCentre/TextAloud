//
//  ButtonView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 26.10.2022.
//

import SwiftUI

struct ButtonView: View {
    
    var buttonText: LocalizedStringKey
    var buttonIcon: String
    var withIcon: Bool = true
    var isDisabled: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            HStack(spacing: 8) {
                Text(buttonText)
                    .font(.title2.weight(.heavy))
                if withIcon {
                    Image(systemName: buttonIcon)
                        .font(.title)
                }
            }
            .frame(width: 150, height: 55)
            .background{
                Capsule().strokeBorder(Color("Lime Chalk"), lineWidth: 30)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 4)
            }
        }
        .foregroundColor(.white)
        .opacity(isDisabled ? 0.6 : 1)
        .disabled(isDisabled)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ButtonView(buttonText: "Stop", buttonIcon: "stop.circle", withIcon: true, action: {})
            ButtonView(buttonText: "Play", buttonIcon: "play.circle", withIcon: true, isDisabled: true, action: {})
//                .preferredColorScheme(.dark)
//                .previewLayout(.sizeThatFits)
        }
       
    }
}
