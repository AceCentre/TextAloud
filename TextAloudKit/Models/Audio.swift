//  Audio.swift
//  TextAloud
//
//

import Foundation


public struct Audio: Codable{
    public let url: URL
    let duration: Double
    public let rangesData: [RangesData]
    public let averageWordTime: Double
    
    
    public init(url: URL, duration: Double, rangesData: [RangesData]) {
        self.url = url
        self.duration = duration
        self.rangesData = rangesData
        self.averageWordTime = duration / Double(rangesData.count)
    }
        
    public struct RangesData: Codable{
//        public let range: NSRange
        let timeOffsets: Double
        
        public init(offset: UInt, wordLength: UInt, timeOffsets: UInt) {
//            self.range = .init(location: Int(offset), length: Int(wordLength))
            self.timeOffsets = timeOffsets.tikcsToMillisecond
        }
    }


}



