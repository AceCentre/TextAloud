//
//  RootViewModel.swift
//  TextAloud
//
//

import Foundation
import SwiftUI
import Combine
import PDFKit
import TextAloudKit

class RootViewModel: ObservableObject{
    @Published var text: String = "Example text, press the plus button to add your own document."
    @Published var isChangeText: Bool = false
    @Published var isEditMode: Bool = false
    @AppStorage("currentSelectionMode") var currentSelectionMode: TextSelectionEnum = .paragraph
    @Published var isFocused: Bool = false
    @Published var selectedRange: NSRange?
    @Published var tappedRange: NSRange?
    @Published var error: AppError?
    @Published var showLoader: Bool = false
    @Published var cursorPos: Int?
    private var cancellable = Set<AnyCancellable>()
    private let ncPublisher = NotificationCenter.default
        .publisher(for: NSNotification.OnStopSpeech)
    
    private var tempText: String = ""
    
    
    
    init(){
    }
    
    
    
    var isDisabledSaveButton: Bool{
        isFocused && !isChangeText
    }
    
    func removeText(){
        selectedRange = nil
        text.removeAll()
    }
    
    func setSelectionMode(_ type: TextSelectionEnum){
        selectedRange = nil
        currentSelectionMode = type
    }
    
    func onEditToggle(){
        isEditMode.toggle()
        if selectedRange != nil{
            self.selectedRange = nil
        }
    }
    
    func onTappedEditSaveButton(){
        tempText = isFocused ? "" : text
        onEditToggle()
        isChangeText = false
    }
    
    func onCancelTapped(){
        text = tempText
        onEditToggle()
        isChangeText = false
    }
    
    func setSelectedRangeForMode(with location: Int) -> NSRange{
        let range = currentSelectionMode.getRangeForIndex(location, text)
        if currentSelectionMode != .all{
            selectedRange = range
        }
        return range
    }
    
    private func setDefaultRangeForMode(){
        if !text.isEmpty{
            selectedRange = currentSelectionMode.getRangeForIndex(0, text)
        }
    }
    
    func setShareObjectIfNeeded() -> Bool{
        let key = "shareText"
        
        let suiteName = "group.uk.org.acecentre.Text.AloudPro"
        
        let def = UserDefaults(suiteName: suiteName)
        if let text = def?.string(forKey: key), !text.isEmpty{
            self.text = text
            def?.removeObject(forKey: key)
            return true
        }
        return false
    }
}


extension RootViewModel{
    func onDocumentPick(for result: Result<[URL], Error>){
        showLoader = true
        selectedRange = nil
        switch result {
        case .success(let success):
            if let url = success.first, url.startAccessingSecurityScopedResource(){
                
                if let type = TextAloudFileType(rawValue: url.pathExtension) {
                    DispatchQueue.global(qos: .userInitiated).async {
                        guard let text = type.getText(for: url) else {
                            self.showLoader = false
                            self.error = .messageError("Failed to upload, try again. E1")
                            return
                        }
                       
                        DispatchQueue.main.async {
                            url.stopAccessingSecurityScopedResource()
                            self.text = text
                            self.showLoader = false
                            self.setDefaultRangeForMode()
                            
                            if text.isEmpty{
                                self.showLoader = false
                                self.error = .messageError("Failed to upload, try again. E2")
                            }
                        }
                    }
                }else{
                    self.showLoader = false
                    self.error = .unsupportedFile
                }
            }
        case .failure(_):
            self.error = .importerError
            showLoader = false
        }
    }
}
