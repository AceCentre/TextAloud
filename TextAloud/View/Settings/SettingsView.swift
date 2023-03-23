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
                voiceAllowanceView
                HelpsBlockView()
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

extension SettingsView {
    var timeUsedInMinutesLabel: String {
        let measurment = Measurement(value: settingVM.timeUsedInSeconds.rounded(), unit: UnitDuration.seconds)
        let formatter = MeasurementFormatter()
        
        formatter.unitStyle = .long
        formatter.unitOptions = .naturalScale
        
        return formatter.string(from: measurment)
    }
    
    var timeLeftInMinutesLabel: String = "Unlimited"
    
    private var voiceAllowanceView: some View {
        Group{
            GroupBox(label: SettingsLabelView(labelText: "Voice Allowance", labelImage: "clock")) {
                Divider().padding(.vertical, 4)
                HStack{
                    Text("Used")
                        .font(.callout.weight(.medium))
                    Spacer()
                    Text(timeUsedInMinutesLabel)
                        .foregroundColor(.secondary)
                }
                Divider().padding(.vertical, 4)
                HStack{
                    Text("Left")
                        .font(.callout.weight(.medium))
                    Spacer()
                    Text(timeLeftInMinutesLabel)
                        .foregroundColor(.secondary)
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
            languageLink
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
    
   
    
    private var languageLink: some View{
        NavigationLink {
            LanguageSpeechView()
                .environmentObject(speech)
                .environmentObject(settingVM)
        } label: {
            Text("Language and Speech")
                .font(.callout.weight(.medium))
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
//    private var helpLink: some View{
//        NavigationLink {
//            HelpsView()
//        } label: {
//            Text("Help")
//                .font(.callout.weight(.medium))
//            Spacer()
//            Image(systemName: "chevron.right")
//        }
//    }
}
