//
//  NetworkMonitorManager.swift
//  TextAloud
//
//

import Foundation
import Network

public class NetworkMonitorManager: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")
    
    @Published public var isOnline: Bool = false
    @Published public var isExpensive: Bool = false
    @Published public var presentExpensiveNotification: Bool = false
    @Published public var presentOfflineNotification: Bool = false

    public init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied{
                    self.isOnline = true
                }else{
                    self.isOnline = false
                }
                
                self.isExpensive = path.isExpensive
                
                if self.isExpensive {
                    self.presentExpensiveNotification = true
                } else if self.isOnline == false {
                    self.presentOfflineNotification = true
                }
            }
        }
        monitor.start(queue: queue)
    }
}
