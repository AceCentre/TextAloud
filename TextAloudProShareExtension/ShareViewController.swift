//
//  ShareViewController.swift
//  TextAloudShareExtension
//

import UIKit
import Social
import CoreServices
import UniformTypeIdentifiers
import Foundation
import SwiftUI
import Combine
import TextAloudKit
import PDFKit

enum FileType: String{
    case rtf, pdf, docx, txt
}

class ShareNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let controller = ShareViewController()
        self.setViewControllers([controller], animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class ShareViewController: UIViewController {
    private var appURLString = "textaloudpro://insertText?text=."
    let desiredType = UTType.plainText.identifier
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        
        let child = UIHostingController(rootView: ShareLoadingPage())
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.frame = self.view.bounds
        self.view.addSubview(child.view)
        self.addChild(child)
        
        NSLayoutConstraint.activate([
            
            child.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            child.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }
    
    /**
     TODO: This has a bunch of repetitive code that should be moved into a framework and reused
    */
    func getTextFromItem(item: NSSecureCoding?) -> String {
        if let text = item as? String {
            return text
        } else if let url = item as? NSURL {
            print("THIS IS A URL")
            
             url.startAccessingSecurityScopedResource()
                
            guard let pathExtention = url.pathExtension else { return "Cannot read file. E01" }
            
            if let type = FileType(rawValue: pathExtention) {
                if type == .pdf {
                    print("Trying PDF Type")
                    
                    if let pdf = PDFDocument(url: url as URL) {
                        let pageCount = pdf.pageCount
                        let documentContent = NSMutableAttributedString()
                        
                        for i in 0 ..< pageCount {
                            guard let page = pdf.page(at: i) else { continue }
                            guard let pageContent = page.attributedString else { continue }
                            documentContent.append(pageContent)
                        }
                        
                        let text = String(documentContent.mutableString)
                        
                        return text
                    }
                } else if type == .txt {
                    guard let attributedStringWithPlain: NSAttributedString = try? NSAttributedString(url: url as URL, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.plain], documentAttributes: nil) else { return "Unsupported File" }
                    return attributedStringWithPlain.string
                } else if type == .rtf {
                    guard let attributedStringWithPlain: NSAttributedString = try? NSAttributedString(url: url as URL, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) else { return "Unsupported File" }
                    return attributedStringWithPlain.string
                } else {
                    return "Unsupported file type."
                }
            }
            
            
        }
        
        
        return "This text cannot be processed by TextAloud"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("APPEARED")
        
        guard let context = extensionContext else {
            print("No context")
            return
        }
        let items = context.inputItems
        guard let extensionItem = items[0] as? NSExtensionItem else {
        
            print("No itmes")
            return
            
        }
        guard let provider = extensionItem.attachments?.first else {
            print("No provider")
            return
            
        }
        guard provider.hasItemConformingToTypeIdentifier(self.desiredType) else {
            print("Not type")
            return
            
        }
        
        print("GOT THIS FAR")
        
        provider.loadItem(forTypeIdentifier: self.desiredType) {(item, error) in
            print("ITEM LOADED")
            
            if let error = error {
                print("Text-Error: \(error.localizedDescription)")
            }
            
            let result = self.getTextFromItem(item: item)
            let base64EncodedText = Data(result.utf8).base64EncodedString()
            
            var urlScheme = "textaloudpro"
            
            self.appURLString = urlScheme + "://insertText?text=" + base64EncodedText
            
            let def = UserDefaults(suiteName: "group.uk.org.acecentre.Text.Aloud")
            def?.set(result, forKey: "shareText")
            
            self.openMainApp()

        }
    }
    
    
    
    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURLString) else { return }
            _ = self.openURL(url)
        })
    }
    
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
