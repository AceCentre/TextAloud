//
//  LanguageSpeechView.swift
//  TextAloud
//
//

import SwiftUI

struct LanguageSpeechView: View {
    @Environment(\.dismiss) var dismiss
    var isSheetView: Bool = false
    @State var sheet: SheetMode?
    @EnvironmentObject var settingVM: SettingViewModel
    @EnvironmentObject var speech: SpeechSynthesizer
    @State var selectedVoice: VoiceModel?
    var body: some View {
        List {
            ForEach(settingVM.selectedVoices) { voice in
                
               rowView(voice)
                .listRowBackground(settingVM.voiceIsActive(voice.id) ? Color.limeChalk.opacity(0.1) : .clear)
                .padding(.vertical, 5)
                
                .swipeActions(edge: .trailing) {
                    if !settingVM.voiceIsActive(voice.id){
                        Button(role: .destructive) {
                            settingVM.removeVoice(for: voice.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Language and Speech")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    sheet = .addNew
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.limeChalk)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                if isSheetView{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .sheet(item: $sheet){ item in
            VoiceListView(selectedVoice: $selectedVoice, viewMode: item == .edit ? .onlyLanguage : .all, settingVM: settingVM, speech: speech)
        }
    }
}

struct LanguageSpeechView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LanguageSpeechView()
        }
        .environmentObject(SettingViewModel())
        .environmentObject(SpeechSynthesizer())
    }
}

extension LanguageSpeechView{
    
    private func rowView(_ voice: VoiceModel) -> some View{
        HStack {
            VStack(alignment: .leading, spacing: 10){
                Button {
                    settingVM.setActiveVoice(for: voice)
                    speech.removeAudio()
                    if isSheetView{
                        dismiss()
                    }
                } label: {
                    HStack {
                        Text(voice.languageStr)
                            .font(.callout.weight(.medium))
                        Text(voice.type.title)
                            .font(.caption.weight(.medium))
                    }
                }
                
                Text("\(voice.representableName)")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }.lineLimit(1)
            
            Spacer()
            
            if settingVM.voiceIsActive(voice.id){
                HStack {
                    Text("Active")
                    Image(systemName: "checkmark.circle.fill")
                }.foregroundColor(.limeChalk)
            }
        }
    }
    
    enum SheetMode: Int, Identifiable{
        var id: Int {self.rawValue}
        case addNew, edit
    }
}
