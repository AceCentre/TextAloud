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
import PDFKit

enum FileType: String{
    case rtf, pdf, docx, txt
}

public class ShareViewController: UIViewController {
    var appUrlPrefix: String
    var groupName: String
    var appURLString = ""
    let desiredType = UTType.plainText.identifier
    
    public init(appUrlPrefix: String, groupName: String) {
        self.appUrlPrefix = appUrlPrefix
        self.groupName = groupName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.appUrlPrefix = ""
        self.groupName = ""
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
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
    
    func getTextFromItem(item: NSSecureCoding?) -> String {
        if let text = item as? String {
            return text
        } else if let url = item as? NSURL {
            print("THIS IS A URL")
            
            url.startAccessingSecurityScopedResource()
            
            guard let pathExtention = url.pathExtension else { return "Cannot read file. E01" }
            
            if let type = TextAloudFileType(rawValue: pathExtention) {
                if let result = type.getText(for: url as URL) {
                    return result
                } else {
                    return "Cannot read file: E2"
                }
            }
            
            
        }
        
        
        return "This text cannot be processed by TextAloud"
    }
    
    func openTextInApp(result: String) {
        let base64EncodedText = Data(result.utf8).base64EncodedString()
        
        self.appURLString = self.appUrlPrefix + "://insertText?text=" + base64EncodedText
        
        let def = UserDefaults(suiteName: self.groupName)
        def?.set(result, forKey: "shareText")
        
        self.openMainApp()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let context = extensionContext {
            let items = context.inputItems
            if let extensionItem = items[0] as? NSExtensionItem {
                if let provider = extensionItem.attachments?.first {
                    if provider.hasItemConformingToTypeIdentifier(self.desiredType) {
                        
                        provider.loadItem(forTypeIdentifier: self.desiredType) {(item, error) in
                            print("ITEM LOADED")
                            
                            if let error = error {
                                print("Text-Error: \(error.localizedDescription)")
                            }
                            
                            let result = self.getTextFromItem(item: item)
                            
                            self.openTextInApp(result: result)
                        }
                        
                    } else {
                        self.openTextInApp(result: "Failed to read file. E4")
                        
                    }
                } else {
                    self.openTextInApp(result: "Failed to read file. E3")
                }
            } else {
                self.openTextInApp(result: "Failed to read file. E2")
            }
        } else {
            self.openTextInApp(result: "Failed to read file. E1")
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
