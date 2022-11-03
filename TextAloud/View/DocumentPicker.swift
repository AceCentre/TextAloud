//
//  DocumentPicker.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 29.10.2022.
//

import SwiftUI
import UIKit
import MobileCoreServices
import SNDocx

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileContent: NSAttributedString
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        
        if #available(iOS 14, *) {
            controller = UIDocumentPickerViewController(forOpeningContentTypes: [.content, .rtf, .text], asCopy: true)
        } else {
            controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypeRTF), String(kUTTypeText), String(kUTTypeData)], in: .import)
        }
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {}
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding var fileContent: NSAttributedString
    
    init(fileContent: Binding<NSAttributedString>) {
        _fileContent = fileContent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileURL = urls[0]
        print(fileURL)
        let temp = NSData(contentsOf: fileURL)
        if let tryForString = try? NSAttributedString(data: temp! as Data, options: [
            .documentType: NSAttributedString.DocumentType.rtf,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil) {
            fileContent = NSAttributedString(string: tryForString.string)
            return
        }
        if let tryForString = try? NSAttributedString(data: temp! as Data, options: [
            .documentType: NSAttributedString.DocumentType.plain,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil) {
            fileContent = NSAttributedString(string: tryForString.string)
            return
        }
        if let result = SNDocx.shared.getText(fileUrl: urls[0]) {
            fileContent = NSAttributedString(string: result)
            return
        }
        print(urls[0].absoluteURL)
    }
}
