//
//  HelpsView.swift
//  TextAloud
//
//  Created by Bogdan Zykov on 06.03.2023.
//

import SwiftUI

struct HelpsView: View {
    let supportLink = "https://docs.acecentre.org.uk/products/v/textaloud/"
    let contactLink = "https://forms.office.com/Pages/ResponsePage.aspx?id=bFwgTJtTgU-Raj-O_eaPrNZFPqw5Il9Hp4B1mWQ_eQhUNzBFOEhKWFEwUVhBTEYzQkFIQTRMTjhaSS4u"
    let privacyLink = "https://docs.acecentre.org.uk/products/v/textaloud/privacy"
    var body: some View {
        List {
            linkView("Support Centre", link: supportLink)
            linkView("Contact Us", link: contactLink)
            Section {
                HStack{
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.appVersionShort)
                        .foregroundColor(.secondary)
                }
                linkView("Terms & Privacy Policy", link: privacyLink)
            } header: {
                Text("About TextAloud")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Help")
    }
}

struct HelpsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HelpsView()
        }
    }
}


extension HelpsView{
    
    @ViewBuilder
    private func linkView(_ title: String, link: String) -> some View{
        if let url = URL(string: link){
            Link(destination: url) {
                HStack{
                    Text(title)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        }else{
            Text(title)
        }
    }
}


extension Bundle{
    
    var appVersionShort: String {
        guard let result = infoDictionary?["CFBundleShortVersionString"] as? String else {return ""}
        return result
    }
    
    var appVersionLong: String {
        guard let result = infoDictionary?["CFBundleVersion"] as? String else {return ""}
        return result
    }
}
