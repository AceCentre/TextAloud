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
    
    @AppStorage("aVFVoiceId") var aVFVoiceId: String = ""
    @AppStorage("azureVoiceId") var azureVoiceId: String = "en-US-JennyNeural"
    
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
        isAzureSpeech ? azureVoiceService.languages : aVoiceService.languages
    }
    
    func changeVoice(_ voice: VoiceModel){
        if voice.type == .azure{
            azureVoiceId = voice.id
        }else{
            aVFVoiceId = voice.id
        }
        selectedVoice = voice
    }
    
    private func changeVoiceMode(){
        self.isAzureSpeech = voiceMode == .azure ? true : false
    }
    
    private func setVoiceMode(){
        voiceMode = isAzureSpeech ? .azure : .apple
    }
    
    private func startVoiceSubscriptions(){
        aVoiceService.$languages
            .combineLatest(azureVoiceService.$languages)
            .combineLatest($voiceMode)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _, _ in
                guard let self = self else {return}
                self.changeVoiceMode()
                self.setVoiceModel()
            }
            .store(in: &cancellable)
    }
        
    private func setVoiceModel(){
       guard let voice = self.isAzureSpeech ? self.azureVoiceService.getVoicesModelForId(self.azureVoiceId) :
                self.aVoiceService.getVoicesModelForId(self.aVFVoiceId) else { return }
        self.selectedVoice = voice
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
