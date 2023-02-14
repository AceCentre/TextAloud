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
    @State private var isFocused: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 32){
                customNavHeaderView
                speachTextViewComponet
                Spacer()
                if !isFocused{
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
            Slider(value: $synthesizer.rate, in: synthesizer.rangeRate) { isEdit in
                guard !isEdit else {return}
                synthesizer.updateRate()
            }
            .tint(.limeChalk)
            
            HStack{
                ButtonView(buttonText: "Stop", buttonIcon: "stop.circle", action: {synthesizer.stop()})
                Spacer()
                ButtonView(buttonText: synthesizer.isPlay ? "Pause" : "Play", buttonIcon: synthesizer.isPlay ? "pause.circle" : "play.circle"){
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
            rootVM.isEditMode.toggle()
        } label: {
            Label {
                Text(isFocused ? "Save" : "Edit")
            } icon: {
                Image(systemName: "highlighter")
            }
            .font(.title3.weight(.bold))
            .foregroundColor(.limeChalk)
        }
    }
}

//MARK: - Text Editor Section View
extension RootView{
    private var speachTextViewComponet: some View{
        VStack(spacing: 16) {
            SpeachTextViewComponent(currentWord: $synthesizer.currentWord, isEditing: $rootVM.isEditMode, text: $rootVM.text, focused: $isFocused)
            editTestButton
                .hTrailing()
        }
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
                
                Button {
                    rootVM.removeText()
                } label: {
                    Image(systemName: "trash.circle.fill")
                }
                
                Button {
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

