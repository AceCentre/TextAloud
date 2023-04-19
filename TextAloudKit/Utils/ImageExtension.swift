//
//  Image.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 17/04/2023.
//

import Foundation
import SwiftUI

class ImageProvider {
    static func get(name: String) -> UIImage {
        return UIImage(named: name, in: Bundle(for: self), with: nil) ?? UIImage()
    }
}

extension Image {
    /// Takes an asset name then creates a UIImage element to force it to use the current bundle.
    /// This forces images to work in AppExtensions aswell.
    /// - Parameter name: The name of the asset
    public init(nameForAssetInTextAloudKit: String) {
        self.init(uiImage: ImageProvider.get(name: nameForAssetInTextAloudKit))
    }
}
