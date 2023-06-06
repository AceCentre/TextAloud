//
//  Controls.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 19/05/2023.
//

import Foundation
import SwiftUI

public struct Controls: View {
    /// TODO This should be passed through
    @State var textSelectionMode: TextSelectionEnum
    
    public init() {
        self.textSelectionMode = .word
    }
    
    public var body: some View {
        VStack{
            HStack{
                TextSelectionDropDown(textSelectionMode: $textSelectionMode).frame(maxWidth: .infinity, alignment: .leading)
                ButtonWithIconAndText(title: "Edit", image: "pencil", type: ButtonType.basic, action: {}).frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                IconWithTitle(
                    title: "Test",
                    subtitle: "Test",
                    icon: "globe"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                PlayButton() {
                    
                }
                .frame(maxWidth: .infinity)
                Spacer().frame(maxWidth: .infinity)
                
            }.padding(.horizontal)
        }
    }
}

struct Controls_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Controls()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.fullBackground)
    }
}
