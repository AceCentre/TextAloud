//
//  ProgressBar.swift
//  TextAloudKit
//
//  Created by Aman Bind on 11/07/24.
//

import SwiftUI

struct ProgressBar: View {
    var value: CGFloat
    var total: CGFloat
    let color: Color
    
    let xOffset: CGFloat = 3

    var progress: CGFloat {
        value / total
    }

    public init(value: Int, total: Int, color: Color) {
        self.value = CGFloat(value)
        self.total = CGFloat(total)
        self.color = color
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(color.opacity(0.5))
                    .overlay {
                        HStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(color)
                                .padding(2)
                                .frame(width: max(geometry.size.width * progress, 12), height: 12)
                                .animation(.easeInOut(duration: 0.5), value: progress)

                            Spacer(minLength: 0)
                        }
                    }
            }
            
        }
        .frame(height: 12)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            
            ProgressBar(value: 12, total: 50, color: .orange)
            
            ProgressBar(value: 25, total: 50, color: .limeChalk)

            ProgressBar(value: 37, total: 50, color: .lightOcean)

            ProgressBar(value: 50, total: 50, color: .deepOcean)
        }
        .padding()
    }
}
