//
//  Language.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 02/05/2023.
//

import Foundation


public class Language {
    public var languageName: String
    public var languageRegion: String?
    public var languageCode: String
    
    public init(_ languageCode: String) {
        let locale: Locale = .current
                
        if let language = locale.localizedString(forLanguageCode: languageCode) {
            self.languageName = language
        } else {
            self.languageName = languageCode
        }
        
        let languageCodeParts = languageCode.components(separatedBy: "-")
        
        if(languageCodeParts.count > 1) {
            let regionCode = languageCodeParts[1]
            
            if let region = locale.localizedString(forRegionCode: regionCode) {
                if region != "Unknown Region" {
                    self.languageRegion = region
                }
            }
        }
                
        self.languageCode = languageCode
    }
    
   
}
