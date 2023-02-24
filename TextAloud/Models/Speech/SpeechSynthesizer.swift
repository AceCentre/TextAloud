//
//  SpeechSynthesizer.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 28.10.2022.
//

import SwiftUI
import AVFAudio
import Combine

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
    @Published var savedAudio: AudioModel?
    var prepairRangesData = [AudioModel.RangesData]()
    var rangePublisher = PassthroughSubject<NSRange, Never>()
    var cancellable: AnyCancellable?
    var azureDelayTasks = [Task<(), any Error>]()
    var playMode: PlayMode = .all

    @Published var currentWord: NSRange?
    @Published var isPlay: Bool = false
    var rangeOffset: Int = 0
    
    var isActiveCashAudio: Bool{
        isAzureSpeech && savedAudio != nil
    }
    
    override init() {
        
        AVAudioSessionManager.share.setAudioSessionPlayback()
        
        synth = AVSpeechSynthesizer()
        
        super.init()
        
        synth.delegate = self
    
    }
    
    
    func activate(_ text: String, mode: PlayMode){
        playMode = mode
        if isPlay{
            stop()
        }else{
           speak(text)
        }
    }
    
    //activate speek for test voices
    func activateSimple(_ text: String, id: String, type: VoiceModel.VoiceType){
        rangeOffset = 0
        currentWord = nil
        playMode = .setting
        if type == .azure{
            azureSpeech.stop()
            if azureSpeech.configurateSpeechSynthesizer(id){
                azureSpeech.speak(text, type: .text)
            }
        }else{
            synth.stopSpeaking(at: .immediate)
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(identifier: id)
            synth.speak(utterance)
        }
    }
            
    func setSpeakForRange(_ text: String, _ range: NSRange) {
        playMode = .selecting
        if isPlay {
            stop()
        }
        rangeOffset = range.location
        let range = rangeOffset..<(rangeOffset + range.length)
        
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
            azureDelayTasks.forEach({$0.cancel()})
            cancellable?.cancel()
        }else if synth.isSpeaking{
            synth.stopSpeaking(at: .immediate)
        }
    }
    
    func stopAll(){
        if isPlay{
            azureSpeech.stop()
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
    
    private func speak(_ text: String) {
         rangeOffset = 0
         if isAzureSpeech{
             speakAzure(text)
             return
         }else{
             let utterance = AVSpeechUtterance(string: text)
             setVoiceIfNeeded(utterance)
             utterance.rate = rateMode.rateValue
             synth.speak(utterance)
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

enum PlayMode: Int{
    case all, inEdit, selecting, setting
}
