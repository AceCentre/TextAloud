//
//  RootViewModel.swift
//  TextAloud
//
//

import Foundation


class RootViewModel: ObservableObject{
    
    @Published var text: String = "Example text, press the plus button to add your own document."
    @Published var isChangeText: Bool = false
    @Published var isEditMode: Bool = false
    @Published var currentSelectionMode: SelectionEnum = .word
    @Published var isFocused: Bool = false
    @Published var selectedRange: NSRange?
    @Published var tappedRange: NSRange?
    @Published var error: AppError?
    @Published var showLoader: Bool = false
    
    private var tempText: String = ""
    
    var isDisabledSaveButton: Bool{
        isFocused && !isChangeText
    }
    
    init(){
        setDefaultRangeForMode()
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
}


extension RootViewModel{
    
    
    func onDocumentPick(for result: Result<[URL], Error>){
        showLoader = true
        selectedRange = nil
        tappedRange = nil
        switch result {
        case .success(let success):
            if let url = success.first, url.startAccessingSecurityScopedResource(){
                
                if let type = FileType(rawValue: url.pathExtension){
                    
                    DispatchQueue.global(qos: .userInitiated).async{
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
        case rtf, pdf, docx, txt
        
        func getText(for url: URL) -> String?{
            switch self {
            case .rtf: return Helpers.rtfToText(for: url)
            case .pdf: return Helpers.pdfToText(for: url)
            case .docx: return Helpers.docxToText(for: url)
            case .txt: return Helpers.plainToText(for: url)
            }
        }
    }
}


