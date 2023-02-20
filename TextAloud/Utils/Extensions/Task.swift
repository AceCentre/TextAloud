//
//  Task.swift
//  TextAloud
//
//

import Foundation


extension Task where Failure == Error {
    @discardableResult
    static func delayed(
        byTimeInterval delayInterval: TimeInterval,
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            let delay = UInt64(delayInterval * 1_000_000_000)
            try await Task<Never, Never>.sleep(nanoseconds: delay)
            return try await operation()
        }
    }
}


extension UInt{
    
    ///ticks = 100 nanosec
    var tikcsToSeconds: Double{
        Double(self) / 10_000_000
    }
    
    var tikcsToMillisecond: Double{
        Double(self) / 10
    }
    
}
