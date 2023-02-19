//
//  TextButtonView.swift
//  TextAloud
//
//

import SwiftUI

struct TextButtonView: View {
    let title: LocalizedStringKey
    var image: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if let image{
                    Image(systemName: image)
                }
                Text(title)
            }
            .font(.title3.weight(.bold))
            .foregroundColor(.limeChalk)
            .opacity(isDisabled ? 0.5 : 1)
        }
        .disabled(isDisabled)
    }
}

struct TextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            TextButtonView(title: Localization.save.toString, image: "checkmark", isDisabled: true, action: {})
            TextButtonView(title: Localization.edit.toString, image: "highlighter", isDisabled: false, action: {})
            //TextButtonView(title: Localization.cancel.toString, image: "xmark", isDisabled: false, action: {})
        }
    }
}
