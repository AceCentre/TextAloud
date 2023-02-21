//
//  VoiceListView.swift
//  TextAloud
//
//  Created by Богдан Зыков on 21.02.2023.
//

import SwiftUI

struct VoiceListView: View {
    @State var showAbotSheet: Bool = false
    @State var searchText: String = ""
    @ObservedObject var settingVM: SettingViewModel
    var body: some View {
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
            .onChange(of: settingVM.voiceMode) { _ in
                scrollToSelect(proxy)
            }
        }
        .navigationTitle("Voices")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                aboutBottom
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
}

struct VoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VoiceListView(settingVM: SettingViewModel())
        }
    }
}

extension VoiceListView{
    var filteredLanguage: [LanguageModel] {
        if searchText.isEmpty {
            return settingVM.languages
        } else {
            return settingVM.languages.filter({$0.languageStr.localizedCaseInsensitiveContains(searchText) || $0.voices.contains(where: {$0.representableName.localizedCaseInsensitiveContains(searchText)})})
        }
    }
    
    private func sectionRowView(_ language: LanguageModel) -> some View{
        Section {
            ForEach(language.voices){voice in
                Button {
                    settingVM.changeVoice(voice)
                } label: {
                    voiceRowView(voice)
                        .contentShape(Rectangle())
                        .id(voice.id)
                        
                }
                .buttonStyle(.plain)
                .listRowBackground(voice.id == settingVM.selectedVoice?.id ? Color.lightOcean.opacity(0.2) : .clear)
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
            if voice.id == settingVM.selectedVoice?.id{
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.deepOcean)
            }
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
        if let id = settingVM.selectedVoice?.id{
            proxy.scrollTo(id, anchor: .top)
        }
    }
}
