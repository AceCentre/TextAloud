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


#warning("Need to add iCloud to capabilities")
// An error with Icloud "[DocumentManager] Failed to associate thumbnails for picked URL.."
// Need to add iCloud to capabilities

struct DocumentPicker: UIViewControllerRepresentable {
  
    @Binding var fileContent: String

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.content, .rtf, .text], asCopy: true)
        
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {

        var parent: DocumentPicker

        init(_ parent: DocumentPicker){
            self.parent = parent

        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let fileURL = urls[0]
            print(fileURL)
            if let temp = NSData(contentsOf: fileURL) as? Data {
                if let tryForString = try? NSAttributedString(data: temp, options: [
                    .documentType: NSAttributedString.DocumentType.rtf,
                    .characterEncoding: String.Encoding.utf8.rawValue
                    ], documentAttributes: nil) {
                    parent.fileContent = tryForString.string.withoutTags
                    return
                }
                if let tryForString = try? NSAttributedString(data: temp, options: [
                    .documentType: NSAttributedString.DocumentType.plain,
                    .characterEncoding: String.Encoding.utf8.rawValue
                    ], documentAttributes: nil) {
                    parent.fileContent = tryForString.string.withoutTags
                    return
                }
            }

            if let result = SNDocx.shared.getText(fileUrl: urls[0]) {
                parent.fileContent = result.withoutTags
                return
            }
        }
    }
}
