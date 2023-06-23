//
//  TextView.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 04/05/2023.
//

import SwiftUI
import UIKit

public struct RawTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var currentWord: NSRange?
    @Binding var selectedRange: NSRange?
    @Binding var selectionMode: TextSelectionEnum
    @Binding var cursorPos: Int?

    @AppStorage("fontSize") var fontSize: Int = 25
    @AppStorage("selectedColor") var selectedColor: Color = Color(UIColor(red: 0.96, green: 0.9, blue: 0.258, alpha: 0.4))
    @AppStorage("readingColor") var readingColor: Color = Color.red
    
    public init(
        text: Binding<String>,
        isEditing: Binding<Bool>,
        currentWord: Binding<NSRange?>,
        selectedRange: Binding<NSRange?>,
        selectionMode: Binding<TextSelectionEnum>,
        cursorPos: Binding<Int?>
    ){
        self._text = text
        self._isEditing = isEditing
        self._currentWord = currentWord
        self._selectedRange = selectedRange
        self._selectionMode = selectionMode
        self._cursorPos = cursorPos
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> UITextView {
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
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        // Note, the uiView.selectedRange is NOT the selectedRange that is bound to self. This is the cursor position
        let originalCursorPosition = uiView.selectedRange
        
        let previousAttributedText = uiView.attributedText
        let currentAttributedText = NSMutableAttributedString(string: text)
        
        currentAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .heavy), range: NSRange(location: 0, length: currentAttributedText.length))
        currentAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: currentAttributedText.length))
        
        /// Highlight the current word
        if let currentWordRange = currentWord, currentAttributedText.mutableString.isRangeValid(range: currentWordRange) {
            currentAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(readingColor), range: currentWordRange)
        }
        
        /// Highlight the currently selected text
        if let selectedRange, currentAttributedText.mutableString.isRangeValid(range: selectedRange) {
            currentAttributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(selectedColor), range: selectedRange)
        }
        
        /// Force UI view in and out of edit mode. Protect against extra calls
        if isEditing && uiView.isEditable == false {
            uiView.isEditable = true
            uiView.becomeFirstResponder()
        } else if (isEditing == false && uiView.isEditable == true) {
            uiView.isEditable = false
            uiView.resignFirstResponder()
        }
        
        if let currentWordRange = currentWord, !isEditing {
            uiView.scrollRangeToVisible(currentWordRange)
        }
        
        // Only reset the attributedText if its actually altered, this will prevent mouse jumping about.
        if previousAttributedText != currentAttributedText {
            uiView.attributedText = currentAttributedText
            uiView.selectedRange = originalCursorPosition
        }
    }
    
    
    
    public class Coordinator: NSObject, UITextViewDelegate {

        var parent: RawTextView
        
        init(_ uiTextView: RawTextView) {
            self.parent = uiTextView
        }
        
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.isEditing = true
            }
        }
        
        public func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.cursorPos = textView.selectedRange.location
            }
        }

        public func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text
            }
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.isEditing = false
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
                parent.selectedRange = parent.selectionMode.getRangeForIndex(characterIndex, textView.textStorage.string)
            }
        }
    }
}