//
//  ErrorViewModif.swift
//  TextAloud
//
//

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

extension View {
    func handle(error: Binding<AppError?>) -> some View {
        modifier(ErrorHandleModifier(error: error))
    }
}


enum AppError: LocalizedError, Equatable{
    
    var id: String { UUID().uuidString }
    
    case unSupportedFile
    case importerError
    case messageError(String)
    case unknow(String)
    
    var errorDescription: String?{
        switch self {
        case .messageError(let message):
            return message
        case .unknow(let error):
            return "Unknown error \(error)"
        case .importerError: return "Error importing file, try again"
        case .unSupportedFile: return "Sorry, this file type is not yet supported"
        }
    }
}
