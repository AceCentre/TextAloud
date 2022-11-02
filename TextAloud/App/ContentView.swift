//
//  ContentView.swift
//  TextAloud
//
//  Created by Will Wade on 26.10.2022.
//

import SwiftUI
import AVFoundation
import Foundation
import Combine

struct ContentView: View {
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @StateObject var synthesizer: SpeechSynthesizer = SpeechSynthesizer()
    @State var text: NSAttributedString = NSAttributedString("")
    @State var testTExt: String = ""
    @State var cursorPosition: NSRange?
    @State var newCursorPosition: NSRange?
    @State var showDocumentPicker = false
    @State var isShowingSettings = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            NavigationView{
                GeometryReader { _ in
                    VStack(spacing: 10) {
                        ZStack {
                            TextView(text: $text, cursorPosition: $cursorPosition, newCursorPosition: $newCursorPosition, synth: synthesizer)
                                .frame(minHeight: 200, maxHeight: .infinity)
                                .focused($isFocused)
                        }
                        
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
                        .padding()
                        .KeyboardAwarePadding()
                        
                        Spacer()
                        
                        HStack{
                            ButtonView(buttonText: "Paragraph", buttonIcon: "", withIcon: false, action: {
                                if cursorPosition != nil {
                                    let range = getCurrentParagraph()
                                    newCursorPosition = NSRange(location: range.0 + range.1 == text.string.length ? range.0 + range.1 : range.0 + range.1 + 1, length: 0)
                                    synthesizer.speak(text.string, range: range)
                                    cursorPosition = newCursorPosition
                                }
                            })
                            .keyboardShortcut("3", modifiers: .control)
                            Spacer()
                            ButtonView(buttonText: "Word", buttonIcon: "", withIcon: false, action: {
                                if cursorPosition != nil {
                                    let range = getCurrentWord()
                                    newCursorPosition = NSRange(location: range.0 + range.1 == text.string.length ? range.0 + range.1 : range.0 + range.1 + 1, length: 0)
                                    synthesizer.speak(text.string, range: range)
                                    cursorPosition = newCursorPosition
                                }
                            })
                            .keyboardShortcut("1", modifiers: .control)
                            Spacer()
                            ButtonView(buttonText: "Sentence", buttonIcon: "", withIcon: false, action: {
                                if cursorPosition != nil {
                                    let range = getCurrentSentence()
                                    newCursorPosition = NSRange(location: range.0 + range.1 == text.string.length ? range.0 + range.1 : range.0 + range.1 + 1, length: 0)
                                    synthesizer.speak(text.string, range: range)
                                    cursorPosition = newCursorPosition
                                }
                            })
                            .keyboardShortcut("2", modifiers: .control)
                        }
                        .padding()
                        
                        HStack{
                            ButtonView(buttonText: "Stop", buttonIcon: "stop.circle", withIcon: true, action: {
                                synthesizer.stop()
                            })
                            .keyboardShortcut(.escape)
                            Spacer()
                            ButtonView(buttonText: "Play all", buttonIcon: "", withIcon: false, action: {
                                synthesizer.speak(text.string)
                            })
                        }
                        .padding()
                    }
                    .navigationBarItems(
                        leading:
                            HStack {
                                Button(action: {
                                    isShowingSettings = true
                                }) {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(Color("Lime Chalk"))
                                }
                                .sheet(isPresented: $isShowingSettings) {
                                    SettingsView()
                                }
                                Text("Text Aloud")
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                            },
                        trailing:
                            HStack {
                                Button(action: {
                                    cursorPosition = nil
                                    text = NSAttributedString(string: "")
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(Color("Lime Chalk"))
                                }
                                
                                Button(action: { showDocumentPicker = true }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color("Lime Chalk"))
                                }
                            }
                    )
                    .padding(.top, 20)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Deep Ocean"), Color("Light Ocean")]), startPoint: .top, endPoint: .bottom))
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationViewStyle(.stack)
        }
        .sheet(isPresented: self.$showDocumentPicker) {
            DocumentPicker(fileContent: $text)
        }
    }
    
