//
//  FileReader.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 26/04/2023.
//

import Foundation
import PDFKit

final class FileReader {
    
   static func pdfToText(for url: URL) -> String?{
       let docContent = NSMutableAttributedString()
       guard let pdf = PDFDocument(url: url) else {return nil}
       for i in 0 ..< pdf.pageCount {
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

public enum TextAloudFileType: String{
    case rtf, pdf, txt
    
    public func getText(for url: URL) -> String?{
        switch self {
        case .rtf: return FileReader.rtfToText(for: url)
        case .pdf: return FileReader.pdfToText(for: url)
        case .txt: return FileReader.plainToText(for: url)
        }
    }
}
