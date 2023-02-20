//
//  Helpers.swift
//  TextAloud
//
//

import Foundation
import PDFKit
import SNDocx

final class Helpers{
    
    
    static func getWordRangeAtIndex(_ index: Int, _ text: String) -> NSRange {
        var endIndex = 0, startIndex = 0
        let textLength = text.length
        if index == textLength{
            endIndex = textLength
            for i in (0...index).reversed() {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == 0 {
                    startIndex = i
                    break
                }
            }
        } else if index == 0 {
            startIndex = 0
            for i in 0...textLength {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == text.length {
                    endIndex = i
                    break
                }
            }
        } else {
            for i in index...textLength {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == textLength {
                    endIndex = i
                    break
                }
            }
            for i in (0...index-1).reversed() {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == 0 {
                    startIndex = i
                    break
                }
            }
        }
        return NSRange(location: startIndex, length: endIndex - startIndex)
    }
    
    
    
   static func getSentenceRangeForLocation(_ currentLocation: Int, _ text: String) -> NSRange {
       
        var startIndex = 0, endIndex = 0
        let textLength = text.length
        if currentLocation == textLength && currentLocation - 2 >= 0 {
            endIndex = textLength
            for i in (0...(currentLocation - 2)).reversed() {
                if isEndOfSentence(text[i]) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        } else if currentLocation == 0 {
            startIndex = 0
            for i in 0...textLength - 1 {
                if isEndOfSentence(text[i]) || i == textLength - 1 {
                    endIndex = i + 1
                    break
                }
            }
        } else {
            for i in currentLocation...textLength - 1 {
                if isEndOfSentence(text[i]) || i == textLength - 1 || isInCharacterSer(text[i], CharacterSet.newlines) {
                    endIndex = i + 1
                    break
                }
            }
            for i in (0...currentLocation-1).reversed() {
                if isEndOfSentence(text[i]) || i == 0 || isInCharacterSer(text[i], CharacterSet.newlines){
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        }
        return NSRange(location: startIndex, length: endIndex - startIndex)
    }
    
    
   static func getParagraphRangeForLocation(_ currentLocation: Int, _ text: String) -> NSRange {
        var startIndex = 0, endIndex = 0
        let textLength = text.length
        if currentLocation == textLength && currentLocation - 1 >= 0 {
            endIndex = textLength
            for i in (0...(currentLocation - 1)).reversed() {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        } else if currentLocation == 0 {
            startIndex = 0
            for i in 0...currentLocation {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == textLength {
                    endIndex = i
                    break
                }
            }
        } else {
            for i in currentLocation...textLength {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == textLength {
                    endIndex = i
                    break
                }
            }
            for i in (0...currentLocation - 1).reversed() {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        }
        return NSRange(location: startIndex, length: endIndex - startIndex)
    }
    
    
   static func isInCharacterSer(_ input: String, _ set: CharacterSet) -> Bool {
        return input.rangeOfCharacter(from: set) != nil
    }

  static func isEndOfSentence(_ input: String) -> Bool {
        return input == "." || input == "!" || input == "?"
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
