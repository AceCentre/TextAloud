//
//  AzureSpeech.swift
//  TextAloud
//
//

import Foundation
import MicrosoftCognitiveServicesSpeech

class AzureSpeech{
    
    static let share = AzureSpeech()
    
    typealias HandlerEvent = ((SPXSpeechSynthesisEventArgs) -> Void)
    
    private var speechConfig: SPXSpeechConfiguration?
    private var synthesizer = SPXSpeechSynthesizer()
    
    var onCanceledHandler: HandlerEvent?
    var onStartedHandler: HandlerEvent?
    var onCompletedHandler: HandlerEvent?
    var onWordBoundaryHandler: ((SPXSpeechSynthesisWordBoundaryEventArgs) -> Void)?
    
    var onTest: ((SPXSpeechSynthesisEventArgs) -> Void)?
    
    
   private init(){}
    
    /// Setting up SpeechSynthesizer for environments key sub and region
    /// - Parameter speechSynthesisVoiceName: speech voice name
    func configurateSpeechSynthesizer(_ speechSynthesisVoiceName: String = "") -> Bool{
        
        var result: Bool = false
        
        do {
            let sub = "688eeeba205b456d8474beb30c5e457c"
            let region = "uksouth"
            
            if let speechConfig = try? SPXSpeechConfiguration(subscription: sub, region: region){
                
                speechConfig.speechSynthesisVoiceName = speechSynthesisVoiceName.isEmpty ? "en-US-JennyNeural" : speechSynthesisVoiceName
            
                synthesizer = try SPXSpeechSynthesizer(speechConfig)
                
                addHandlers()
                result = true
            }
            
        } catch {
            print("Error \(error) happened")
            speechConfig = nil
        }
        return result
    }
    
    
    /// Start speak for type
    /// - Parameters:
    ///   - text: some String
    ///   - type: SpeakInputType text or ssml
    func speak(_ text: String, type: SpeakInputType) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {return}
            
            var result: SPXSpeechSynthesisResult?
            
            if type == .text{
                result = try? self.synthesizer.speakText(text)
            }else{
                result = try? self.synthesizer.speakSsml(text)
            }
            
            
            if let result, result.reason == SPXResultReason.canceled
            {
                let cancellationDetails = try! SPXSpeechSynthesisCancellationDetails(fromCanceledSynthesisResult: result)
                print("cancelled, detail: \(cancellationDetails.errorDetails!) ")
            }
        }
    }
    
    
    /// Stop synthesizer
    func stop(){
       try? synthesizer.stopSpeaking()
    }
    
    func getAllVoices() -> [SPXVoiceInfo]?{
        return try? synthesizer.getVoices().voices
    }
    
    func getVoicesWithLocale(_ locale: String) -> [SPXVoiceInfo]?{
        return try? synthesizer.getVoicesWithLocale(locale).voices
    }
    
    
    private func addHandlers(){

        synthesizer.addSynthesisCanceledEventHandler {[weak self] _, event in
            guard let self = self else {return}
            self.self.onCanceledHandler?(event)
        }
        
        
        synthesizer.addSynthesisStartedEventHandler{[weak self] _, event in
            guard let self = self else {return}
            self.onStartedHandler?(event)
        }
        
        
        synthesizer.addSynthesisCompletedEventHandler{[weak self] _, event in
            guard let self = self else {return}
            self.onCompletedHandler?(event)
        }
        
        synthesizer.addSynthesisWordBoundaryEventHandler {[weak self] _, boundary in
            guard let self = self else {return}
            self.onWordBoundaryHandler?(boundary)
        }
    }
    
    enum SpeakInputType: Int{
        case text, ssml
    }
}
