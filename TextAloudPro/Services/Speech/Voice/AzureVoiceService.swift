//
//  AzureVoiceService.swift
//  TextAloud
//
//

import Foundation
import MicrosoftCognitiveServicesSpeech

class AzureVoiceService: VoiceServiceProtocol{
    
    let azureSpeech = AzureSpeech.share
    let defaultAzureVoiceId = "en-US-JennyNeural"
    @Published var languages = [LanguageModel]()
    
    init(){
        fetchVoices()
    }
    
    func fetchVoices(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {return}
            if self.azureSpeech.configurateSpeechSynthesizer(){
                if let azureVoices = self.azureSpeech.getAllVoices(){
               
                    let uniquedLang = azureVoices.map({$0.locale}).uniqued()
                
                    self.languages = uniquedLang.map({ code -> LanguageModel in
                        let voice = azureVoices.filter({$0.locale == code}).map({VoiceModel(id: $0.shortName, name: $0.shortName, languageCode: $0.locale, gender: .init(rawValue: Int($0.gender.rawValue)) ?? .male, type: .azure)})
                        return  .init(code: code, voices: voice)
                    })
                }
            }
        }
    }
    

    var defaultVoiceModel: VoiceModel{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelsForLanguage(currentLocaleCode).first ??
            .init(id: defaultAzureVoiceId, name: defaultAzureVoiceId, languageCode: "en-US", gender: .female, type: .azure)
    }
    
    func getVoicesModelsForLanguage(_ language: String) -> [VoiceModel] {
        return languages.first(where: {$0.code == language})?.voices ?? []
    }
    
    func getLanguagesForCode(_ code: String) -> [LanguageModel] {
        return languages.filter({$0.code == code})
    }
    
    func getVoicesModelForId(_ id: String) -> VoiceModel {
        return languages.map({$0.voices}).flatMap({$0}).first(where: {$0.id == id}) ?? defaultVoiceModel
    }
    
}


protocol VoiceServiceProtocol{
    
    func fetchVoices()
    
    var defaultVoiceModel: VoiceModel {get}
    
    func getVoicesModelsForLanguage(_ language: String) -> [VoiceModel]
    
    func getLanguagesForCode(_ code: String) -> [LanguageModel]
        
    func getVoicesModelForId(_ id: String) -> VoiceModel
    
}
