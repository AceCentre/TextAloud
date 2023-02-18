//
//  RootViewModel.swift
//  TextAloud
//
//

import Foundation

class RootViewModel: ObservableObject{
    
    @Published var text: String = "Example text, press the plus button to add your own document."
    var tempText: String = ""
    @Published var isChangeText: Bool = false
    @Published var isEditMode: Bool = false
    @Published var currentSelectionMode: SelectionEnum = .word
    @Published var isFocused: Bool = false
    @Published var selectedRange: NSRange?
    
    
    var isDisabledSaveButton: Bool{
        isFocused && !isChangeText
    }
    
    func removeText(){
        selectedRange = nil
        text.removeAll()
    }
    
    func setSelectionMode(_ type: SelectionEnum){
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
}



