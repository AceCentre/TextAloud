//
//  SpeechSynthesizer.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 28.10.2022.
//

import SwiftUI
import AVFAudio


class SpeechSynthesizer: NSObject, ObservableObject {
    @Published public var currentWord: NSRange?
    @Published var isPlay: Bool = false
    @Published var rateMode: SpeechRateEnum = .defaul
    @AppStorage("isAzureSpeech") var isAzureSpeech: Bool = false
    @AppStorage("aVFVoiceId") var aVFVoiceId: String = ""
    @AppStorage("azureVoiceId") var azureVoiceId: String = ""
    private var synth: AVSpeechSynthesizer
    var offset: Int = 0
    var lastUtterance: AVSpeechUtterance?
    
    let azureSpeech = AzureSpeech.share
    
    override init() {
        
        AVAudioSessionManager.share.configurePlaybackSession()
        
        synth = AVSpeechSynthesizer()
        
        super.init()
        
        synth.delegate = self
    
    }
    
    func speak(_ text: String) {
        
        if isAzureSpeech{
            speakAzure(text)
            return
        }
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
            stop()
        }
        offset = range.location
        let range = offset..<(offset + range.length)
        
        if isAzureSpeech{
            speakAzure(text[range])
            return
        }
        
        let utterance = AVSpeechUtterance(string: text[range])
        setVoiceIfNeeded(utterance)
        utterance.rate = rateMode.rateValue
        synth.speak(utterance)
    }
    
    func pause(){
        synth.pauseSpeaking(at: .immediate)
    }
    
    func stop() {
        if isAzureSpeech{
            azureSpeech.stop()
        }else{
            synth.stopSpeaking(at: .immediate)
        }
    }
    
    private func setVoiceIfNeeded(_ utterance: AVSpeechUtterance){
        if !aVFVoiceId.isEmpty{
            utterance.voice = AVSpeechSynthesisVoice(identifier: aVFVoiceId)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance)
    {
        print(characterRange)

        var temp = characterRange
        temp.location += offset
        currentWord = temp
        
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

