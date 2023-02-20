//
//  SpeechSynthesier+UserDefaults.swift
//  TextAloud
//
//

import Foundation


extension SpeechSynthesizer{
    
    func saveSpeechData(_ text: String){
        let model: SpeechSaveModel = .init(audio: savedAudio, text: text)
        self.speechSaveService.save(model)
    }
    
    func getSpeechData() -> String?{
        guard let model = self.speechSaveService.load() else { return nil }
        self.savedAudio = model.audio
        return model.text
    }
    
    func removeSpeechData(){
        speechSaveService.remove()
    }
}
