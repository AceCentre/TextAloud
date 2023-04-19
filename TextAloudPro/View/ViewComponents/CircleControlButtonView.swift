//
//  CircleControlButtonView.swift
//  TextAloud
//
//

import SwiftUI

struct CircleControlButtonView: View {
    var isPlay: Bool
    var isDisabled: Bool = false
    var isSmall: Bool = false
    var action: () -> Void
    
    private var size: CGFloat{
        isSmall ? 45 : 65
    }
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isPlay ? "stop.fill" : "play.fill")
                .font(.system(size: isSmall ? 20 : 30))
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background{
                    Circle()
                        .fill(Color.limeChalk)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 4)
                }
                .opacity(isDisabled ? 0.7 : 1)
        }
        .keyboardShortcut(isPlay ? .escape : .return)
        .disabled(isDisabled)
    }
}

struct CircleControlButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CircleControlButtonView(isPlay: false, action: {})
            CircleControlButtonView(isPlay: true, isSmall: true, action: {})
        }
       
    }
}
