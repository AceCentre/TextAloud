//
//  LeaveReview.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 21/04/2023.
//

import Foundation
import SwiftUI
import StoreKit

struct EmptyView: View {
    var body: some View { Text("") }
}

public struct LeaveReviewLink: View {
    var label: String
    
    @State private var isPushed = false
    
    public init(label: String) {
        self.label = label
    }
    
    public var body: some View {
        
        Button(action: {
            guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            
            SKStoreReviewController.requestReview(in: currentScene)
        }, label: {
            HStack{
                Text(label)
                    .font(.callout.weight(.medium))
                Spacer()
                Image(systemName: "chevron.right")
            }
        })
        
        
        
    }
    
    
}
