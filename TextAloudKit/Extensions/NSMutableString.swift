//
//  NSMutableString.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 04/05/2023.
//

import Foundation
import ExceptionCatcher

extension NSMutableString {
    public func isRangeValid(range: NSRange) -> Bool {
        do {
            try ExceptionCatcher.catch {
                return self.substring(with: range)
            }
            print("Uncaught, true")
            return true
        } catch {
            print("Caught, false")
            return false
        }
    }
}
