//
//  SpeachTextViewComponent.swift
//  TextAloud
//
//  Created by Богдан Зыков on 13.02.2023.
//

import SwiftUI

struct SpeachTextViewComponent: View {
    @Binding var currentWord: NSRange?
    @Binding var isEditing: Bool
    @Binding var text: String
    @Binding var focused: Bool
    var body: some View {
        GeometryReader { proxy in
            TextView(focused: $focused, text: $text, isEditing: $isEditing, currentWord: $currentWord)
                .padding(10)
                .frame(height: proxy.size.height)
                .background(.white)
                .cornerRadius(12)
                .overlay{
                    if focused{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.limeChalk, lineWidth: 3)
                    }
                }
        }
    }
}

struct SpeachTextViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.deepOcean
            SpeachTextViewComponent(currentWord: .constant(.init(location: 0, length: 5)), isEditing: .constant(false), text: .constant("test test test test"), focused: .constant(false))
                .frame(height: 400)
                .padding()
        }
    }
}
