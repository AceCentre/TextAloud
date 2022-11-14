//
//  VoiceModel.swift
//  TextAloud
//
//  Created by Dan on 12.11.2022.
//

import Foundation
import AVFAudio

class VoiceModel {
    
    var voices: [AVSpeechSynthesisVoice]
    
    init() {
        voices = AVSpeechSynthesisVoice.speechVoices()
    }
    
    public func getVoices() -> [AVSpeechSynthesisVoice] {
        return voices
    }
    
    public func getVoicesNamesAndIdentifiers(language: String) -> [(String, String)] {
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
