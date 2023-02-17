//
//  SpeechSynthesizer+ AzureSpeech.swift
//  TextAloud
//
//

import Foundation

extension SpeechSynthesizer{
    
    func speakAzure(_ text: String){
        let voiceId = azureVoiceId.isEmpty ? "en-US-JennyNeural" : azureVoiceId
        if azureSpeech.configurateSpeechSynthesizer(voiceId){
            addHandlers()
            azureSpeech.speak(text, type: .text)
        }
    }
    
    private func addHandlers(){
     
        azureSpeech.onCompletedHandler = { event in
            DispatchQueue.main.async {
                self.isPlay = false
                self.currentWord = nil
                print("Stop", "Duration \(event.result.audioDuration)")
            }
        }
        
        azureSpeech.onStartedHandler = { _ in
            DispatchQueue.main.async {
                self.isPlay = true
                print("Start")
            }
        }
        
        azureSpeech.onCanceledHandler = { _ in
            DispatchQueue.main.async {
                self.isPlay = false
                self.currentWord = nil
                print("Cancel")
            }
        }
        
        azureSpeech.onWordBoundaryHandler = { boundary in
            let time: DispatchTime = .now() + (Double(boundary.audioOffset) / 10_000_000)
            var tempOffset = Int(boundary.textOffset)
            tempOffset += self.offset
            DispatchQueue.main.asyncAfter(deadline: time){
                self.currentWord = .init(location: tempOffset, length: Int(boundary.wordLength))
            }
        }
     }
}
