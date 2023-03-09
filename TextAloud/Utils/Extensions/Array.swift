//
//  Array.swift
//  TextAloud
//
//

import Foundation


extension Array where Iterator.Element == Double{
    
    var average: Double? {
        guard !isEmpty else { return nil }
        return self.reduce(0.0, +) / Double(count)
    }
}

extension NSRange{
    
    var nextLocation: Int {
        self.location + self.length + 1
    }
    
}
