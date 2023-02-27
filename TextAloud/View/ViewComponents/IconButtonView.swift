//
//  IconView.swift
//  TextAloud
//
//

import SwiftUI

struct IconView: View {
    let title: String
    let icon: String
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
            Text(title)
                .font(.caption)
                .foregroundColor(.deepOcean)
        }
        .padding(.vertical, 10)
        .foregroundColor(.deepOcean)
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(title: "Audio", icon: "waveform.circle.fill")
    }
}
