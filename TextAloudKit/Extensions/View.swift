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
    
}
