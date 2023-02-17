//
//  SettingsView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 30.10.2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var speech: SpeechSynthesizer
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
        Group{
            SettingsView(speech: SpeechSynthesizer())
                .environment(\.locale, .init(identifier: "en"))
//          SettingsView(rootVM: RootViewModel())
//                .environment(\.locale, .init(identifier: "fr"))
//           SettingsView(rootVM: RootViewModel())
//                .environment(\.locale, .init(identifier: "zh_Hant_HK"))
//           SettingsView(rootVM: RootViewModel())
//                .environment(\.locale, .init(identifier: "de"))
//            SettingsView(rootVM: RootViewModel())
//                .environment(\.locale, .init(identifier: "es"))
        }
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
        .navigationTitle(Localization.settings.toString)
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
        GroupBox(label: SettingsLabelView(labelText: "TextAloud", labelImage: "info.circle")) {
            Divider().padding(.vertical, 4)
            Text("aboutTextAloud \("TextAloud")")
                .padding(.vertical, 8)
                .font(.footnote)
                .multilineTextAlignment(.leading)
            Divider().padding(.vertical, 4)
            voiceServiceLinkView
            Divider().padding(.vertical, 4)
            voicePickerButton
        }
    }
    
    private var customizationGroupView: some View{
        GroupBox(label: SettingsLabelView(labelText: Localization.customization.toString, labelImage: "paintbrush")) {
            Divider().padding(.vertical, 4)
            Text(Localization.aboutCustomization.toString)
                .padding(.vertical, 8)
                .font(.footnote)
                .multilineTextAlignment(.leading)
            
            Divider().padding(.vertical, 4)
            VStack {
                Text(Localization.textWillLook.toString)
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
                ColorPicker(Localization.pickSelection.toString, selection: $settingVM.selectedColor, supportsOpacity: true)
                
                Divider().padding(.vertical, 4)
                
                ColorPicker(Localization.pickHighlight.toString, selection: $settingVM.readingColor, supportsOpacity: true)
                
                Divider().padding(.vertical, 4)
                
                Stepper {
                    HStack {
                        Text(Localization.fontSize.toString)
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
                Text(Localization.pickVoice.toString)
                Spacer()
                if let voiceModel = settingVM.currentVoice{
                    Text("\(voiceModel.name) \(voiceModel.languageStr)")
                        .lineLimit(1)
                }else{
                    ProgressView()
                }
            }
        }
        .hLeading()
        .font(.headline.weight(.medium))
    }
    
    private var voiceServiceLinkView: some View{
        Menu {
            Button("Apple"){
                settingVM.changeVoiceService(false)
            }
            
            Button("Azure"){
                settingVM.changeVoiceService(true)
            }
        } label: {
            HStack {
                Text("Speech service")
                Spacer()
                Text(settingVM.isAzureSpeech ? "Azure" : "Apple")
            }
            .font(.headline.weight(.medium))
            
        }
        .hLeading()
    }
}
