//
//  Sequence.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 20/04/2023.
//

import Foundation

extension Sequence where Element: Hashable {
    public func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
