//
//  IconView.swift
//  TextAloud
//
//

import SwiftUI

struct IconView: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
            Text(title)
                .font(.caption.weight(.medium))
            Text(subtitle ?? "")
                .font(.caption.weight(.light))
        }
        .padding(.vertical, 10)
        .foregroundColor(.deepOcean)
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(title: "Audio", subtitle: "Title", icon: "waveform.circle.fill")
    }
}
