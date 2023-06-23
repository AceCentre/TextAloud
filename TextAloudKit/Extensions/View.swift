//
//  View.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 20/04/2023.
//

import SwiftUI

extension View{
    
    public func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
    
    public func hCenter() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }

    public func hLeading() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    public func handle(error: Binding<AppError?>) -> some View {
        modifier(ErrorHandleModifier(error: error))
    }
    
    /// https://www.avanderlee.com/swiftui/conditional-view-modifier/
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
}
