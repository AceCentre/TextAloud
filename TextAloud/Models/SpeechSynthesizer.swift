//
//  SpeechSynthesizer.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 28.10.2022.
//

import SwiftUI
import AVFAudio


class SpeechSynthesizer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published public var currentWord: NSRange?
    @Published var isPlay: Bool = false
    @Published var rateMode: SpeechRateEnum = .defaul
    @AppStorage("selectedVoiceId") var selectedVoiceId: String = SpeechVoiceService.share.defaultVoiceModel.id
    private var synth: AVSpeechSynthesizer
    let voices = SpeechVoiceService.share
    private var offset: Int = 0
    private var lastUtterance: AVSpeechUtterance?
    
    
    override init() {
        
        AVAudioSessionManager.share.configurePlaybackSession()
        
        synth = AVSpeechSynthesizer()
        
        super.init()
        
        synth.delegate = self
        
        
    }
    
    func speak(_ text: String) {
        if synth.isPaused{
            synth.continueSpeaking()
            isPlay = true
        }else{
            offset = 0
            let utterance = AVSpeechUtterance(string: text)
            setVoiceIfNeeded(utterance)
            utterance.rate = rateMode.rateValue
            synth.speak(utterance)
            print("speak")
        }
    }
    

    func setSpeakForRange(_ text: String, _ range: NSRange) {
        if isPlay {
            synth.stopSpeaking(at: .immediate)
        }
        offset = range.location
        
        let utterance = AVSpeechUtterance(string: text[offset..<(offset + range.length)])
        setVoiceIfNeeded(utterance)
        utterance.rate = rateMode.rateValue
        synth.speak(utterance)
    }
    
    func pause(){
        synth.pauseSpeaking(at: .immediate)
    }
    
    func stop() {
        synth.stopSpeaking(at: .immediate)
    }
    
    private func setVoiceIfNeeded(_ utterance: AVSpeechUtterance){
        if !selectedVoiceId.isEmpty{
            utterance.voice = AVSpeechSynthesisVoice(identifier: selectedVoiceId)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance)
    {
        print(characterRange)

        var temp = characterRange
        temp.location += offset
        currentWord = temp
        
    }
    
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
    
    
    func updateRate(_ type: SpeechRateEnum){
        rateMode = type
        if isPlay {
            stop()
            if let lastUtterance{
                offset = 0
                lastUtterance.rate = rateMode.rateValue
                setVoiceIfNeeded(lastUtterance)
                synth.speak(lastUtterance)
                self.lastUtterance = nil
            }
        }
    }
}


extension SpeechSynthesizer{
    
    enum SpeechScrubState{
        case reset
        case scrubStarted
        case scrubEnded(String)
    }
}



enum SpeechRateEnum: Int, CaseIterable{

    case min, slow, defaul, fast, veryFast, max
    
    var rateValue: Float{
        switch self {
        case .min: return 0.1
        case .slow: return 0.3
        case .defaul: return 0.5
        case .fast: return 0.7
        case .veryFast: return 0.8
        case .max: return 1
        }
    }
    
    var valueRepresentable: String{
        var value = 0.0
        
        switch self {
        case .min: value += 0.2
        case .slow: value += 0.5
        case .defaul: value += 1
        case .fast: value += 1.5
        case .veryFast: value += 2
        case .max: value += 2.5
        }
        
        let unit = "x"
        return String(format: "%.01f%@", value, unit)
    }
}

