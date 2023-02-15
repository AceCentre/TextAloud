//
//  RootViewModel.swift
//  TextAloud
//
//

import Foundation

class RootViewModel: ObservableObject{
    
    @Published var text: String = "Example text, press the plus button to add your own document."
    
    
    @Published var isEditMode: Bool = false
    @Published var currentSelectionMode: SelectionEnum = .word
    @Published var isFocused: Bool = false
    @Published var selectedRange: NSRange?
    
    
    func removeText(){
        selectedRange = nil
        text.removeAll()
    }
    
    func setSelectionMode(_ type: SelectionEnum){
        selectedRange = nil
        currentSelectionMode = type
    }
    
    
    
}



