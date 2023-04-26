//
//  HelpsView.swift
//  TextAloud
//
//

import SwiftUI
import TextAloudKit

struct HelpsBlockView: View {
    let supportLink = "https://docs.acecentre.org.uk/products/v/textaloud/"
    let contactLink = "https://forms.office.com/Pages/ResponsePage.aspx?id=bFwgTJtTgU-Raj-O_eaPrNZFPqw5Il9Hp4B1mWQ_eQhUNzBFOEhKWFEwUVhBTEYzQkFIQTRMTjhaSS4u"
    let privacyLink = "https://docs.acecentre.org.uk/products/v/textaloud/privacy"
    var body: some View {
        Group{
            GroupBox(label: SettingsLabelView(labelText: Localization.help.toString, labelImage: "questionmark.circle")) {
                Divider().padding(.vertical, 4)
                linkView("Support Centre", link: supportLink)
                Divider().padding(.vertical, 4)
                linkView("Contact Us", link: contactLink)
            }
            GroupBox(label: SettingsLabelView(labelText: "About TextAloud", labelImage: "questionmark.circle")) {
                Divider().padding(.vertical, 4)
                linkView("Terms & Privacy Policy", link: privacyLink)
                Divider().padding(.vertical, 4)
                HStack{
                    Text("Version")
                        .font(.callout.weight(.medium))
                    Spacer()
                    Text(Bundle.main.appVersionShort)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct HelpsBlockView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            HelpsBlockView()
        }
    }
}


extension HelpsBlockView{
    
    @ViewBuilder
    private func linkView(_ title: String, link: String) -> some View{
        if let url = URL(string: link){
            Link(destination: url) {
                HStack{
                    Text(title)
                        .font(.callout.weight(.medium))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
        }else{
            Text(title)
        }
    }
}

