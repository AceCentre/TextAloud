//
//  NSRange.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 20/04/2023.
//

import Foundation

extension NSRange{
    
    public var nextLocation: Int {
        self.location + self.length + 1
    }
    
}
