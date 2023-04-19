//
//  RootViewModel.swift
//  TextAloud
//
//

import Foundation
import SwiftUI
import Combine
import PDFKit

class RootViewModel: ObservableObject{
    @Published var text: String = "Example text, press the plus button to add your own document."
    @Published var isChangeText: Bool = false
    @Published var isEditMode: Bool = false
    @AppStorage("currentSelectionMode") var currentSelectionMode: SelectionEnum = .paragraph
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
        startNSNotificationSubsc()
    }
    
    
    
    private func startNSNotificationSubsc(){
        ncPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tappedRange = nil
            }
            .store(in: &cancellable)
    }
    
    
    var isDisabledSaveButton: Bool{
        isFocused && !isChangeText
    }
        
    func removeText(){
        tappedRange = nil
        selectedRange = nil
        text.removeAll()
    }
    
    func setSelectionMode(_ type: SelectionEnum){
        tappedRange = nil
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
            tappedRange = nil
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
        
        var suiteName = "group.uk.org.acecentre.Text.AloudPro"
        
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
        tappedRange = nil
        switch result {
        case .success(let success):
            if let url = success.first, url.startAccessingSecurityScopedResource(){
                
                if let type = FileType(rawValue: url.pathExtension) {
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        
                        if type == .pdf {
                            print("Trying PDF Type")
                            
                            if let pdf = PDFDocument(url: url) {
                                let pageCount = pdf.pageCount
                                let documentContent = NSMutableAttributedString()

                                for i in 0 ..< pageCount {
                                    guard let page = pdf.page(at: i) else { continue }
                                    guard let pageContent = page.attributedString else { continue }
                                    documentContent.append(pageContent)
                                }
                                
                                let text = String(documentContent.mutableString)
                                
                                DispatchQueue.main.async {
                                    url.stopAccessingSecurityScopedResource()
                                    self.text = text
                                    self.showLoader = false
                                    self.setDefaultRangeForMode()
                                    if text.isEmpty{
                                        self.error = .messageError("Failed to upload, try again")
                                    }
                                }
                                
                                
                            }

                            
                        } else {
                            
                            if let text = type.getText(for: url){
                                DispatchQueue.main.async {
                                    url.stopAccessingSecurityScopedResource()
                                    self.text = text
                                    self.showLoader = false
                                    self.setDefaultRangeForMode()
                                    
                                    if text.isEmpty{
                                        self.error = .messageError("Failed to upload, try again")
                                    }
                                }
                            }
                        }
                        
                        
                    
                    }
                }else{
                    self.showLoader = false
                    self.error = .unSupportedFile
                }
            }
        case .failure(_):
            self.error = .importerError
            showLoader = false
        }
    }
}



extension RootViewModel{
    
    enum FileType: String{
        case rtf, pdf, txt
        
        func getText(for url: URL) -> String?{
            switch self {
            case .rtf: return Helpers.rtfToText(for: url)
            case .pdf: return Helpers.pdfToText(for: url)
            case .txt: return Helpers.plainToText(for: url)
            }
        }
    }
}


