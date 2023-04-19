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

@objc(ShareNavigationController)
class ShareNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let controller = ShareViewController(appUrlPrefix: "textaloudpro", groupName: "uk.org.acecentre.group.Text.AloudPro")
        self.setViewControllers([controller], animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
