//
//  RootViewModel.swift
//  TextAloud
//
//

import Foundation

class RootViewModel: ObservableObject{
    
    @Published var text: String = "Ut. Sed et arcu ultricies. Amet, efficitur nec lectus interdum eleifend interdum elit. Dictum vulputate ornare faucibus. Sit vulputate platea elit. Non pulvinar vitae ultricies. Leo, dui sapien leo, et, Ut. Sed et arcu ultricies. Amet, efficitur nec lectus interdum eleifend interdum elit. Dictum vulputate ornare faucibus. Sit vulputate platea elit."
    
    
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



