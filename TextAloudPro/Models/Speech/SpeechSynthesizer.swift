//
//  SpeechSynthesizer.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 28.10.2022.
//

import SwiftUI
import AVFAudio
import Combine
import TextAloudKit

class SpeechSynthesizer: NSObject, ObservableObject {
    
    //MARK: Storage
    @AppStorage("isAzureSpeech") var isAzureSpeech: Bool = false
    @AppStorage("activeVoiceId") var activeVoiceId: String = ""
    let speechSaveService = SpeechSaveService.shared
    //MARK: AVSpeech
    @Published var rateMode: SpeechRateEnum = .defaul
    var lastUtterance: AVSpeechUtterance?
    private var synth: AVSpeechSynthesizer
    
    //MARK: - Azure
    let azureSpeech = AzureSpeech.share
    let audioSaveService = AudioSavedService()
    @Published var savedAudio: Audio?
    var prepairRangesData = [Audio.RangesData]()
    var rangePublisher = PassthroughSubject<NSRange, Never>()
    var cancellable: AnyCancellable?
    var azureDelayTasks = [Task<(), any Error>]()
    var playMode: PlayMode = .all
    
    @Published var currentWord: NSRange?
    @Published var isPlay: Bool = false
    var rangeOffset: Int = 0
    
    var completionCallback: ((Double) -> ())? = nil
    var startTimestamp: Date? = nil
    
    var isActiveCashAudio: Bool{
        isAzureSpeech && savedAudio != nil
    }
    
    override init() {
        
        AVAudioSessionManager.share.setAudioSessionPlayback()
        
        synth = AVSpeechSynthesizer()
        
        super.init()
        
        synth.delegate = self
        
    }
    
    
    //activate speek for test voices
    func activateSimple(_ text: String, id: String, type: VoiceMode){
        playMode = .setting
        if type == .azure{
            azureSpeech.stop()
            // We dont bother with completetion so we dont track the time that samples take
            speakAzure(text, voiceId: id, completion: nil)
        }else{
            synth.stopSpeaking(at: .immediate)
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(identifier: id)
            synth.speak(utterance)
        }
    }
    
    func setSpeakForRange(_ text: String, _ range: NSRange, mode: PlayMode, completion: ((Double) -> ())?) {
        playMode = mode
        if isPlay{
            stop()
            if mode != .tapped{ return  }
        }
        rangeOffset = range.location
        
        let prepairText = String(text.substring(with: range) ?? "default")
        
        if isAzureSpeech {
            speakAzure(prepairText, voiceId: activeVoiceId, completion: completion)
        }else{
            let utterance = AVSpeechUtterance(string: prepairText)
            setVoiceIfNeeded(utterance)
            synth.speak(utterance)
            
            completionCallback = completion
        }
    }
    
    func setSpeakForRange(_ text: String, _ range: NSRange, textSelectionMode: TextSelectionEnum, completion: ((Double) -> ())?) {
        playMode = PlayMode.textSelectionToPlayMode(textSelection: textSelectionMode)
        self.setSpeakForRange(text, range, mode: playMode, completion: completion)
    }
    
    func stop() {
        if isAzureSpeech{
            azureSpeech.stop()
            azureDelayTasks.forEach({$0.cancel()})
            cancellable?.cancel()
        }else if synth.isSpeaking{
            print("STOP")
            synth.stopSpeaking(at: .immediate)
        }
    }
    
    func stop(for type: VoiceMode){
        if type == .azure{
            azureSpeech.stop()
        }else if type == .apple{
            synth.stopSpeaking(at: .immediate)
        }
    }
    
    func updateRate(_ type: SpeechRateEnum){
        rateMode = type
        if isPlay {
            stop()
            if let lastUtterance{
                rangeOffset = 0
                lastUtterance.rate = rateMode.rateValue
                setVoiceIfNeeded(lastUtterance)
                synth.speak(lastUtterance)
                self.lastUtterance = nil
            }
        }
    }
    
    private func setVoiceIfNeeded(_ utterance: AVSpeechUtterance){
        if !activeVoiceId.isEmpty{
            utterance.voice = AVSpeechSynthesisVoice(identifier: activeVoiceId)
        }
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

enum PlayMode: Int {
    case all, selecting, tapped, setting
    
    static func textSelectionToPlayMode(textSelection: TextSelectionEnum) -> PlayMode {
        switch textSelection {
        case .all: return .all
        default: return .selecting
        }
    }
}
