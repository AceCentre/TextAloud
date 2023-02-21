//
//  SettingsView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 30.10.2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var speech: SpeechSynthesizer
    @ObservedObject var settingVM: SettingViewModel
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
           VoiceListView(settingVM: settingVM)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SettingsView(speech: SpeechSynthesizer(), settingVM: SettingViewModel())
                .environment(\.locale, .init(identifier: "en"))
//          SettingsView(speech: SpeechSynthesizer(), settingVM: SettingViewModel())
//                .environment(\.locale, .init(identifier: "fr"))
//            SettingsView(speech: SpeechSynthesizer(), settingVM: SettingViewModel())
//                .environment(\.locale, .init(identifier: "zh_Hant_HK"))
//            SettingsView(speech: SpeechSynthesizer(), settingVM: SettingViewModel())
//                .environment(\.locale, .init(identifier: "de"))
//            SettingsView(speech: SpeechSynthesizer(), settingVM: SettingViewModel())
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
        
        NavigationLink {
            VoiceListView(settingVM: settingVM)
        } label: {
            HStack{
                Text(Localization.pickVoice.toString)
                Spacer()
                if let voiceModel = settingVM.selectedVoice{
                    Text("\(voiceModel.representableName) \(voiceModel.languageStr)")
                        .lineLimit(1)
                        .font(.callout.weight(.medium))
                }else{
                    ProgressView()
                }
            }
        }
        .hLeading()
        .font(.headline.weight(.medium))
    }
    
}
