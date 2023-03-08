//
//  ShareViewController.swift
//  TextAloudShareExtension
//
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

@objc(ShareNavigationController)
class ShareNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let controller = CustomShareViewController()
        self.setViewControllers([controller], animated: false)
     }

     @available(*, unavailable)
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
     }

    
    

}


