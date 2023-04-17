//
//  ShareLoading.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 17/04/2023.
//

import Foundation
import SwiftUI

public class ImageProvider {
    // convenient for specific image
    public static func picture() -> UIImage {
        return UIImage(named: "Icon", in: Bundle(for: self), with: nil) ?? UIImage()
    }
}

public struct Loading: View {
    public init() {}
    
    public var body: some View {
        
        VStack {
            Text("Sending text to TextAloud").font(.title).bold().padding().multilineTextAlignment(.center)
            Image(uiImage: ImageProvider.picture()).resizable().scaledToFit().frame(maxWidth: 250)
            Spacer()

            ProgressView()
            Text("Text Aloud will open soon with your selected text.").padding()

            Spacer()
                .frame(maxHeight: .infinity)
            
            
        }
    
        
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test").sheet(isPresented: .constant(true)) {
            Loading()
        }
    }
}
