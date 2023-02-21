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
    
    @Published var showVoicePicker: Bool = false

    @Published var selectedVoice: VoiceModel?
    @Published var voiceMode: VoiceMode = .apple
    
    private var cancellable = Set<AnyCancellable>()
    
    private let aVoiceService = AVSpeechVoiceService()
    private let azureVoiceService = AzureVoiceService()
        
    init(){
        setVoiceMode()
        startVoiceSubscriptions()
    }

}

//MARK: - Voice
extension SettingViewModel{
    
    var languages: [LanguageModel]{
        voiceMode == .azure ? azureVoiceService.languages : aVoiceService.languages
    }
    
    func changeVoice(_ voice: VoiceModel){
        isAzureSpeech = voice.type == .azure
        activeVoiceId = voice.id
        selectedVoice = voice
    }
    
    private func startVoiceSubscriptions(){
        aVoiceService.$languages
            .combineLatest(azureVoiceService.$languages)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _, _ in
                guard let self = self else {return}
                self.setCurrentModel()
            }
            .store(in: &cancellable)
    }
        
    private func setCurrentModel(){
       guard let voice = self.isAzureSpeech ? self.azureVoiceService.getVoicesModelForId(activeVoiceId) :
                self.aVoiceService.getVoicesModelForId(activeVoiceId) else { return }
        self.selectedVoice = voice
    }
    
    private func setVoiceMode(){
        voiceMode = isAzureSpeech ? .azure : .apple
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


extension SettingViewModel{
    enum VoiceMode: Int, CaseIterable, Equatable{
        case apple, azure
        
        var title: String{
            switch self{
                
            case .apple: return "All Apple"
            case .azure: return "All Azure"
            }
        }
    }
}
