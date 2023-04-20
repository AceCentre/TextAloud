//
//  UInt.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 20/04/2023.
//

import Foundation

extension UInt{
    
    ///ticks = 100 nanosec
    public var tikcsToSeconds: Double{
        Double(self) / 10_000_000
    }
    
    public var tikcsToMillisecond: Double{
        Double(self) / 10
    }
    
}
