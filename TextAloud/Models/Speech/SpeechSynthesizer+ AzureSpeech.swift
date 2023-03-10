//
//  SpeechSynthesizer+ AzureSpeech.swift
//  TextAloud
//
//

import Foundation
import Combine

extension SpeechSynthesizer{
    
    
    private func startHighlightText(){
        guard let duration = prepairRangesData.map({$0.timeOffsets}).last else {return}
        rangeIndex = 0
        ///0.5 second delay for precise selection
        let average = (duration + 0.5) / Double(prepairRangesData.count)
        print("startHighlightText")
        speechTimer = Timer.scheduledTimer(withTimeInterval: average, repeats: true, block: { (timer) in
            if self.rangeIndex < self.prepairRangesData.count {
                var tempRange = self.prepairRangesData[self.rangeIndex].range
                tempRange.location += self.rangeOffset
                self.currentWord = tempRange
                self.rangeIndex += 1
            }
        })
    }
    func speakAzure(_ text: String, voiceId: String){
        if azureSpeech.configurateSpeechSynthesizer(voiceId){
            addHandlers(text)
            azureSpeech.speak(text, type: .text)
        }
    }
    
    
    private func addHandlers(_ text: String){
        
        prepairRangesData.removeAll()
        
        azureSpeech.onCompletedHandler = { event in
            DispatchQueue.main.async {
                self.resetTimer()
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
                self.resetTimer()
                self.isPlay = false
                print("Cancel")
            }
        }
        
        ///Subscribes to the SynthesisWordBoundary event which indicates that a word boundary is received.
        ///Passes all words before play
        azureSpeech.onWordBoundaryHandler = {[weak self] boundary in
            guard let self = self else {return}
            guard self.playMode != .setting else {return}
            
            ///prepairRanges array for highlight text and audio
            self.prepairRangesData.append(.init(offset: boundary.textOffset, wordLength: boundary.wordLength, timeOffsets: boundary.audioOffset))
            
            ///Find the last element for sentense of world and run highlight text
            guard let textLastIndex = text.lastIndexInt(of: text.last ?? ".") else {return}
            let boundaryLastIndex = Int(boundary.textOffset + boundary.wordLength - 1)
            if textLastIndex == boundaryLastIndex{
                DispatchQueue.main.async {
                    self.startHighlightText()
                }
            }
        }
     }
}



