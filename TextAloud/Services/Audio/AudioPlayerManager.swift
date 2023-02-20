//
//  AudioPlayerManager.swift
//  TextAloud
//
//

import Foundation
import SwiftUI
import AVKit
import Combine

class AudioPlayerManager: ObservableObject {
    
    //@Published var currentTime: Double = .zero

    @Published var currentAudio: AudioModel?
    @Published var isPlaying: Bool = false
    @Published var player: AVPlayer!
    @Published var session: AVAudioSession!
    @Published var currentRate: Float = 1.0
    @Published var currentRange: NSRange?
    
    private var subscriptions = Set<AnyCancellable>()
    private var sumplesTimer: Timer?
    private var timeObserver: Any?
    private var rangeIndex = 0
        
    deinit {
        removeTimeObserver()
    }
    
    
    private func setAudio(_ audio: AudioModel){
        
        sumplesTimer?.invalidate()
        removeTimeObserver()
        currentAudio = nil
        withAnimation {
            currentAudio = audio
        }
        player = AVPlayer(url: audio.url)
        startSubscriptions()
    }
    
    func udateRate(){
        player.playImmediately(atRate: currentRate)
    }
    
 
    func audioAction(_ audio: AudioModel){
        setAudio(audio)
        if isPlaying {
            pauseAudio()
        } else {
            playAudio(audio)
        }
    }
    
    #warning("TODO")
    func seekTo(_ audio: AudioModel, _ selectedRange: NSRange){
        if !isPlaying{
            setAudio(audio)
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                self.playerDidFinishPlaying()
            }
            udateRate()
            startTimer(for: selectedRange)
        }
        
        var time: Double = 0
        
        if rangeIndex > 0{
            time = (0...rangeIndex).map({audio.rangesData[$0].timeOffsets}).reduce(0.0, +)
        }
        print("index-", rangeIndex, time)
        let seekTime = CMTime(seconds:
                                time, preferredTimescale: 60000)
        print(seekTime.seconds)
        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
        
    }
    
}


extension AudioPlayerManager{
    
    private func startSubscriptions(){
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
    }
    
    private func playAudio(_ audio: AudioModel) {
         if isPlaying{
             pauseAudio()
         } else {
             NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                 self.playerDidFinishPlaying()
             }
             player.play()
             udateRate()
             startTimer()
         }
     }
    
    
    private func startTimer(for range: NSRange? = nil) {

         guard let audio = currentAudio else {return}
         
         #warning("TODO")
         // set index if needded
         self.rangeIndex = audio.rangesData.firstIndex(where: {$0.range.location == range?.location}) ?? 0
         let averageTime = audio.duration / Double(audio.rangesData.count)
         self.sumplesTimer = Timer.scheduledTimer(withTimeInterval: averageTime, repeats: true, block: { (timer) in
             
             if self.rangeIndex < audio.rangesData.count {
                 self.currentRange = audio.rangesData[self.rangeIndex].range
                 self.rangeIndex += 1
             }
         })


 //        let interval = CMTimeMake(value: 1, timescale: 2)
 //        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
 //            guard let self = self else { return }
 //            let time = time.seconds
 //            self.currentAudio?.updateRemainingDuration(time)
 //            if (self.currentAudio?.duration ?? 0) > time{
 //                withAnimation {
 //                    self.currentTime = time
 //                }
 //            }
 //        }

     }
     
     private func pauseAudio() {
         player.pause()
         sumplesTimer?.invalidate()
     }

     private func removeTimeObserver(){
         if let timeObserver = timeObserver {
             player.removeTimeObserver(timeObserver)
         }
     }
    
    private func playerDidFinishPlaying() {
         print("DidFinishPlaying")
         player.pause()
         player.seek(to: .zero)
         sumplesTimer?.invalidate()
         //currentAudio?.resetRemainingDuration()
         withAnimation {
             currentAudio = nil
         }
         //currentTime = .zero
     }
}
