//
//  StringExtentions.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 31.10.2022.
//

import Foundation

extension String {
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, self.count) ..< self.count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(self.count, r.lowerBound)),
                                            upper: min(self.count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    public var titlecased: String {
        self.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: self.range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
    
    public func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
    
    public var getFullLocaleLanguageStr: String{
        let locale: Locale = .current
        
        guard let countru = locale.localizedString(forLanguageCode: self) else {
            return "None"
        }
        
        guard let region = locale.localizedString(forRegionCode: String(self.suffix(2))) else{
            
            return countru
        }
        return "\(countru) (\(region))"
    }
    
    public var shortLocaleLanguage: String{
        let locale: Locale = .current
        
        guard let countru = locale.localizedString(forLanguageCode: self) else {
            return "None"
        }
        let region = String(self.suffix(2))
        return "\(countru) \(region)"
    }
    
    public var createName: String{
       String(self.prefix(10) + "...")
    }
}
