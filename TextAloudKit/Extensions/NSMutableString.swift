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
            return true
        } catch {
            return false
        }
    }
}
