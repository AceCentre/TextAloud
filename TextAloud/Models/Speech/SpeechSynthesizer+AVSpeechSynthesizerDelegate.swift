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
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isPlay = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isPlay = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isPlay = false
    }
}
