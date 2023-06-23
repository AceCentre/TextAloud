//
//  NavigationLinkWithIconAndText.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 23/06/2023.
//

import Foundation
import SwiftUI

struct NavigationLinkWithIconAndText<Destination>: View where Destination: View {
    let title: LocalizedStringKey?
    var image: String? = nil
    var isDisabled: Bool = false
    let type: ButtonType
    @ViewBuilder var destination: () -> Destination
    
    public init(title: LocalizedStringKey?, image: String? = nil, isDisabled: Bool, type: ButtonType, destination: @escaping () -> Destination) {
        self.title = title
        self.image = image
        self.isDisabled = isDisabled
        self.destination = destination
        self.type = type
    }
    
    public init(title: LocalizedStringKey?, image: String? = nil, type: ButtonType, destination: @escaping () -> Destination) {
        self.title = title
        self.image = image
        self.isDisabled = false
        self.destination = destination
        self.type = type
    }
    
    public init(image: String? = nil, type: ButtonType, destination: @escaping () -> Destination) {
        self.image = image
        self.isDisabled = false
        self.destination = destination
        self.title = nil
        self.type = type
    }
    
    
    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack {
                if let image = self.image {
                    Image(systemName: image)
                }
                if let title = self.title {
                    Text(title)
                }
                  
                
            }
            .padding(13)
            
            .font(.title3.weight(.bold))
            .foregroundColor(Color(red: 1, green: 1, blue: 1))
            .if(type == .primary) { view in
                view
                    .background(Color(red: 148 / 255, green: 198 / 255, blue: 78 / 255))
                    .clipShape(Capsule())
            }
            .if(type == .secondary) { view in
                    view.overlay() {
                        Capsule()
                            .stroke(Color(red: 148 / 255, green: 198 / 255, blue: 78 / 255), lineWidth: 3)
                        
                    }
            }
            
            
            
        }
    }
}


struct NavigationLinkWithIconAndText_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            NavigationLinkWithIconAndText(title: "Save", image: "checkmark", isDisabled: true, type: .primary, destination: {Text("destination")})
            NavigationLinkWithIconAndText(title: "Save", image: "checkmark", isDisabled: false, type: .secondary, destination: {Text("destination")})
            NavigationLinkWithIconAndText(title: "Import Document", image: "plus", isDisabled: false, type: .primary, destination: {Text("destination")})
            NavigationLinkWithIconAndText(title: "Settings", image: "slider.horizontal.3",type: .primary,  destination: {Text("destination")})
            NavigationLinkWithIconAndText(image: "slider.horizontal.3",type: .primary, destination: {Text("destination")})
            NavigationLinkWithIconAndText(image: "slider.horizontal.3",type: .secondary,  destination: {Text("destination")})
            NavigationLinkWithIconAndText(title: "Edit", image: "pencil",type: .basic,  destination: {Text("destination")})

        }
    }
}
