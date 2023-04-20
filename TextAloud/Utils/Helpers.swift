//
//  Helpers.swift
//  TextAloud
//
//

import Foundation
import PDFKit

final class Helpers{

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
    
    static func plainToText(for url: URL) -> String?{
        guard let attributedStringWithPlain: NSAttributedString = try? NSAttributedString(url: url, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.plain], documentAttributes: nil) else { return nil}
        return attributedStringWithPlain.string
    }
    
    
    static func rtfToText(for url: URL) -> String?{
        guard let attributedStringWithPlain: NSAttributedString = try? NSAttributedString(url: url, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) else { return nil}
        return attributedStringWithPlain.string
    }
}
