//
//  ActivityView.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 20/04/2023.
//

import SwiftUI
import Foundation

/**
 ActivityView is used to create a share sheet for any content that you want.
 
 Example Usage:
 ```
 struct ContentView: View {
     // 3. Share Text State
     @State var shareText: ActivityItems?
     
     var body: some View {
         Button("Show Activity View") {
             // 4. New Identifiable Share Text
             shareText = ActivityItems(["Text to share"])
         }
         // 5. Sheet to display Share Text
         .sheet(item: $shareText) { shareItem in
             ActivityView(text: shareItem.activityItems)
         }
     }
 }

 ```
 
 Adapted from: https://stackoverflow.com/questions/69892283/create-a-share-sheet-in-ios-15-with-swiftui
 */
public struct ActivityView: UIViewControllerRepresentable {
    public let activityItems: [Any]
    
    public init(activityItems: [Any]) {
        self.activityItems = activityItems
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

public struct ActivityItems: Identifiable {
    public let id = UUID()
    public let activityItems: [Any]
    
    public init(_ activityItems: [Any]) {
        self.activityItems = activityItems
    }
}
