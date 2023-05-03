//
//  VoiceProviderProtocol.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 02/05/2023.
//

import Foundation
import AVFAudio

protocol VoiceProviderProtocol {
    func getVoices() -> [Voice]
    func speak(text: String, voice: Voice)
    func setup()
}

class SystemProvider: VoiceProviderProtocol {
    func speak(text: String, voice: Voice) {
        /// TODO Write speak function
    }
    
    func setup() {
        /// TODO Write setup function
    }
    
    func getVoices() -> [Voice] {
        let systemVoices = AVSpeechSynthesisVoice.speechVoices()
        
        // Maps system voices to our generic voice
        return systemVoices.map({ voice in
            return Voice(
                id: voice.identifier,
                shortName: voice.name,
                longName: voice.description,
                language: Language(voice.language),
                provider: .system,
                connectionType: .offline,
                gender: .fromAVSpeechGender(voice.gender)
            )
        })
    }
}

extension Gender {
    /// Maps an the gender given to us from the AVSpeechSynthesis Engine to our generic gender
    static func fromAVSpeechGender(_ gender: AVSpeechSynthesisVoiceGender) -> Gender {
        switch gender {
        case .female: return .female
        case .male: return .male
        case .unspecified: return .unspecified
        default: return .unspecified
        }
    }
}
