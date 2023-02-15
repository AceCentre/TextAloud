//
//  TestTextView.swift
//  TextAloud
//
//

import SwiftUI
import AVFAudio
struct TestTextView: View {
    @State var text = "test test test test test test. test test test test test test"
    @State var range: NSRange?
    @State var str: String = ""
    @State var selectedRange: NSRange?
    var body: some View {
        VStack {
            //if let range{
                Text(str)
           // }
            
            TestTextUIView(str: $str, selectedRange: $selectedRange, text: text)
              
        }
        .padding(.top, 60)
    }
}

struct TestTextView_Previews: PreviewProvider {
    static var previews: some View {
        TestTextView()
    }
}


struct TestTextUIView: UIViewRepresentable {
    
    @Binding var str: String
    @Binding var selectedRange: NSRange?
    let text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = true
        
       
        
       
        
        
        let gesture = UITapGestureRecognizer(target: context.coordinator,
                                                     action: #selector(Coordinator.handleTap))
        textView.addGestureRecognizer(gesture)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let attrStr = NSMutableAttributedString(string: text)
        
        if let selectedRange{
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(.red), range: selectedRange)
        }
     
        attrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(20), weight: .heavy), range: NSRange(location: 0, length: attrStr.length))
        
        uiView.attributedText = attrStr
    }
    
    func makeCoordinator() -> Coordinator {
         Coordinator(self)
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: TestTextUIView
     
        
        init(_ uiTextView: TestTextUIView) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            parent.str = "tap"
            return true
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            
            if let textView = sender.view as? UITextView{
                let textLength = textView.textStorage.length
                let point = sender.location(in: textView)
                let glyphIndex: Int? = textView.layoutManager.glyphIndex(for: point, in: textView.textContainer, fractionOfDistanceThroughGlyph: nil)
                let index: Int? = textView.layoutManager.characterIndexForGlyph(at: glyphIndex ?? 0)
                
               
                guard let characterIndex = index, characterIndex < textLength else {
                    return
                }
                
                parent.str = "\(textView.textStorage.length)"

                parent.selectedRange = Helpers.getParagraphRangeForLocation(characterIndex, textView.textStorage.string)
            }
        }
    }
}

