//
//  ButtonWithIconAndText.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 28/04/2023.
//

import Foundation
import SwiftUI

public struct ButtonWithIconAndText: View {
    let title: LocalizedStringKey
    var image: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void
    
    public init(title: LocalizedStringKey, image: String? = nil, isDisabled: Bool, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action:  {
            action()
        },
               label: {
            HStack {
                if let image{
                    Image(systemName: image)
                }
                Text(title)
            }
            .font(.title3.weight(.bold))
            .foregroundColor(.limeChalk)
            .opacity(isDisabled ? 0.5 : 1)
        })
        .disabled(isDisabled)
        .scaledToFill()
        
    }
}

struct ButtonWithIconAndText_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ButtonWithIconAndText(title: Localization.save.toString, image: "checkmark", isDisabled: true, action: {})
            ButtonWithIconAndText(title: Localization.edit.toString, image: "highlighter", isDisabled: false, action: {})
        }
    }
}
