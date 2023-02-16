//
//  Av.swift
//  TextAloud
//
//

import AVFoundation
import UIKit

final class AVAudioSessionManager{
    
    static let share = AVAudioSessionManager()
    
    private init(){}

    private let audioSession = AVAudioSession.sharedInstance()

    func configureRecordAudioSessionCategory() {
      print("Configuring audio session")
      do {
          try audioSession.setCategory(.record, mode: .default)
          try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        print("AVAudio Session out options: ", audioSession.currentRoute)
        print("Successfully configured audio session.")
      } catch (let error) {
        print("Error while configuring audio session: \(error)")
      }
    }
    
    func configurePlaybackSession(){
        do {
            try audioSession.setCategory(.playback, mode: .spokenAudio)
            try audioSession.overrideOutputAudioPort(.none)
            try audioSession.setActive(true)
            print("Current audio route: ", audioSession.currentRoute.outputs)
        } catch let error as NSError {
            print("#configureAudioSessionToSpeaker Error \(error.localizedDescription)")
        }
    }
}
