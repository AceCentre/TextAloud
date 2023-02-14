//
//  SettingsView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 30.10.2022.
//

import SwiftUI
import UIKit



struct SettingsView: View {
    @AppStorage("selectedColor") var selectedColor: Color = Color(UIColor(red: 0.96, green: 0.9, blue: 0.258, alpha: 0.4))
    @AppStorage("readingColor") var readingColor: Color = Color.red
    @AppStorage("fontSize") var fontSize: Int = 25
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [:]
        navBarAppearance.titleTextAttributes = [:]
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    GroupBox(label: SettingsLabelView(labelText: "Text Aloud", labelImage: "info.circle")) {
                        Divider().padding(.vertical, 4)
                        Text("The Text Aloud application makes it easy to read any text that you write yourself, or import. Note to change voice settings go to Settings -> Accessibility -> Spoken Content -> Voices")
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                    }
                    GroupBox(label: SettingsLabelView(labelText: "customization", labelImage: "paintbrush")) {
                        Divider().padding(.vertical, 4)
                        Text("In this section, you can customize the appearance of the application. Choose a font size that is convenient for you, highlight and selection color")
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        Divider().padding(.vertical, 4)
                        VStack {
                            Text("Here's what the text will look like:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text(getNewString())
                                    .font(.system(size: CGFloat(fontSize)))
                                    .fontWeight(.heavy)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.white)
                            .cornerRadius(8)
                            .padding()
                        }
                        Divider().padding(.vertical, 4)
                        ColorPicker("Pick selection color", selection: $selectedColor, supportsOpacity: true)
                            .fontWeight(.medium)
                        Divider().padding(.vertical, 4)
                        ColorPicker("Pick word highlight color", selection: $readingColor, supportsOpacity: true)
                            .fontWeight(.medium)
                        Divider().padding(.vertical, 4)
                        Stepper {
                            HStack {
                                Text("Font size")
                                Spacer()
                                Text("\(fontSize)")
                            }
                        } onIncrement: {
                            incrementStep()
                        } onDecrement: {
                            decrementStep()
                        }
                        .fontWeight(.medium)
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .large)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
            )
            .padding()
        }
    }
    
    func incrementStep() {
        fontSize += 1
    }

    func decrementStep() {
        fontSize -= 1
    }
    
    func getNewString() -> AttributedString {
        var temp = AttributedString("Hello, World! How are you?")
        let rangeSelected = temp.range(of: "World")!
        let rangeReading = temp.range(of: "How")!
        temp.foregroundColor = .black
        temp[rangeSelected].backgroundColor = selectedColor
        temp[rangeReading].foregroundColor = readingColor
        return temp
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
