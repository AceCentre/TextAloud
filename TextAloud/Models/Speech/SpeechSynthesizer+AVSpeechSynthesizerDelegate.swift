//
//  SpeechSynthesizer+AVSpeechSynthesizerDelegate.swift.swift
//  TextAloud
//
//

import Foundation
import AVFAudio


extension SpeechSynthesizer: AVSpeechSynthesizerDelegate{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
        isPlay = false
        currentWord = nil
        lastUtterance = utterance
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("didCancel")
        isPlay = false
        currentWord = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isPlay = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isPlay = false
    }
}
