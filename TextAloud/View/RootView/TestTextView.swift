//
//  TestTextView.swift
//  TextAloud
//
//


//View for test

//import Foundation
//import SwiftUI
//
//struct TestTextView: View {
//    @State var text = "test test test test test test. test test test test test test test test test test test test. test test test test test test"
//    @State var addRange: NSRange?
//    @State var str: String = ""
//    @State var selectedRange: NSRange?
//    var body: some View {
//        VStack {
//            //if let range{
//            Text("\(selectedRange?.location ?? 0)")
//            Text("\(selectedRange?.length ?? 0)")
//           // }
//            Text(str)
//            TestTextUIView(str: $str, addRange: $addRange, selectedRange: $selectedRange, text: text)
//
//
//                Text(createSsml())
//
//
//            Button {
//                addRange = selectedRange
//            } label: {
//                Text("Add mark")
//            }
//
//        }
//        .padding(.top, 60)
//    }
//
//    private func createSsml() -> String{
//
//        var tempText = text
//
//        if let addRange{
//            //Start point
//            tempText.insert(string: "<p>", ind: addRange.location)
//
//
//            let lastLocation = (addRange.location) + addRange.length + 1
//
//            if tempText.length < lastLocation{
//                tempText.insert(.init("</p>"), at: tempText.endIndex)
//            }else{
//                tempText.insert(string: "</p>", ind: lastLocation)
//            }
//        }
//
//        return tempText
//    }
//}
//
//struct TestTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestTextView()
//    }
//}
//
//
//struct TestTextUIView: UIViewRepresentable {
//
//    @Binding var str: String
//    @Binding var addRange: NSRange?
//    @Binding var selectedRange: NSRange?
//    let text: String
//
//    func makeUIView(context: Context) -> UITextView {
//        let textView = UITextView()
//        textView.delegate = context.coordinator
//        textView.isEditable = true
//        textView.isSelectable = true
//        textView.isUserInteractionEnabled = true
//
//
//
//
//
////
////        let gesture = UITapGestureRecognizer(target: context.coordinator,
////                                                     action: #selector(Coordinator.handleTap))
////        textView.addGestureRecognizer(gesture)
//
//        return textView
//    }
//
//    func updateUIView(_ uiView: UITextView, context: Context) {
//        let attrStr = NSMutableAttributedString(string: text)
//
//        if let addRange, addRange.length > 0{
//
//            attrStr.insert(.init(string: "S"), at: addRange.location)
//
//            let lastLocation = (addRange.location) + addRange.length + 1
//
//            if uiView.textStorage.string.length < lastLocation{
//                attrStr.append(.init(string: "T"))
//            }else{
//                attrStr.insert(.init(string: "T"), at: lastLocation)
//            }
//
//
//
//            //attrStr.insert(.init(string: "End"), at: addRange.l - 1)
//           // attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(.red), range: .init(location: addRange.location - 1, length: 1))
//        }
//
//
//        attrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(20), weight: .heavy), range: NSRange(location: 0, length: attrStr.length))
//
//        uiView.attributedText = attrStr
//    }
//
//    func makeCoordinator() -> Coordinator {
//         Coordinator(self)
//    }
//
//    class Coordinator : NSObject, UITextViewDelegate {
//
//        var parent: TestTextUIView
//
//
//        init(_ uiTextView: TestTextUIView) {
//            self.parent = uiTextView
//        }
//
//
//
////        @objc func handleTap(_ sender: UITapGestureRecognizer) {
////
////            if let textView = sender.view as? UITextView{
////                let textLength = textView.textStorage.length
////                let point = sender.location(in: textView)
////                let glyphIndex: Int? = textView.layoutManager.glyphIndex(for: point, in: textView.textContainer, fractionOfDistanceThroughGlyph: nil)
////                let index: Int? = textView.layoutManager.characterIndexForGlyph(at: glyphIndex ?? 0)
////
////
////                guard let characterIndex = index, characterIndex < textLength else {
////                    return
////                }
////
////                parent.str = "\(textView.textStorage.length)"
////
////                parent.selectedRange = Helpers.getParagraphRangeForLocation(characterIndex, textView.textStorage.string)
////            }
////        }
//
//
//        func textViewDidChangeSelection(_ textView: UITextView) {
//            parent.selectedRange = textView.selectedRange
//        }
//
//    }
//}
//
//struct RedactedTextModel{
//    var selectedRange: NSRange?
//    var type: MarkType
//    var selectedText: String
//
//
//    enum MarkType{
//        case emphasis, timeBreak
//    }
//}
//
//
//extension String {
//    mutating func insert(string:String,ind:Int) {
//        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
//    }
//}
