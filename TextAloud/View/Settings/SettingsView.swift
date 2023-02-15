//
//  SettingsView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 30.10.2022.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @StateObject var settingVM = SettingViewModel()
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        Group{
            if #available(iOS 16.0, *) {
                NavigationStack{
                    viewContainer
                }
            } else {
                NavigationView{
                    viewContainer
                }
            }
        }
        .sheet(isPresented: $settingVM.showVoicePicker) {
            VoicesPickerView(settingVM: settingVM)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


//MARK: - Setting view container
extension SettingsView{
    
    private var viewContainer: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                aboutGroupView
                customizationGroupView
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}


//MARK: - View components
extension SettingsView{
    private var aboutGroupView: some View{
        GroupBox(label: SettingsLabelView(labelText: "Text Aloud", labelImage: "info.circle")) {
            Divider().padding(.vertical, 4)
            Text("The Text Aloud application makes it easy to read any text that you write yourself, or import. Note to change voice settings go to Settings -> Accessibility -> Spoken Content -> Voices")
                .padding(.vertical, 8)
                .font(.footnote)
                .multilineTextAlignment(.leading)
            Divider().padding(.vertical, 4)
            voicePickerButton
        }
    }
    
    private var customizationGroupView: some View{
        GroupBox(label: SettingsLabelView(labelText: "customization", labelImage: "paintbrush")) {
            Divider().padding(.vertical, 4)
            Text("In this section, you can customize the appearance of the application. Choose a font size that is convenient for you, highlight and selection color")
                .padding(.vertical, 8)
                .font(.footnote)
                .multilineTextAlignment(.leading)
            
            Divider().padding(.vertical, 4)
            VStack {
                Text("Here's what the text will look like:")
                    .hLeading()
                HStack {
                    Text(settingVM.getNewString())
                        .font(.system(size: CGFloat(settingVM.fontSize)))
                        .fontWeight(.heavy)
                        .padding()
                }
                .hCenter()
                .background(.white)
                .cornerRadius(8)
                .padding()
            }
            Divider().padding(.vertical, 4)
            
            Group{
                ColorPicker("Pick selection color", selection: $settingVM.selectedColor, supportsOpacity: true)
                
                Divider().padding(.vertical, 4)
                
                ColorPicker("Pick word highlight color", selection: $settingVM.readingColor, supportsOpacity: true)
                
                Divider().padding(.vertical, 4)
                
                Stepper {
                    HStack {
                        Text("Font size")
                        Spacer()
                        Text("\(settingVM.fontSize)")
                    }
                } onIncrement: {
                    settingVM.incrementStep()
                } onDecrement: {
                    settingVM.decrementStep()
                }
            }
            .font(.headline.weight(.medium))
        }
    }
    
    
    private var voicePickerButton: some View{
        Button {
            settingVM.showVoicePicker.toggle()
        } label: {
            HStack{
                Text("Pick voice")
                Spacer()
                Text("\(settingVM.voiceModel.name) \(settingVM.voiceModel.languageStr)")
                    .lineLimit(1)
            }
        }
        .hLeading()
        .font(.headline.weight(.medium))
    }
}
