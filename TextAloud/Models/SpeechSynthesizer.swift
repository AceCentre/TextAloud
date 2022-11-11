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
    let synth = AVSpeechSynthesizer()
    private var offset: Int = 0
    private var length: Int = 0
    private var isSpeak: Bool = false
    @AppStorage("selectedVoice") var selectedVoice: String = "com.apple.voice.compact.en-GB.Daniel"
    
    override init() {
        super.init()
        synth.delegate = self
    }
    
    func speak(_ text: String) {
        if(isSpeak) {
            synth.stopSpeaking(at: .immediate)
        }
        offset = 0
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.47
        utterance.voice = AVSpeechSynthesisVoice(identifier: selectedVoice)
        synth.speak(utterance)
    }
    
    func speak(_ text: String, range: (Int, Int)) {
        if(isSpeak) {
            synth.stopSpeaking(at: .immediate)
        }
        offset = range.0
        length = range.1
        let utterance = AVSpeechUtterance(string: text[offset..<(offset+length)])
        utterance.rate = 0.47
        synth.speak(utterance)
    }
    
    func stop() {
        synth.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance)
    {
        var temp = characterRange
        temp.location += offset
        currentWord = temp
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeak = false
        currentWord = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeak = false
        currentWord = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeak = true
    }
}
