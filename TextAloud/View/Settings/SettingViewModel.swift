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
    @Published var selectedLanguageCode: String = ""
    @Published var tempVoiceId: String = ""
    @Published var currentVoice: VoiceModel?
    
    @Published var isChangeVoiceService: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    let aVoiceService = AVSpeechVoiceService()
    let azureVoiceService = AzureVoiceService()
        
    init(){
        startVoiceSubscriptions()
    }

    
    private func startVoiceSubscriptions(){
        aVoiceService.$voices
            .combineLatest(azureVoiceService.$voices)
            .combineLatest($isChangeVoiceService)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _, _ in
                guard let self = self else {return}
                let voice = self.isAzureSpeech ? self.azureVoiceService.getVoicesModelForId(self.azureVoiceId) :
                self.aVoiceService.getVoicesModelForId(self.aVFVoiceId)
                
                self.currentVoice = voice
                self.setTempData()
            }
            .store(in: &cancellable)
    }
    
    
    func saveVoice(){
        
        if !tempVoiceId.isEmpty{
            
            if isAzureSpeech{
                azureVoiceId = tempVoiceId
            }else{
                aVFVoiceId = tempVoiceId
            }
            print(isAzureSpeech ? azureVoiceId : aVFVoiceId)
        }
    }
    
    func changeVoiceService(_ value: Bool){
        self.isAzureSpeech = value
        self.isChangeVoiceService.toggle()
    }
    
    func setTempData(){
        if let currentVoice{
            selectedLanguageCode = currentVoice.languageCode
            tempVoiceId = currentVoice.id
        }
    }
    
    
    var voicesForLanguage: [VoiceModel] {
        isAzureSpeech ? azureVoiceService.getVoicesModelsForLanguage(selectedLanguageCode) :
        aVoiceService.getVoicesModelsForLanguage(selectedLanguageCode)
    }
    
    var uniquedLanguagesCodes: [String]{
        isAzureSpeech ? azureVoiceService.uniquedLanguagesCodes :
        aVoiceService.uniquedLanguagesCodes
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
