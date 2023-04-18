//
//  ShareLoading.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 17/04/2023.
//

import Foundation
import SwiftUI

 struct LoadingPage: View {
    var title: String
    var subtitle: String
        
    var body: some View {
        
        VStack {
            Text(title).font(.title).bold().padding().multilineTextAlignment(.center)
            
            Image(nameForAssetInTextAloudKit: "Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(25)
                .shadow(radius: 10)
            Spacer()
            ProgressView()
            Text(subtitle).padding()
            Spacer().frame(maxHeight:.infinity)
            
        }
    }
}

public struct ShareLoadingPage: View {
    public init() {}
    
    public var body: some View {
        LoadingPage(
            title: "Sending text to TextAloud",
            subtitle: "Text Aloud will open soon with your selected text."
        )
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test").sheet(isPresented: .constant(true)) {
            ShareLoadingPage()
        }
    }
}
