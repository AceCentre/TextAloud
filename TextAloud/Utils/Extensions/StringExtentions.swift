//
//  StringExtentions.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 31.10.2022.
//

import Foundation

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    var byWordsAndRanges: [(String, Range<String.Index>)] {
        var words: [(String, Range<String.Index>)] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { word, range, _, _ in
            words.append((word!, range))
        }
        return words
    }
    
    var withoutTags: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var titlecased: String {
        self.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: self.range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
    
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
    
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
    
    var shortLocaleLanguage: String{
        let locale: Locale = .current
        
        guard let countru = locale.localizedString(forLanguageCode: self) else {
            return "None"
        }
        let region = String(self.suffix(2))
        return "\(countru) \(region)"
    }
    
    var createName: String{
       String(self.prefix(10) + "...")
    }
    
    var isRTLCode: Bool{
        switch self{
        case "ar", "arc", "dv", "fa", "ha", "he", "khw", "ks", "ku",
            "ps", "ur", "yi":
            return true
        default : return false
        }
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
