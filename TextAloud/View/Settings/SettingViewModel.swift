//
//  SettingViewModel.swift
//  TextAloud
//
//

import SwiftUI


class SettingViewModel: ObservableObject{
    
    @AppStorage("isAzureSpeech") var isAzureSpeech: Bool = false
    
    @AppStorage("selectedColor") var selectedColor: Color = Color(UIColor(red: 0.96, green: 0.9, blue: 0.258, alpha: 0.4))
    @AppStorage("readingColor") var readingColor: Color = Color.red
    @AppStorage("fontSize") var fontSize: Int = 25
    
    @AppStorage("aVFVoiceId") var aVFVoiceId: String = SpeechVoiceService.share.defaultVoiceModel.id
    @AppStorage("azureVoiceId") var azureVoiceId: String = SpeechVoiceService.share.defaultAzureVoiceId
    
    @Published var showVoicePicker: Bool = false
    @Published var currentLanguage: String = ""
    @Published var tempVoiceId: String = ""
    @Published var voiceModel: VoiceModel = SpeechVoiceService.share.defaultVoiceModel
    
    let voiceService = SpeechVoiceService.share
        
    
    init(){
        setCurrentVoiceModel()
    }
    
    
    func setCurrentVoiceModel() {
        let voiceId = isAzureSpeech ? azureVoiceId : aVFVoiceId
        if let voice = voiceService.getVoicesModelForId(voiceId){
            self.voiceModel = voice
        }
        self.currentLanguage = voiceModel.languageCode
        self.tempVoiceId = voiceModel.id
    }
    
    func saveVoice(){
        
        if !tempVoiceId.isEmpty{
            
            if isAzureSpeech{
                azureVoiceId = tempVoiceId
            }else{
                aVFVoiceId = tempVoiceId
            }
            print(isAzureSpeech ? azureVoiceId : aVFVoiceId)
            setCurrentVoiceModel()
        }
    }
    
    func changeVoiceService(_ value: Bool){
        self.isAzureSpeech = value
        setCurrentVoiceModel()
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
