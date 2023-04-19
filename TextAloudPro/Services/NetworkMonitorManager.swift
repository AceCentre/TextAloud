//
//  NetworkMonitorManager.swift
//  TextAloud
//
//

import Foundation
import Network

class NetworkMonitorManager {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")
    
    var isOnline: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied{
                    self.isOnline = true
                }else{
                    self.isOnline = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}
