//
//  VoiceConductor.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 04/05/2023.
//

import Foundation

public class VoiceConductor: ObservableObject {
    @Published var isPlaying = false
    @Published var currentVoice: Voice?
    
    var systemProvider = SystemProvider()
    
    public init() {}
    
    func speak(_ text: String) {
        guard let voice = currentVoice else { return }
        
        let provider = voice.provider
        
        switch provider {
        case .system: systemProvider.speak(text: text, voice: voice)
        case .azure: print("Not implemented") /// TODO
        }
    }
}
