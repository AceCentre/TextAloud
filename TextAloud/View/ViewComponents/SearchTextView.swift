//
//  SearchTextView.swift
//  TextAloud
//
//

import SwiftUI

struct SearchTextView: View {
    @Namespace var namespace
    @FocusState var isFocus: Bool
    @Binding var text: String
    var body: some View {
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

struct SearchTextView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextView(text: .constant(""))
    }
}
