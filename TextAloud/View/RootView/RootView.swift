//
//  RootView.swift
//  TextAloud
//
//

import SwiftUI

struct RootView: View {
    @StateObject var rootVM = RootViewModel()
    @StateObject var synthesizer: SpeechSynthesizer = SpeechSynthesizer()
    @State var sheetState: SheetEnum?

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                customNavHeaderView
                speachTextViewComponet
                Spacer()
                if !rootVM.isFocused{
                    controlsSectionView
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .allFrame()
        .background(LinearGradient(gradient: Gradient(colors: [.deepOcean, .lightOcean]), startPoint: .top, endPoint: .bottom))
        .sheet(item: $sheetState) { type in
            switch type{
            case .settings:
                SettingsView()
            case .addFile:
                DocumentPicker(fileContent: $rootVM.text)
            }
        }
        .onChange(of: rootVM.selectedRange) { range in
            if let range{
                synthesizer.setSpeakForRange(rootVM.text, range)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

//MARK: - Controls Section view
extension RootView{
    private var controlsSectionView: some View{
        VStack(spacing: 32){
            HStack{
                ButtonView(buttonText: "Stop", buttonIcon: "stop.circle", isDisabled: !synthesizer.isPlay, action: synthesizer.stop)
                Spacer()
                ButtonView(buttonText: synthesizer.isPlay ? "Pause" : "Play", buttonIcon: synthesizer.isPlay ? "pause.circle" : "play.circle", isDisabled: rootVM.text.isEmpty){
                    if synthesizer.isPlay{
                        synthesizer.pause()
                    }else{
                        synthesizer.speak(rootVM.text)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var editTestButton: some View{
        Button {
            if synthesizer.isPlay{
                synthesizer.stop()
            }
            rootVM.isEditMode.toggle()
        } label: {
            Label {
                Text(rootVM.isFocused ? "Save" : "Edit")
            } icon: {
                Image(systemName: rootVM.isFocused ? "checkmark" : "highlighter")
            }
            .font(.title3.weight(.bold))
            .foregroundColor(.limeChalk)
        }
    }
    
    @ViewBuilder
    private var selectedMenuButton: some View{
        if !rootVM.isFocused{
            Menu {
                ForEach(SelectionEnum.allCases, id: \.self) { type in
                    Button(type.rawValue.capitalized){
                        rootVM.setSelectionMode(type)
                    }
                }
            } label: {
                Text(rootVM.currentSelectionMode.rawValue.capitalized)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.limeChalk)
            }
        }
    }
    
    @ViewBuilder
    private var rateMenuButton: some View{
        if !rootVM.isFocused{
            Menu {
                ForEach(SpeechRateEnum.allCases, id: \.self) { type in
                    Button(type.valueRepresentable){
                        synthesizer.updateRate(type)
                    }
                }
            } label: {
                Text(synthesizer.rateMode.valueRepresentable)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.limeChalk)
            }
        }
    }
}

//MARK: - Text Editor Section View
extension RootView{
    private var speachTextViewComponet: some View{
        VStack(spacing: 16) {
            SpeachTextViewComponent(currentWord: $synthesizer.currentWord, rootVM: rootVM)
            HStack {
                selectedMenuButton
                rateMenuButton
                    .hCenter()
                editTestButton
            }
        }
        .padding(.top, 32)
        .padding(.bottom, 16)
    }
}

//MARK: - Custom Navigation Header View
extension RootView{
    private var customNavHeaderView: some View{
        HStack(spacing: 16){
        
            Button {
                sheetState = .settings
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.limeChalk)
                    .font(.title)
            }
            
            Text("Text Aloud")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.heavy)
            
            Spacer()
            
            Group {
                if !rootVM.text.isEmpty{
                    Button {
                        if synthesizer.isPlay{
                            synthesizer.stop()
                        }
                        rootVM.removeText()
                    } label: {
                        Image(systemName: "trash.circle.fill")
                    }
                }
                Button {
                    if synthesizer.isPlay{
                        synthesizer.stop()
                    }
                    sheetState = .addFile
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .foregroundColor(.limeChalk)
            .font(.title)
        }
    }
    
    enum SheetEnum: Int16, Identifiable{
        var id: Int16 {self.rawValue}
        case settings, addFile
    }
}
