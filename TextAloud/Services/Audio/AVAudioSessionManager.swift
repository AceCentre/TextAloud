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

//    func configureRecordAudioSessionCategory() {
//      print("Configuring audio session")
//      do {
//          try audioSession.setCategory(.record, mode: .default)
//          try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
//        print("AVAudio Session out options: ", audioSession.currentRoute)
//        print("Successfully configured audio session.")
//      } catch (let error) {
//        print("Error while configuring audio session: \(error)")
//      }
//    }
    
    func setAudioSessionPlayback() {
        do {
            try audioSession.setActive(false)
            try audioSession.setCategory(.playback, mode: .voicePrompt, policy: .default, options: [
                .allowBluetooth,
                .allowBluetoothA2DP
            ])
            try audioSession.setActive(true)
        } catch {
            print("Error setting audioSessionPlayback: \(error)")
        }
    }
}

