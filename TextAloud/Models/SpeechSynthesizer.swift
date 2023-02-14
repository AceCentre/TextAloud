//
//  SpeechSynthesizer.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 28.10.2022.
//

import SwiftUI
import AVFAudio

extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

class SpeechSynthesizer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published public var currentWord: NSRange?
    @Published var isPlay: Bool = false
    @Published var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    let rangeRate = (AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate)
    var synth: AVSpeechSynthesizer
    private var offset: Int = 0
    private var length: Int = 0
   
    private var lastWord: NSRange?
    private var lastUtterance: AVSpeechUtterance?
    
    override init() {
        
        AVAudioSessionManager.share.configurePlaybackSession()
        
        synth = AVSpeechSynthesizer()
        
        super.init()
        
        synth.delegate = self
        
    }
    
    func speak(_ text: String) {
        offset = 0
        if synth.isPaused{
            synth.continueSpeaking()
            isPlay = true
        }else{
            let utterance = AVSpeechUtterance(string: text)
            utterance.rate = rate
            synth.speak(utterance)
            print("speak")
        }
    }
    
//    func speak(_ text: String, range: (Int, Int)) {
//        offset = range.0
//        length = range.1
//
//    }
    
    func pause(){
        synth.pauseSpeaking(at: .immediate)
    }
    
    func stop() {
        synth.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance)
    {
        print(characterRange.location)
        print(characterRange.length)
        var temp = characterRange
        temp.location += offset
        currentWord = temp
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlay = false
        currentWord = nil
        lastUtterance = utterance
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isPlay = false
        currentWord = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isPlay = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isPlay = false
    }
    
    
    func updateRate(){
        if isPlay {
            stop()
            if let lastUtterance{
                lastUtterance.rate = rate
                synth.speak(lastUtterance)
                self.lastUtterance = nil
            }
        }
    }
}
