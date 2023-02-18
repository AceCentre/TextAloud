//
//  VoicesPickerView.swift
//  TextAloud
//
//

import SwiftUI
import Combine

struct VoicesPickerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settingVM: SettingViewModel
  
    var voices: [VoiceModel] {
        settingVM.voicesForLanguage
    }
    
    var uniquedLanguagesCodes: [String]{
        settingVM.uniquedLanguagesCodes
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            if !uniquedLanguagesCodes.isEmpty{
                Label("Languages", systemImage: "globe")
                    .foregroundColor(.deepOcean)
                Picker(selection: $settingVM.selectedLanguageCode) {
                    ForEach(uniquedLanguagesCodes, id: \.self) { code in
                        Text(code.getFullLocaleLanguageStr)
                            .tag(code)
                    }
                } label: {}.labelsHidden()
                .pickerStyle(.wheel)
                .onChange(of: settingVM.selectedLanguageCode) { newValue in
                    if let id = voices.first?.id{
                        settingVM.tempVoiceId = id
                    }
                }

                if !settingVM.tempVoiceId.isEmpty{
                    Label("Voices", systemImage: "person.fill")
                        .foregroundColor(.deepOcean)
                    Picker(selection: $settingVM.tempVoiceId) {
                        ForEach(voices) { voice in
                            Text(voice.representableName)
                                .tag(voice.id)
                        }
                    } label: {}.labelsHidden()

                    .pickerStyle(.wheel)
                }

                HStack{
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Button("Save") {
                        settingVM.saveVoice()
                        dismiss()
                    }
                }
                .font(.title3.bold())
                .padding(.horizontal)
                Spacer()
            }else{
                Text("aboutTextAloud \("TextAloud")")
                    .font(.title3.weight(.medium))
                Button("Ok") {
                    dismiss()
                }
                .font(.title3.bold())
            }
           
        }
        .padding(.top, 30)
        .padding(.horizontal)
    }
}

struct VoicesPickerView_Previews: PreviewProvider {
    static var previews: some View {
        VoicesPickerView(settingVM: SettingViewModel())
    }
}
