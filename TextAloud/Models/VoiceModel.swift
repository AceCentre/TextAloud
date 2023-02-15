//
//  VoiceModel.swift
//  TextAloud
//
//

import Foundation
import AVFAudio

class VoiceModel {
    
    private var voices: [AVSpeechSynthesisVoice]
    
    init() {
        voices = AVSpeechSynthesisVoice.speechVoices()
    }
    
    func getVoices() -> [AVSpeechSynthesisVoice] {
        return voices
    }
    
    func getVoicesNamesAndIdentifiers(language: String) -> [(String, String)] {
        var temp: [(String, String)] = []
        let filtered = voices.filter {
            return $0.language == language
        }
        for voice in filtered {
            temp.append((voice.identifier, voice.name))
        }
        return temp
    }
}
