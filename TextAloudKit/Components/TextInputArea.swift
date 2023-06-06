//
//  TextInputArea.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 17/05/2023.
//

import UIKit
import SwiftUI
import Foundation

public struct CustomTextView: UIViewRepresentable {
    @ObservedObject var text: TextState
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        if text.refreshRawText == true {
            uiView.text = text.rawText
        }
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        
        return textView
    }
}

public struct TextInputArea: View {
    @ObservedObject var text: TextState
    
    public var body: some View {
        CustomTextView(text: text)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

struct TextInputArea_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TextInputArea(text: TextState())
        }.background(LinearGradient.fullBackground)

    }
}
