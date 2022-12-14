//
//  TextView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 28.10.2022.
//

import SwiftUI
import UIKit


extension UITextView {

    func addButtons(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func doneButtonTapped(button: UIBarButtonItem) {
        self.resignFirstResponder()
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: NSAttributedString
    @Binding var cursorPosition: NSRange?
    @Binding var newCursorPosition: NSRange?
    @State var isEditing: Bool = false
    @StateObject var synth: SpeechSynthesizer
    @AppStorage("fontSize") var fontSize: Int = 25
    @AppStorage("selectedColor") var selectedColor: Color = Color(UIColor(red: 0.96, green: 0.9, blue: 0.258, alpha: 0.4))
    @AppStorage("readingColor") var readingColor: Color = Color.red
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.tintColor = .black
        textView.addButtons(title: "Done", target: textView, selector: #selector(textView.doneButtonTapped(button:)))
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.textColor = UIColor.black
        uiView.backgroundColor = UIColor.white
        let attrStr = NSMutableAttributedString(string: text.string)
        attrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .heavy), range: NSRange(location: 0, length: attrStr.length))
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attrStr.length))
        if !isEditing && cursorPosition != nil {
            attrStr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(selectedColor), range: wordRangeAtIndex(index: cursorPosition!.location))
        }
        if synth.currentWord != nil {
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(readingColor), range: synth.currentWord!)
            uiView.scrollRangeToVisible(synth.currentWord!)
        }
        uiView.attributedText = attrStr
    }
    
    func wordRangeAtIndex(index:Int) -> NSRange {
        var endIndex = 0, startIndex = 0
        if index == text.string.length {
            endIndex = text.string.length
            for i in (0...index).reversed() {
                if isInCharacterSer(text.string[i], CharacterSet.whitespacesAndNewlines) || i == 0 {
                    startIndex = i
                    break
                }
            }
        } else if index == 0 {
            startIndex = 0
            for i in 0...text.string.length {
                if isInCharacterSer(text.string[i], CharacterSet.whitespacesAndNewlines) || i == text.string.length {
                    endIndex = i
                    break
                }
            }
        } else {
            for i in index...text.string.length {
                if isInCharacterSer(text.string[i], CharacterSet.whitespacesAndNewlines) || i == text.string.length {
                    endIndex = i
                    break
                }
            }
            for i in (0...index-1).reversed() {
                if isInCharacterSer(text.string[i], CharacterSet.whitespacesAndNewlines) || i == 0 {
                    startIndex = i
                    break
                }
            }
        }
        return NSRange(location: startIndex, length: endIndex - startIndex)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isEditing = true
            if parent.cursorPosition != nil {
                textView.selectedRange = parent.cursorPosition!
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.attributedText
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.cursorPosition = textView.selectedRange
            parent.isEditing = false
        }
    }
}
