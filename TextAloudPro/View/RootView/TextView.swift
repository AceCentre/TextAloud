//
//  TextView.swift
//  TextAloud
//
//

import SwiftUI
import TextAloudKit

struct TextView: View {
    @Binding var currentWord: NSRange?
    @ObservedObject var rootVM: RootViewModel
    
    var body: some View {
        RawTextView(focused: $rootVM.isFocused, text: $rootVM.text, isEditing: $rootVM.isEditMode, currentWord: $currentWord, selectedRange: $rootVM.selectedRange, selectionMode: $rootVM.currentSelectionMode, cursorPos: $rootVM.cursorPos)
            .padding(10)
            .background(.white)
            .cornerRadius(12)
            .overlay{
                if rootVM.isFocused{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.limeChalk, lineWidth: 3)
                }
            }
    }
}

struct TextView_Previews: PreviewProvider {
    @ObservedObject static var rootVM = RootViewModel()
    
    static var previews: some View {
        ZStack{
            Color.deepOcean
            VStack {
                Toggle("Toggle Focus", isOn: $rootVM.isFocused).padding()
                TextView(currentWord: .constant(.init(location: 0, length: 5)), rootVM: rootVM)
                    .frame(height: 400)
                    .padding()
            }
            
        }
        
        
    }
}
