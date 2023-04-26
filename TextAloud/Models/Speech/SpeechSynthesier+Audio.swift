//
//  SpeechSynthesier+Audio.swift
//  TextAloud
//
//

import Foundation
import TextAloudKit

extension SpeechSynthesizer{
    
    
    func saveAudio(name: String, for audioDuration: TimeInterval, audioData: Data?){
        if let audioData, let url = audioSaveService.storeAudioFile(name: name, for: audioData){
            savedAudio = .init(url: url, duration: audioDuration, rangesData: prepairRangesData)
        }
    }
    
    func removeAudio(){
        guard let url = savedAudio?.url else {return}
        savedAudio = nil
        audioSaveService.remove(for: url)
    }
    
}
