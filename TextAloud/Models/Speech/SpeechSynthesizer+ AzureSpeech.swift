//
//  SpeechSynthesizer+ AzureSpeech.swift
//  TextAloud
//
//

import Foundation
import Combine

extension SpeechSynthesizer{
    
    
    func startAzureRangeSubscription(){
        cancellable = rangePublisher
            .sink{ range in
                var tempRange = range
                tempRange.location += self.rangeOffset
                self.currentWord = tempRange
            }
    }
    
    
    
    func speakAzure(_ text: String){
        let voiceId = azureVoiceId.isEmpty ? "en-US-JennyNeural" : azureVoiceId
        if azureSpeech.configurateSpeechSynthesizer(voiceId){
            addHandlers()
            azureSpeech.speak(text, type: .text)
        }
    }
    
    private func addHandlers(){
     
        startAzureRangeSubscription()
        
        azureSpeech.onCompletedHandler = { event in
            DispatchQueue.main.async {
                self.isPlay = false
                self.currentWord = nil
                if self.isPlayAll{
                    self.saveAudio(for: event.result.audioDuration, audioData: event.result.audioData)
                }
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
            self.azureHandlerTask = Task.delayed(byTimeInterval: boundary.audioOffset.tikcsToSeconds) {
                await MainActor.run {
                    self.rangePublisher.send(.init(location: Int(boundary.textOffset), length: Int(boundary.wordLength)))
                }
            }
        }
     }
}
