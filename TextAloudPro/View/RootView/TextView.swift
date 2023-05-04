//
//  TextView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 28.10.2022.
//

import SwiftUI
import UIKit
import TextAloudKit

struct TextView: UIViewRepresentable {
    @Binding var focused: Bool
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var currentWord: NSRange?
    @Binding var selectedRange: NSRange?
    @Binding var tappedRange: NSRange?
    @Binding var selectionMode: TextSelectionEnum
    @Binding var cursorPos: Int?

    @AppStorage("fontSize") var fontSize: Int = 25
    @AppStorage("selectedColor") var selectedColor: Color = Color(UIColor(red: 0.96, green: 0.9, blue: 0.258, alpha: 0.4))
    @AppStorage("readingColor") var readingColor: Color = Color.red
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.white
        textView.delegate = context.coordinator
        textView.tintColor = .black
        textView.textAlignment = .natural
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = false
        textView.allowsEditingTextAttributes = false
        textView.autocorrectionType = .default
        
        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.setContentHuggingPriority(.required, for: .horizontal)
        textView.contentInset = .zero
    
        
        let gesture = UITapGestureRecognizer(target: context.coordinator,
                                                     action: #selector(Coordinator.handleTap))
        textView.addGestureRecognizer(gesture)

        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        let cursorPos = uiView.selectedRange

        let attrStr = NSMutableAttributedString(string: text)
        attrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .heavy), range: NSRange(location: 0, length: attrStr.length))

        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attrStr.length))

        if let currentWordRange = currentWord {
            if attrStr.mutableString.isRangeValid(range: currentWordRange) {
                attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(readingColor), range: currentWordRange)
               
                if !isEditing{
                    uiView.scrollRangeToVisible(currentWordRange)
                }
            }
            
       
        }
        
        if let selectedRange {
            if attrStr.mutableString.isRangeValid(range: selectedRange) {
                attrStr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(selectedColor), range: selectedRange)
            }
            
        }
        
        if let tappedRange, !isEditing{
            if attrStr.mutableString.isRangeValid(range: tappedRange) {
                attrStr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(selectedColor), range: tappedRange)

            }
        }
    
        uiView.attributedText = attrStr
        
        uiView.selectedRange = cursorPos
        
        onEdit(uiView)
    }
    
    
    func onEdit(_ uiView: UITextView){
        DispatchQueue.main.async {
            if isEditing {
                uiView.isEditable = true
                uiView.becomeFirstResponder()
                
            }else{
                uiView.isEditable = false
            }
        }
    }
    
    
    class Coordinator: NSObject, UITextViewDelegate {

        var parent: TextView
        
        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.focused = true
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.cursorPos = textView.selectedRange.location
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.focused = false
            }
        }

        
        /// Handle tapped in uiText view
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard !parent.isEditing else { return }
            if let textView = sender.view as? UITextView{
                let textLength = textView.textStorage.length
                let point = sender.location(in: textView)
                let glyphIndex: Int? = textView.layoutManager.glyphIndex(for: point, in: textView.textContainer, fractionOfDistanceThroughGlyph: nil)
                let index: Int? = textView.layoutManager.characterIndexForGlyph(at: glyphIndex ?? 0)
                
                guard let characterIndex = index, characterIndex < textLength else {
                    return
                }
                if parent.selectionMode != .all{
                    parent.tappedRange = parent.selectionMode.getRangeForIndex(characterIndex, textView.textStorage.string)
                }
            }
        }
    }
}
