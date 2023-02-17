//
//  CircleControlButtonView.swift
//  TextAloud
//
//  Created by Богдан Зыков on 17.02.2023.
//

import SwiftUI

struct CircleControlButtonView: View {
    var isPlay: Bool
    var isDisabled: Bool = false
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isPlay ? "stop.fill" : "play.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
                .background{
                    Circle()
                        .fill(Color.limeChalk)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 4)
                }
                .opacity(isDisabled ? 0.7 : 1)
        }
        .keyboardShortcut(isPlay ? .escape : .space)
        .disabled(isDisabled)
    }
}

struct CircleControlButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CircleControlButtonView(isPlay: false, action: {})
            CircleControlButtonView(isPlay: true, action: {})
        }
       
    }
}
