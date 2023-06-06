//
//  ButtonWithIconAndText.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 28/04/2023.
//

import Foundation
import SwiftUI

public struct ButtonWithIconAndText: View {
    let title: LocalizedStringKey?
    var image: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void
    let type: ButtonType
    
    
    public init(title: LocalizedStringKey?, image: String? = nil, isDisabled: Bool, type: ButtonType, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.isDisabled = isDisabled
        self.action = action
        self.type = type
    }
    
    public init(title: LocalizedStringKey?, image: String? = nil, type: ButtonType, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.isDisabled = false
        self.action = action
        self.type = type
    }
    
    public init(image: String? = nil, type: ButtonType, action: @escaping () -> Void) {
        self.image = image
        self.isDisabled = false
        self.action = action
        self.title = nil
        self.type = type
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
                if let title {
                    Text(title)
                }
            }
            .font(.title3.weight(.bold))
            .opacity(isDisabled ? 0.5 : 1)
        })
        .disabled(isDisabled)
        .scaledToFill()
        .buttonStyle(CustomButtonStyle(type: self.type))
    }
}

public enum ButtonType {
    case primary, secondary, basic
}


struct CustomButtonStyle: ButtonStyle {
    var type: ButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        if type == .primary {
            return AnyView(
                configuration.label
                    .padding(13)
                    .background(Color(red: 148 / 255, green: 198 / 255, blue: 78 / 255))
                    .clipShape(Capsule())
                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
            )
        } else if type == .secondary {
            return AnyView(
                configuration.label
                    .padding(13)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                    .overlay() {
                        Capsule()
                            .stroke(Color(red: 148 / 255, green: 198 / 255, blue: 78 / 255), lineWidth: 3)
                        
                    }
            )
        } else {
            return AnyView(
                configuration.label
                    .padding(13)
                    .foregroundColor(Color(red: 148 / 255, green: 198 / 255, blue: 78 / 255))
            )
        }
    }
}



struct ButtonWithIconAndText_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ButtonWithIconAndText(title: "Save", image: "checkmark", isDisabled: true, type: .primary, action: {})
            ButtonWithIconAndText(title: "Save", image: "checkmark", isDisabled: false, type: .secondary, action: {})
            ButtonWithIconAndText(title: "Import Document", image: "plus", isDisabled: false, type: .primary, action: {})
            ButtonWithIconAndText(title: "Settings", image: "slider.horizontal.3",type: .primary, action: {})
            ButtonWithIconAndText(image: "slider.horizontal.3",type: .primary, action: {})
            ButtonWithIconAndText(image: "slider.horizontal.3",type: .secondary, action: {})
            ButtonWithIconAndText(title: "Edit", image: "pencil",type: .basic, action: {})

        }
    }
}
