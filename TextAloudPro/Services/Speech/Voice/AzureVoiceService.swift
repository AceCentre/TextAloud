//
//  AzureVoiceService.swift
//  TextAloud
//
//

import Foundation
import MicrosoftCognitiveServicesSpeech
import TextAloudKit

class AzureVoiceService: VoiceServiceProtocol{
    
    let azureSpeech = AzureSpeech.share
    let defaultAzureVoiceId = "en-US-JennyNeural"
    @Published var languages = [LanguageGroup]()
    
    init(){
        fetchVoices()
    }
    
    func fetchVoices(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {return}
            if self.azureSpeech.configurateSpeechSynthesizer(){
                if let azureVoices = self.azureSpeech.getAllVoices(){
               
                    let uniquedLang = azureVoices.map({$0.locale}).uniqued()
                
                    self.languages = uniquedLang.map({ code -> LanguageGroup in
                        let voice = azureVoices.filter({$0.locale == code}).map({Voice(id: $0.shortName, name: $0.shortName, languageCode: $0.locale, gender: .init(rawValue: Int($0.gender.rawValue)) ?? .male, type: .azure)})
                        return  .init(code: code, voices: voice)
                    })
                }
            }
        }
    }
    

    var defaultVoiceModel: Voice{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelsForLanguage(currentLocaleCode).first ??
            .init(id: defaultAzureVoiceId, name: defaultAzureVoiceId, languageCode: "en-US", gender: .female, type: .azure)
    }
    
    func getVoicesModelsForLanguage(_ language: String) -> [Voice] {
        return languages.first(where: {$0.code == language})?.voices ?? []
    }
    
    func getLanguagesForCode(_ code: String) -> [LanguageGroup] {
        return languages.filter({$0.code == code})
    }
    
    func getVoicesModelForId(_ id: String) -> Voice {
        return languages.map({$0.voices}).flatMap({$0}).first(where: {$0.id == id}) ?? defaultVoiceModel
    }
    
}


protocol VoiceServiceProtocol{
    
    func fetchVoices()
    
    var defaultVoiceModel: Voice {get}
    
    func getVoicesModelsForLanguage(_ language: String) -> [Voice]
    
    func getLanguagesForCode(_ code: String) -> [LanguageGroup]
        
    func getVoicesModelForId(_ id: String) -> Voice
    
}
