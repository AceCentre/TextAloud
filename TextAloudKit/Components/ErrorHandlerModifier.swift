//
//  ErrorHandlerModifier.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 28/04/2023.
//

import Foundation
import SwiftUI

public struct ErrorHandleModifier: ViewModifier {
    @Binding var error: AppError?
    @State private var showAlert: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .alert(error?.errorDescription ?? "Error", isPresented: $showAlert) {
                Button("OK") {
                    error = nil
                }
            }
            .onChange(of: error) { newValue in
                showAlert = newValue != nil ? true : false
            }
    }
}
