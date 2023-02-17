//
//  VoiceModel.swift
//  TextAloud
//
//

import Foundation

struct VoiceModel: Identifiable, Hashable{
    let id: String
    let name: String
    let languageCode: String
    var languageStr: String { languageCode.getFullLocaleLanguageStr }
}



extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension String {
    
    
    var getFullLocaleLanguageStr: String{
        let locale: Locale = .current
        
        guard let countru = locale.localizedString(forLanguageCode: self) else {
            return "None"
        }
        
        guard let region = locale.localizedString(forRegionCode: String(self.suffix(2))) else{
            
            return countru
        }
        return "\(countru) (\(region))"
    }
}
