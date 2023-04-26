//
//  Bundle.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 26/04/2023.
//

import Foundation

extension Bundle {
    
    public var appVersionShort: String {
        guard let result = infoDictionary?["CFBundleShortVersionString"] as? String else {return ""}
        return result
    }
    
    public var appVersionLong: String {
        guard let result = infoDictionary?["CFBundleVersion"] as? String else {return ""}
        return result
    }
}
