//
//  Audio.swift
//  TextAloud
//
//

import Foundation


struct AudioModel{
    let url: URL
    let duration: Double
    let rangesData: [RangesData]
    
    
    //var remainingDuration: Double
    
    
    init(url: URL, duration: Double, rangesData: [RangesData]) {
        self.url = url
        self.duration = duration
       // self.remainingDuration = duration
        self.rangesData = rangesData
    }
    
//    mutating func updateRemainingDuration(_ currentTime: Double){
//        let dif = duration - currentTime
//        if dif > 0{
//            remainingDuration = dif
//        }
//    }
//
//    mutating func resetRemainingDuration(){
//        remainingDuration = duration
//    }
    
    struct RangesData{
        
        let range: NSRange
        let timeOffsets: Double
        
        init(offset: UInt, wordLength: UInt, timeOffsets: UInt) {
            self.range = .init(location: Int(offset), length: Int(wordLength))
            self.timeOffsets = timeOffsets.tikcsToMillisecond
        }
    }
}



