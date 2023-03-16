//
//  SpeechSynthesizer+AVSpeechSynthesizerDelegate.swift.swift
//  TextAloud
//
//

import Foundation
import AVFAudio


extension SpeechSynthesizer: AVSpeechSynthesizerDelegate{
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance)
    {
        guard playMode != .setting else {return}
        var temp = characterRange
        temp.location += rangeOffset
        currentWord = temp
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlay = false
        lastUtterance = utterance
        NotificationCenter.default.post(name: NSNotification.OnStopSpeech, object: nil)
        
        let timeSinceStarted = startTimestamp?.timeIntervalSinceNow ?? 0
                
        let absoluteTimeSinceStarted = abs(timeSinceStarted)
        
        completionCallback?(absoluteTimeSinceStarted)
        
        startTimestamp = nil
        completionCallback = nil
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        startTimestamp = nil
        completionCallback = nil
        
        isPlay = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        startTimestamp = Date()
        
        isPlay = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        startTimestamp = nil
        completionCallback = nil
        
        isPlay = false
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
