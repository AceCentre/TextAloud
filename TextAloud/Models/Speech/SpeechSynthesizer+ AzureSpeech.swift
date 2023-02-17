//
//  SpeechSynthesizer+ AzureSpeech.swift
//  TextAloud
//
//  Created by Богдан Зыков on 17.02.2023.
//

import Foundation

extension SpeechSynthesizer{
    
    func configureteAzure(){
        let voiceId = azureVoiceId.isEmpty ? "en-US-JennyNeural" : azureVoiceId
        if azureSpeech.configurateSpeechSynthesizer(voiceId){
            addHandlers()
        }
    }
    
    private func addHandlers(){
     
        azureSpeech.onCompletedHandler = { event in
            DispatchQueue.main.async {
                self.isPlay = false
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
                print("Cancel")
            }
        }
        
        azureSpeech.onWordBoundaryHandler = { boundary in
            print(boundary.audioOffset)
            print(boundary.text)
        }
     }
}
