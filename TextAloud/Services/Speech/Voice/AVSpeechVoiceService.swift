//
//  AVSpeechVoiceService.swift
//  TextAloud
//
//

import Foundation
import Combine
import AVFAudio
import TextAloudKit

class AVSpeechVoiceService: VoiceServiceProtocol{
    
    @Published var languages = [LanguageGroup]()
    
    
    init() {
        fetchVoices()
    }
    
    func fetchVoices() {
        let aVFvoices = AVSpeechSynthesisVoice.speechVoices()
        let uniquedLang = aVFvoices.map({$0.language}).uniqued()

        self.languages = uniquedLang.map({ code -> LanguageGroup in
            let voice = aVFvoices.filter({$0.language == code}).map({Voice(id: $0.identifier, name: $0.name, languageCode: $0.language, gender: ($0.gender == .male ? .male : .female), type: .apple)})
            return  .init(code: code, voices: voice)
        })
    }
    
    
    var defaultVoiceModel: Voice{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelsForLanguage(currentLocaleCode).first ??
            .init(id: "non", name: "Apple", languageCode: "en-US", gender: .female, type: .apple)
    }
    
    func getVoicesModelsForLanguage(_ language: String) -> [Voice] {
        languages.first(where: {$0.code == language})?.voices ?? []
    }
    
    func getLanguagesForCode(_ code: String) -> [LanguageGroup] {
        return languages.filter({$0.code == code})
    }
    
    func getVoicesModelForId(_ id: String) -> Voice {
        languages.map({$0.voices}).flatMap({$0}).first(where: {$0.id == id}) ?? defaultVoiceModel
    }
    
}
