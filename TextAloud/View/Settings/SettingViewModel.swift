//
//  SettingViewModel.swift
//  TextAloud
//
//

import SwiftUI
import Combine

class SettingViewModel: ObservableObject{
    
    @AppStorage("isAzureSpeech") var isAzureSpeech: Bool = false
    @AppStorage("selectedColor") var selectedColor: Color = Color(UIColor(red: 0.96, green: 0.9, blue: 0.258, alpha: 0.4))
    @AppStorage("readingColor") var readingColor: Color = Color.red
    @AppStorage("fontSize") var fontSize: Int = 25
    @AppStorage("activeVoiceId") var activeVoiceId: String = ""
    
    @AppStorage("timeUsedInSeconds") var timeUsedInSeconds: Double = 0
    @Published var timeCapInSeconds: Double = 60 * 120 // 2 Hours
    
    @Published var showVoicePicker: Bool = false

    @Published var selectedVoices = [VoiceModel]()
    @Published var voiceMode: VoiceMode = .apple
    @Published var lastPrimaryLanguage: String = ""
    private var cancellable = Set<AnyCancellable>()
    let maxCountLaunguges: Int = 5
    private let aVoiceService = AVSpeechVoiceService()
    private let azureVoiceService = AzureVoiceService()
    private let voiceSaveService = VoiceSaveService.shared
    
    init(){
        setVoiceMode()
        startVoiceSubscriptions()
    }

}

//MARK: - Voice
extension SettingViewModel{
    
    var allLanguages: [LanguageModel]{
        voiceMode == .azure ? azureVoiceService.languages : aVoiceService.languages
    }
    
    func trackSecondsUsed(secondsUsed: Double) {
        print("Tracking duration of", secondsUsed)
        self.timeUsedInSeconds += secondsUsed
    }
    
    var activeVoiceModel: VoiceModel?{
        selectedVoices.first(where: {$0.id == activeVoiceId})
    }
    
    func languages(for code: String) -> [LanguageModel]{
        voiceMode == .azure ? azureVoiceService.getLanguagesForCode(code) : aVoiceService.getLanguagesForCode(code)
    }
    
    func addOrRemoveVoice(for voice: VoiceModel){
        if voiceIsContains(for: voice.id){
            removeVoice(for: voice.id)
        }else{
            addVoice(for: voice)
        }
    }
    
    func voiceIsContains(for id: String) -> Bool{
        selectedVoices.contains(where: {$0.id == id})
    }
    
    func voiceIsActive(_ id: String) -> Bool{
        id == activeVoiceId
    }
    
    func toggleVoice(){
        guard let noActiveVoice = selectedVoices.first(where: {$0.id != activeVoiceId}) else { return }
        setActiveVoice(for: noActiveVoice)
    }
    
//    func changeVoice(_ voice: VoiceModel){
//        if voice.id == activeVoiceId{
//            setActiveVoice(for: voice)
//        }
//        if let index = selectedVoices.firstIndex(where: {$0.languageCode == voice.languageCode}){
//            selectedVoices[index] = voice
//        }
//    }
    
    func setActiveVoice(for voice: VoiceModel){
        isAzureSpeech = voice.type == .azure
        activeVoiceId = voice.id
    }
    
    private func startVoiceSubscriptions(){
        aVoiceService.$languages
            .combineLatest(azureVoiceService.$languages)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _, _ in
                guard let self = self else {return}
                self.setVoices()
            }
            .store(in: &cancellable)
    }
    
    private func setVoiceMode(){
        voiceMode = isAzureSpeech ? .azure : .apple
    }
    
    private func setVoices(){
        let defaultVoice = self.isAzureSpeech ? azureVoiceService.getVoicesModelForId(activeVoiceId) :
        aVoiceService.getVoicesModelForId(activeVoiceId)
        let voices = voiceSaveService.load() ?? [defaultVoice]
        selectedVoices = voices
        if activeVoiceId.isEmpty {
            activeVoiceId = defaultVoice.id
        }
    }
   
    func removeVoice(for id: String){
        selectedVoices.removeAll(where: {$0.id == id})
        voiceSaveService.save(selectedVoices)
    }
    
    private func addVoice(for voice: VoiceModel){
        if selectedVoices.count < maxCountLaunguges{
            selectedVoices.append(voice)
        }
        voiceSaveService.save(selectedVoices)
    }
}


//MARK: - View setings
extension SettingViewModel{
    func getNewString() -> AttributedString {
        
        let localizedKey = String.LocalizationValue(stringLiteral: Localization.simpleText.rawValue)
        
        let srt = String(localized: localizedKey)
        let words : [String] = srt.components(separatedBy: " ")
        
        var temp = AttributedString(localized: "simpleText")
        
        if let word1 = words.first, let rangeSelected = temp.range(of: word1),
           let word2 = words.last, let rangeReading = temp.range(of: word2){
            temp.foregroundColor = .black
            temp[rangeSelected].backgroundColor = selectedColor
            temp[rangeReading].foregroundColor = readingColor
        }
        
        return temp
    }
    
    func incrementStep() {
        fontSize += 1
    }

    func decrementStep() {
        fontSize -= 1
    }
}

