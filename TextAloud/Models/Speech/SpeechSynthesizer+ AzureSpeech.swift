//
//  SpeechSynthesizer+ AzureSpeech.swift
//  TextAloud
//
//

import Foundation
import Combine
import TextAloudKit

extension SpeechSynthesizer{
    
    
    func startAzureRangeSubscription(){
        guard playMode != .setting else {return}
        cancellable = rangePublisher
            .receive(on: DispatchQueue.main)
            .sink{ range in
                var tempRange = range
                tempRange.location += self.rangeOffset
                self.currentWord = tempRange
            }
    }
    
    
    
    func speakAzure(_ text: String, voiceId: String, completion: ((Double) -> ())?){
        if azureSpeech.configurateSpeechSynthesizer(voiceId){
            addHandlers(text, completion: completion)
            azureSpeech.speak(text, type: .text)
        }
    }
    
    
    private func addHandlers(_ text: String, completion: ((Double) -> ())?){
        
        prepairRangesData.removeAll()
        startAzureRangeSubscription()
        
        azureSpeech.onCompletedHandler = { event in
            DispatchQueue.main.async {
                completion?(event.result.audioDuration)
                self.isPlay = false
                if self.playMode == .all{
                    self.saveAudio(name: text.createName, for: event.result.audioDuration, audioData: event.result.audioData)
                }
            }
            NotificationCenter.default.post(name: NSNotification.OnStopSpeech, object: nil)
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
            guard self.playMode != .setting else {return}
            if boundary.boundaryType == .word{
                self.prepairRangesData.append(.init(offset: boundary.textOffset, wordLength: boundary.wordLength, timeOffsets: boundary.audioOffset))
                self.azureDelayTasks.append(
                    Task.delayed(byTimeInterval: boundary.audioOffset.tikcsToSeconds) {
                        await MainActor.run{
                            self.rangePublisher.send(.init(location: Int(boundary.textOffset), length: Int(boundary.wordLength)))
                        }
                    }
                )
            }
        }
     }
}
