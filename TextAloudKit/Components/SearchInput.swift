//
//  SearchInput.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 28/04/2023.
//

import Foundation
import SwiftUI

public struct SearchInput: View {
    @Namespace var namespace
    @FocusState var isFocus: Bool
    @Binding var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        HStack {
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search", text: $text)
                    .focused($isFocus)
                    .matchedGeometryEffect(id: "TextField", in: namespace)
                if !text.isEmpty{
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color.init(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            if isFocus{
                Button {
                    text = ""
                    isFocus = false
                } label: {
                    Text("Cancel")
                        .foregroundColor(.deepOcean)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct SearchInput_Previews: PreviewProvider {
    static var previews: some View {
        SearchInput(text: .constant(""))
        SearchInput(text: .constant("United Kingdom"))
        SearchInput(text: .constant("")).preferredColorScheme(.dark)
        SearchInput(text: .constant("United Kingdom")).preferredColorScheme(.dark)
    }
}
