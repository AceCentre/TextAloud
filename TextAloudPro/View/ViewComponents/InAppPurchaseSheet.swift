//
//  InAppPurchaseSheet.swift
//  TextAloud
//
//  Created by Gavin Henderson on 21/03/2023.
//

import SwiftUI

struct InAppPurchaseSheet: View {
    var onPurchaseClick: () -> ()
    @State var disableButton: Bool = false
    
    private var viewContainer: some View{
        VStack {
            Text("Free Trial Expired").font(.title).bold().padding()
            
            Spacer()
            VStack {
                
                
                Image("Icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(25)
                    .shadow(radius: 10)
                
                Text("Thank you for using TextAloud!").bold()
            }.padding()
            Spacer()
            
            Text("You have used up all the time given to you during your free trial. To continue using TextAloud you have to upgrade to the paid version. This allows Ace Centre to pay for the voice servies and continue development on TextAloud.").padding(.top).padding(.horizontal)
            
            Spacer()
                .frame(maxHeight: .infinity)
            
            
            (
                Text("If your organisation does not support purchasing 'In-App Purchases' then you can ")
                +
                Text("[click here to buy the Pro version of TextAloud](https://apps.apple.com/gb/app/textaloud-pro-text-to-speech/id6446679219)")
                    .underline()
                +
                Text(" on the App Store which includes unlimited time.")
            )
                .italic()
                .padding(.horizontal)
                .accentColor(.blue)
                
               
            
            
           
            Button(action: {
                    disableButton = true
                    onPurchaseClick()
            }) {
                Text("Purchase Unlimited Time")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(10)
            }
            .buttonStyle(.borderedProminent)
            .disabled(disableButton)
            .tint(.blue)
            .buttonBorderShape(.capsule)
            .padding()
        }
        .padding(.top)
        
    }
    
    var body: some View {
        viewContainer
    }
}


struct InAppPurchaseSheet_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true)) {
                InAppPurchaseSheet( onPurchaseClick: {
                    print("Purchase")
                })
            }
    }
}
