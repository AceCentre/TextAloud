//
//  Audio.swift
//  TextAloud
//
//

import Foundation


struct AudioModel: Codable{
    let url: URL
    let duration: Double
    let rangesData: [RangesData]
    let averageWordTime: Double
    
    
    init(url: URL, duration: Double, rangesData: [RangesData]) {
        self.url = url
        self.duration = duration
        self.rangesData = rangesData
        self.averageWordTime = duration / Double(rangesData.count)
    }
        
    struct RangesData: Codable{
        
        let range: NSRange
        let timeOffsets: Double
        
        init(offset: UInt, wordLength: UInt, timeOffsets: UInt) {
            self.range = .init(location: Int(offset), length: Int(wordLength))
            self.timeOffsets = timeOffsets.tikcsToSeconds
        }
    }
}