    func getCurrentWord() -> (Int, Int) {
        var startIndex = 0, endIndex = 0
        if cursorPosition!.location == text.string.length {
            endIndex = text.string.length
            for i in (0...cursorPosition!.location).reversed() {
                if isInCharacterSer(text.string[i], CharacterSet.whitespaces) || i == 0 {
                    startIndex = i
                    break
                }
            }
        } else if cursorPosition!.location == 0 {
            startIndex = 0
            for i in 0...text.string.length {
                if isInCharacterSer(text.string[i], CharacterSet.whitespaces) || i == text.string.length {
                    endIndex = i
                    break
                }
            }
        } else {
            for i in cursorPosition!.location...text.string.length {
                if isInCharacterSer(text.string[i], CharacterSet.whitespacesAndNewlines) || i == text.string.length {
                    endIndex = i
                    break
                }
            }
            for i in (0...cursorPosition!.location-1).reversed() {
                if isInCharacterSer(text.string[i], CharacterSet.whitespacesAndNewlines) || i == 0{
                    startIndex = i
                    break
                }
            }
        }
        return (startIndex, endIndex - startIndex)
    }
    
    func getCurrentParagraph() -> (Int, Int) {
        var startIndex = 0, endIndex = 0
        if cursorPosition!.location == text.string.length && cursorPosition!.location - 1 >= 0 {
            endIndex = text.string.length
            for i in (0...(cursorPosition!.location - 1)).reversed() {
                if isInCharacterSer(text.string[i], CharacterSet.newlines) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        } else if cursorPosition!.location == 0 {
            startIndex = 0
            for i in 0...text.string.length {
                if isInCharacterSer(text.string[i], CharacterSet.newlines) || i == text.string.length {
                    endIndex = i
                    break
                }
            }
        } else {
            for i in cursorPosition!.location...text.string.length {
                if isInCharacterSer(text.string[i], CharacterSet.newlines) || i == text.string.length {
                    endIndex = i
                    break
                }
            }
            for i in (0...cursorPosition!.location-1).reversed() {
                if isInCharacterSer(text.string[i], CharacterSet.newlines) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        }
        return (startIndex, endIndex - startIndex)
    }
    
    func getCurrentSentence() -> (Int, Int) {
        var startIndex = 0, endIndex = 0
        if cursorPosition!.location == text.string.length && cursorPosition!.location - 2 >= 0 {
            endIndex = text.string.length
            for i in (0...(cursorPosition!.location - 2)).reversed() {
                if isEndOfSentence(text.string[i]) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        } else if cursorPosition!.location == 0 {
            startIndex = 0
            for i in 0...text.string.length - 1 {
                if isEndOfSentence(text.string[i]) || i == text.string.length - 1 {
                    endIndex = i + 1
                    break
                }
            }
        } else {
            for i in cursorPosition!.location...text.string.length - 1 {
                if isEndOfSentence(text.string[i]) || i == text.string.length - 1 || isInCharacterSer(text.string[i], CharacterSet.newlines) {
                    endIndex = i + 1
                    break
                }
            }
            for i in (0...cursorPosition!.location-1).reversed() {
                if isEndOfSentence(text.string[i]) || i == 0 || isInCharacterSer(text.string[i], CharacterSet.newlines){
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        }
        return (startIndex, endIndex - startIndex)
    }
    
    func currentWordShortcut() {
        if cursorPosition != nil {
            let range = getCurrentWord()
            newCursorPosition = NSRange(location: range.0 + range.1 == text.string.length ? range.0 + range.1 : range.0 + range.1 + 1, length: 0)
            synthesizer.speak(text.string, range: range)
            cursorPosition = newCursorPosition
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
