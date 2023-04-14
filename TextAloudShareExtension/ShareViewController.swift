//
//  ShareViewController.swift
//  TextAloudShareExtension
//
//

import UIKit
import Social
import CoreServices
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    private var appURLString = "textaloud://insertText?text=."
    let desiredType = UTType.plainText.identifier
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let items = self.extensionContext!.inputItems
        guard let extensionItem = items[0] as? NSExtensionItem else {return}
        guard let provider = extensionItem.attachments?.first else {return}
        guard provider.hasItemConformingToTypeIdentifier(self.desiredType) else {return}
        
        provider.loadItem(forTypeIdentifier: self.desiredType) {(item, error) in
            if let error = error {
                print("Text-Error: \(error.localizedDescription)")
            }
            
            if let text = item as? String {
                self.appURLString = "textaloud://insertText?text=" + Data(text.utf8).base64EncodedString()
                
                let def = UserDefaults(suiteName: "group.uk.org.acecentre.Text.Aloud")
                def?.set(text, forKey: "shareText")
                
                self.openMainApp()
            }
            
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
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
