//
//  VoiceListView.swift
//  TextAloud
//
//

import SwiftUI

struct VoiceListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedVoice: VoiceModel?
    var viewMode: ViewMode = .all
    @State var showAbotSheet: Bool = false
    @State var searchText: String = ""
    @ObservedObject var settingVM: SettingViewModel
    @ObservedObject var speech: SpeechSynthesizer
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack{
                    Picker(selection: $settingVM.voiceMode) {
                        ForEach(SettingViewModel.VoiceMode.allCases, id: \.self){mode in
                            Text(mode.title)
                                .tag(mode)
                        }
                    } label: {}.labelsHidden()
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    if !filteredLanguage.isEmpty{
                        List{
                            ForEach(filteredLanguage) { language in
                                sectionRowView(language)
                                    
                            }
                        }
                        .onAppear{
                            scrollToSelect(proxy)
                        }
                    }else{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .navigationTitle("Voices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    aboutBottom
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    bottomToolbarView
                }
            }
            .listStyle(.inset)
            .searchable(text: $searchText, placement: SearchFieldPlacement.navigationBarDrawer(displayMode: .always))
            .sheet(isPresented: $showAbotSheet) {
                VStack{
                    Text("Text about speech text systems and their functionality")
                }
            }
        }
        .onDisappear{
            speech.stop()
        }
    }
}

struct VoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceListView(selectedVoice: .constant(nil), settingVM: SettingViewModel(), speech: SpeechSynthesizer())
    }
}

extension VoiceListView{
    
    var filteredLanguage: [LanguageModel] {
        
        if searchText.isEmpty {
            return viewMode == .all ? settingVM.allLanguages : selectedLaunguages
        } else {
            return viewMode == .all ? settingVM.allLanguages.filter(filterLanguage) :
            selectedLaunguages.filter(filterLanguage)
        }
    }
    
    var selectedLaunguages: [LanguageModel]{
        guard let selectedVoice = selectedVoice else {return []}
        return settingVM.languages(for: selectedVoice.languageCode)
        
    }
    
    private func filterLanguage(_ laung: LanguageModel) -> Bool{
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
    
    private func sectionRowView(_ language: LanguageModel) -> some View{
        Section {
            ForEach(language.voices){voice in
                Button {
                    speech.activateSimple(language.simpleVoiceText, id: voice.id, type: voice.type)
                   
                    if !settingVM.voiceIsActive(voice.id){
//                        if viewMode == .onlyLanguage{
//                            selectedVoice = voice
//                            settingVM.changeVoice(voice)
//
                        settingVM.addOrRemoveVoice(for: voice)
                    }
                } label: {
                    voiceRowView(voice)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowBackground(isSelect(voice.id) ? Color.limeChalk.opacity(0.1) : .clear)
                .id(voice.id)
            }
        } header: {
            Text(language.languageStr)
                .font(.headline.bold())
        }
    }
    
    private func voiceRowView(_ voice: VoiceModel) -> some View{
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
            Group{
                if settingVM.voiceIsActive(voice.id){
                    Text("Active")
                        .font(.caption.bold())
                }
                if isSelect(voice.id){
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .foregroundColor(.limeChalk)
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
    
    
    private func scrollToSelect(_ proxy: ScrollViewProxy){
        if let id = selectedVoice?.id{
            proxy.scrollTo(id, anchor: .top)
        }
    }
    
    
    
    private var bottomToolbarView: some View{
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
    }
    
    enum ViewMode{
        case all, onlyLanguage
    }
}
