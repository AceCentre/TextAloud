//
//  AzureVoiceService.swift
//  TextAloud
//
//

import Foundation
import MicrosoftCognitiveServicesSpeech

class AzureVoiceService: VoiceServiceProtocol{
    
    @Published var voices = [VoiceModel]()
    let azureSpeech = AzureSpeech.share
    let defaultAzureVoiceId = "en-US-JennyNeural"
    
    
    init(){
        fetchVoices()
    }
    
    func fetchVoices(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {return}
            if self.azureSpeech.configurateSpeechSynthesizer(){
                if let azureVoices = self.azureSpeech.getAllVoices(){
                    self.voices = azureVoices.map({.init(id: $0.shortName, name: $0.shortName, languageCode: $0.locale, type: .azure)})
                }
            }
        }
    }
    
    var uniquedLanguagesCodes: [String]{
        voices.map({$0.languageCode}).uniqued()
    }
    
    var defaultVoiceModel: VoiceModel{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelsForLanguage(currentLocaleCode).first ??
            .init(id: defaultAzureVoiceId, name: defaultAzureVoiceId, languageCode: "en-US", type: .azure)
    }
    
    func getVoicesModelsForLanguage(_ language: String) -> [VoiceModel] {
        return voices.filter({$0.languageCode == language})
    }
    
    func getVoicesModelForId(_ id: String) -> VoiceModel? {
        return voices.first(where: {$0.id == id})
    }
    
}


protocol VoiceServiceProtocol{
    
    func fetchVoices()
    
    var uniquedLanguagesCodes: [String] {get}
    
    var defaultVoiceModel: VoiceModel {get}
    
    func getVoicesModelsForLanguage(_ language: String) -> [VoiceModel]
    
    func getVoicesModelForId(_ id: String) -> VoiceModel?
    
}
