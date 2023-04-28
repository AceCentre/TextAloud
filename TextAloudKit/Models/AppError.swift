//
//  AppErrir.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 28/04/2023.
//

import Foundation

public enum AppError: LocalizedError, Equatable {
    var id: String { UUID().uuidString }
    case unsupportedFile
    case importerError
    case messageError(String)
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .messageError(let message):
            return message
        case .unknown(let error):
            return "Unknown error \(error)"
        case .importerError: return "Error importing file, try again"
        case .unsupportedFile: return "Sorry, this file type is not yet supported"
        }
    }
}
