//
//  ThankYouSheet.swift
//  TextAloud
//
//  Created by Gavin Henderson on 23/03/2023.
//

import SwiftUI

public struct ThankYouSheet: View {
    var onContinue: () -> ()
    
    public init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
    }
    
    public var body: some View {
        VStack {
            Text("Thank you for purchasing TextAloud!").font(.title).bold().padding().multilineTextAlignment(.center)
            Image("AceLogo").resizable().scaledToFit().frame(maxWidth: 250)
            Spacer()
            Spacer()

            Text("You can now enjoy all the voices we have availble for as long as you want. Thank you for choosing to support Ace Centre and our future development of TextAloud.").padding()

            Spacer()
                .frame(maxHeight: .infinity)
            
            Button(action: {
                    onContinue()
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .buttonBorderShape(.capsule)
            .padding()
        }
    }
}

struct ThankYouSheet_Previews: PreviewProvider {
    static var previews: some View {
        Text("Thanks").sheet(isPresented: .constant(true)) {
            ThankYouSheet() {
                print("Continue")
            }
        }
    }
}
