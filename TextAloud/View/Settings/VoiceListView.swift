//
//  VoiceListView.swift
//  TextAloud
//
//

import SwiftUI
import TextAloudKit

struct VoiceListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedVoice: Voice?
    var viewMode: ViewMode = .all
    @State var showAbotSheet: Bool = false
    @State var searchText: String = ""
    @ObservedObject var settingVM: SettingViewModel
    @ObservedObject var speech: SpeechSynthesizer
    @State private var tappedVoiceId: String = ""
    var body: some View {
        VStack(spacing: 0){
            headerView
            if !filteredLanguage.isEmpty{
                List{
                    ForEach(filteredLanguage) { language in
                        sectionRowView(language)
                        
                    }
                }
            }else{
                Spacer()
                ProgressView()
                Spacer()
            }
            bottomToolbarView
        }
        .listStyle(.inset)
    }
}

struct VoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceListView(selectedVoice: .constant(nil), settingVM: SettingViewModel(), speech: SpeechSynthesizer())
    }
}


//MARK: - Header view
extension VoiceListView{
    private var headerView: some View{
        VStack(spacing: 16){
            Text("Voices")
                .font(.headline)
                .hCenter()
                .overlay(alignment: .leading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
            voiceSearchView
            voiceServicePisker
        }
        .padding()
    }
    
    private var voiceServicePisker: some View{
        Picker(selection: $settingVM.voiceMode) {
            ForEach(VoiceProvider.allCases, id: \.self){mode in
                Text(mode.title)
                    .tag(mode)
            }
        } label: {}.labelsHidden()
            .pickerStyle(.segmented)
    
    }
    
    private var voiceSearchView: some View{
        SearchInput(text: $searchText)
    }
}

extension VoiceListView{
    
    var filteredLanguage: [LanguageGroup] {
        
        if searchText.isEmpty {
            return viewMode == .all ? settingVM.allLanguages : selectedLaunguages
        } else {
            return viewMode == .all ? settingVM.allLanguages.filter(filterLanguage) :
            selectedLaunguages.filter(filterLanguage)
        }
    }
    
    var selectedLaunguages: [LanguageGroup]{
        guard let selectedVoice = selectedVoice else {return []}
        return settingVM.languages(for: selectedVoice.languageCode)
        
    }
    
    private func filterLanguage(_ laung: LanguageGroup) -> Bool{
        laung.languageStr.localizedCaseInsensitiveContains(searchText)
    }
    
    private func isSelect(_ id: String) -> Bool{
        switch viewMode{
        case .all:
            return settingVM.voiceIsContains(for: id)
        case .onlyLanguage:
            return selectedVoice?.id == id
        }
    }
    
    private func sectionRowView(_ language: LanguageGroup) -> some View{
        Section {
            ForEach(language.voices){voice in
                voiceRowView(voice, voiceText: language.sampleVoiceText)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !settingVM.voiceIsActive(voice.id){
                            settingVM.addOrRemoveVoice(for: voice)
                        }
                    }
                    .listRowBackground(isSelect(voice.id) ? Color.limeChalk.opacity(0.2) : .clear)
            }
        } header: {
            Text(language.languageStr)
                .font(.headline.bold())
        }
    }
    
    @ViewBuilder
    private func voiceRowView(_ voice: Voice, voiceText: String) -> some View{
        let isPlay: Bool = speech.isPlay && tappedVoiceId == voice.id
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.title)
            VStack(alignment: .leading){
                Text(voice.representableName)
                    .font(.headline.bold())
                Text(voice.gender.toStr)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            Spacer()
            if settingVM.voiceIsActive(voice.id){
                Text("Active")
                    .font(.subheadline.bold())
                    .foregroundColor(.limeChalk)
            }
            Spacer()
            Button {
                if isPlay{
                    speech.stop(for: voice.type)
                }else{
                    tappedVoiceId = voice.id
                    speech.activateSimple(voiceText, id: voice.id, type: voice.type)
                }
            } label: {
                Image(systemName: isPlay ? "stop.circle.fill" : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.deepOcean)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var aboutBottom: some View{
        Button {
            showAbotSheet.toggle()
        } label: {
            Image(systemName: "questionmark.circle.fill")
                .imageScale(.medium)
                .foregroundColor(.deepOcean)
        }
    }
    
    
    @ViewBuilder
    private var bottomToolbarView: some View{
        if !filteredLanguage.isEmpty{
            VStack {
                Divider()
                HStack(spacing: 30){
                    Text("Selected \(settingVM.selectedVoices.count)/\(settingVM.maxCountLaunguges)")
                        .font(.subheadline.weight(.medium))
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.headline.weight(.medium))
                            .foregroundColor(.deepOcean)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 5)
                .padding(.bottom, 5)
            }
        }
    }
    
    enum ViewMode{
        case all, onlyLanguage
    }
}
