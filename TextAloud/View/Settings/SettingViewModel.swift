//
//  SettingViewModel.swift
//  TextAloud
//
//

import SwiftUI


class SettingViewModel: ObservableObject{
    
    @AppStorage("selectedColor") var selectedColor: Color = Color(UIColor(red: 0.96, green: 0.9, blue: 0.258, alpha: 0.4))
    @AppStorage("readingColor") var readingColor: Color = Color.red
    @AppStorage("fontSize") var fontSize: Int = 25
    
    @AppStorage("selectedVoiceId") var selectedVoiceId: String = ""
    
    @Published var showVoicePicker: Bool = false
    @Published var currentLanguage: String = ""
    @Published var tempVoiceId: String = ""
    @Published var voiceModel: VoiceModel = SpeechVoiceService.share.defaultVoiceModel
    
    let voiceService = SpeechVoiceService.share
        
    
    init(){
        setCurrentVoiceModel()
    }
    
    func incrementStep() {
        fontSize += 1
    }

    func decrementStep() {
        fontSize -= 1
    }
    
    
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
    
    
    func setCurrentVoiceModel() {
        if let voice = voiceService.getVoicesModelForId(selectedVoiceId){
            self.voiceModel = voice
        }
        self.currentLanguage = voiceModel.languageCode
        self.tempVoiceId = voiceModel.id
    }
    
    func saveVoice(){
        if !tempVoiceId.isEmpty{
            selectedVoiceId = tempVoiceId
            print(selectedVoiceId)
            setCurrentVoiceModel()
        }
    }
}


