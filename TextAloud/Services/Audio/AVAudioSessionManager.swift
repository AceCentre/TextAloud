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
    func setAudioSessionPlayback() {
        do {
            try audioSession.setActive(false)
            try audioSession.setCategory(.playback, mode: .voicePrompt, policy: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Error setting audioSessionPlayback: \(error)")
        }
    }
}

