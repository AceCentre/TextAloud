//
//  AVSpeechVoiceService.swift
//  TextAloud
//
//

import Foundation
import Combine
import AVFAudio

class AVSpeechVoiceService: VoiceServiceProtocol{
    
    @Published var voices = [VoiceModel]()
    
    
    init() {
        fetchVoices()
    }
    
    func fetchVoices() {
        let aVFvoices = AVSpeechSynthesisVoice.speechVoices()
        let voice: [VoiceModel] = aVFvoices.map({VoiceModel(id: $0.identifier, name: $0.name, languageCode: $0.language, type: .apple)})
        self.voices = voice
    }
    
    
    var uniquedLanguagesCodes: [String]{
        voices.map({$0.languageCode}).uniqued()
    }
    
    var defaultVoiceModel: VoiceModel{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelsForLanguage(currentLocaleCode).first ??
            .init(id: "non", name: "", languageCode: "en-US", type: .apple)
    }
    
    func getVoicesModelsForLanguage(_ language: String) -> [VoiceModel] {
        return voices.filter({$0.languageCode == language})
    }
    
    func getVoicesModelForId(_ id: String) -> VoiceModel? {
        return voices.first(where: {$0.id == id}) ?? defaultVoiceModel
    }
    
}
