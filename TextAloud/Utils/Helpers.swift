//
//  Helpers.swift
//  TextAloud
//
//

import Foundation
import PDFKit
import SNDocx

final class Helpers{
    static func getAllTextRange(_ location: Int, _ text: String) -> NSRange{
        .init(location: 0, length: text.length)
    }
    
    static func getRangeTextForIndex(index: Int, with options: String.EnumerationOptions, text: String) -> NSRange{
        var ranges = [NSRange]()
        let fullTextRange = text.startIndex ..< text.endIndex
        
        // If we have overshot with our recursion bail back to the start
        if index > text.length {
            return .init(location: 0, length: 0)
        }
        
        // Put all the ranges into a list
        text.enumerateSubstrings(in: fullTextRange, options: options) { _, substringRange, enclosingRange, _ in
            ranges.append(NSRange(substringRange, in: text))
        }
        
        // Find the matching range or move to the next stop
        if let foundRange = ranges.first(where: {$0.contains(index)}) {
            return foundRange
        } else {
            return getRangeTextForIndex(index: index + 1, with: options, text: text)
        }
    }
    
    
   static func pdfToText(for url: URL) -> String?{
       let docContent = NSMutableAttributedString()
       guard let pdf = PDFDocument(url: url) else {return nil}
       for i in 1 ..< pdf.pageCount {
           guard let page = pdf.page(at: i) else { continue }
           guard let pageContent = page.attributedString else { continue }
           docContent.append(pageContent)
       }
       return docContent.string
   }
    
    static func docxToText(for url: URL) -> String?{
        return SNDocx.shared.getText(fileUrl: url)?.withoutTags
    }
    
    static func plainToText(for url: URL) -> String?{
        guard let attributedStringWithPlain: NSAttributedString = try? NSAttributedString(url: url, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.plain], documentAttributes: nil) else { return nil}
        return attributedStringWithPlain.string
    }
    
    
    static func rtfToText(for url: URL) -> String?{
        guard let attributedStringWithPlain: NSAttributedString = try? NSAttributedString(url: url, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) else { return nil}
        return attributedStringWithPlain.string
    }
    
    
    static func showShareSheet(data: Any){
        UIActivityViewController(activityItems: [data], applicationActivities: nil).presentInKeyWindow()
    }
}


extension UIViewController {
    
    func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController?.present(self, animated: animated, completion: completion)
    }
}
