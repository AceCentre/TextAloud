//
//  TextSelectionDropDown.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 22/05/2023.
//

import Foundation
import SwiftUI

public struct TextSelectionDropDown: View {
    @Binding var textSelectionMode: TextSelectionEnum
    
    public var body: some View {
        Menu {
            ForEach(TextSelectionEnum.allCases, id: \.self) { type in
                Button(type.locale){
                    textSelectionMode = type
                }
            }
        } label: {
            Text(textSelectionMode.locale)
                .font(.title3.weight(.bold))
                .foregroundColor(.limeChalk)
                .frame(width: 120, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

/// This is not meant for usage in an app, this is just here to store state for the preview
struct TextSelectionDropDown_PreviewStateWrapper: View {
    @State var textSelectionMode: TextSelectionEnum = .all

    var body: some View {
        TextSelectionDropDown(textSelectionMode: $textSelectionMode)
    }
}

struct TextSelectionDropDown_Previews: PreviewProvider {
    @State var textSelectionMode: TextSelectionEnum = .all
    
    static var previews: some View {
        ZStack {
            TextSelectionDropDown_PreviewStateWrapper()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.fullBackground)
    }
}
