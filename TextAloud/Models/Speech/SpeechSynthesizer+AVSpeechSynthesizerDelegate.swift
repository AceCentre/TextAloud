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
        guard playMode != .setting else {return}
        print("didFinish")
        isPlay = false
        currentWord = nil
        lastUtterance = utterance
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        guard playMode != .setting else {return}
        print("didCancel")
        isPlay = false
        currentWord = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        guard playMode != .setting else {return}
        print("didStart")
        isPlay = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        guard playMode != .setting else {return}
        isPlay = false
    }
}
