//
//  ShareViewController.swift
//  TextAloudShareExtension
//

import UIKit
import Social
import CoreServices
import UniformTypeIdentifiers
import SwiftUI
import TextAloudKit

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
    private var appURLString = "textaloud://insertText?text=."
    let desiredType = UTType.plainText.identifier
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        
        let child = UIHostingController(rootView: Loading())
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let context = extensionContext else { return }
        let items = context.inputItems
        guard let extensionItem = items[0] as? NSExtensionItem else { return }
        guard let provider = extensionItem.attachments?.first else { return }
        guard provider.hasItemConformingToTypeIdentifier(self.desiredType) else { return }
        
        provider.loadItem(forTypeIdentifier: self.desiredType) {(item, error) in
            if let error = error {
                print("Text-Error: \(error.localizedDescription)")
            }
            
            if let text = item as? String {
                let base64EncodedText = Data(text.utf8).base64EncodedString()
                self.appURLString = "textaloud://insertText?text=" + base64EncodedText
                
                let def = UserDefaults(suiteName: "group.uk.org.acecentre.Text.Aloud")
                def?.set(text, forKey: "shareText")
                
                self.openMainApp()
            }
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
