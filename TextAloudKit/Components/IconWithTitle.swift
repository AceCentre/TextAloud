//
//  IconWithTitle.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 28/04/2023.
//

import Foundation
import SwiftUI

public struct IconWithTitle: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    
    public init(title: String, subtitle: String? = nil, icon: String) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
    
    public var body: some View {
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

struct IconWithTitle_Previews: PreviewProvider {
    static var previews: some View {
        IconWithTitle(title: "Audio", subtitle: "Title", icon: "waveform.circle.fill")
    }
}
