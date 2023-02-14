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
    @Published var offset: Double = 0
    
    var synth: AVSpeechSynthesizer
    
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
            utterance.rate = rateMode.rateValue
            synth.speak(utterance)
            print("speak")
        }
    }
    

    func setSpeak(_ text: String) {
        if isPlay {
            synth.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text[Int(offset)..<(text.length)])
        utterance.rate = rateMode.rateValue
        synth.speak(utterance)
    }
    
    func pause(){
        synth.pauseSpeaking(at: .immediate)
    }
    
    func stop() {
        synth.stopSpeaking(at: .immediate)
    }
    
    
//    var scrubState: SpeechScrubState = .reset {
//        didSet {
//            switch scrubState {
//            case .scrubEnded(let text):
//                setSpeak(text)
//                scrubState = .reset
//            default : break
//            }
//        }
//    }
    

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance)
    {
        print(characterRange)

        let temp = characterRange
        currentWord = temp
        
//        switch self.scrubState {
//        case .reset:
//            offset = Double(temp.location)
//            currentWord = temp
//        case .scrubStarted:
//            currentWord = .init(location: Int(offset), length: 30)
//        default : break
//
//        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlay = false
        currentWord = nil
        lastUtterance = utterance
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isPlay = false
        currentWord = nil
        offset = .zero
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
                lastUtterance.rate = rateMode.rateValue
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

    case min, slow, defaul, fast, max
    
    var rateValue: Float{
       Float(self.rawValue + 1) * (AVSpeechUtteranceMaximumSpeechRate / 5)
    }
    
    var valueRepresentable: String{
        let unit = "x"
        return String(format: "%.01f%@", rateValue, unit)
    }
}

