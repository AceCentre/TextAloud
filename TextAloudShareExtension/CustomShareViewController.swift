//
//  CustomShareViewController.swift
//  TextAloudShareExtension
//
//

import UIKit
import UniformTypeIdentifiers


class CustomShareViewController: UIViewController {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18, weight: .bold)
        textView.tintColor = .black
        textView.textAlignment = .natural
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        setupNavBar()
        setupViews()
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "Import to TextAloud"
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
        
    }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        let def = UserDefaults(suiteName: "group.uk.org.acecentre.TextAloud")
        def?.set(textView.text, forKey: "shareText")
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    


    private func setupViews() {
        self.view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            textView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }
    
    // NSObject has no magically acquired extension context, we must keep a reference
    
    let desiredType = UTType.plainText.identifier
    
    func setData() {
        let items = self.extensionContext!.inputItems
        guard let extensionItem = items[0] as? NSExtensionItem else {return}
        guard let provider = extensionItem.attachments?.first else {return}
        guard provider.hasItemConformingToTypeIdentifier(self.desiredType) else {return}
        provider.loadItem(forTypeIdentifier: self.desiredType) {
            item, err in
            DispatchQueue.main.async {
                self.textView.text = item as? String
            }
        }
    }
}
