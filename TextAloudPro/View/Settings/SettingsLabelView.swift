//
//  SettingsLabelView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 30.10.2022.
//

import SwiftUI

struct SettingsLabelView: View {
    var labelText: LocalizedStringKey
    var labelImage:String
    
    var body: some View {
        HStack {
            Text(labelText).fontWeight(.bold)
            Spacer()
            Image(systemName: labelImage)
        }
    }
}

struct SettingsLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLabelView(labelText: "testdata", labelImage: "info.circle")
    }
}
