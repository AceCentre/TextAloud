//
//  RootView.swift
//  TextAloud
//
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var audioManager = AudioPlayerManager()
    @StateObject var settingsVM = SettingViewModel()
    @StateObject var rootVM = RootViewModel()
    @StateObject var storeKitManager = StoreKitManager()
    @StateObject var synthesizer: SpeechSynthesizer = SpeechSynthesizer()
    @State var showSetting: Bool = false
    @State var showFileImporter: Bool = false
    @State var showLanguageSheet: Bool = false
    @State var showUpgradeModal: Bool = false
    var body: some View {
      
        ZStack {
            VStack(spacing: 0){
                customNavHeaderView
                speachTextViewComponet
                Spacer()
                if !rootVM.isFocused{
                    controlsSectionView
                }
                Spacer()
            }
            .padding(.horizontal)
            loaderView
        }
        .background(LinearGradient(gradient: Gradient(colors: [.deepOcean, .lightOcean]), startPoint: .top, endPoint: .bottom))
        .onChange(of: rootVM.tappedRange) { range in
            if let range{
                rootVM.selectedRange = nil
                synthesizer.setSpeakForRange(rootVM.text, range, mode: .tapped, completion: {duration in
                    settingsVM.trackSecondsUsed(secondsUsed: duration)
                })
            }
        }
        .onChange(of: rootVM.text) { _ in
            rootVM.isChangeText = true
        }
        .onChange(of: scenePhase) { phase in
            switch phase{
            case .active:
                if !rootVM.setShareObjectIfNeeded(){
                    if let text = synthesizer.getSpeechData(){
                        rootVM.text = text
                    }
                }
            case .background, .inactive:
                synthesizer.saveSpeechData(rootVM.text)
            default: break
            }
        }
        .sheet(isPresented: $showUpgradeModal) {
            InAppPurchaseSheet(onPurchaseClick: {
                Task {
                    let _ = try await storeKitManager.purchase(storeKitManager.unlimitedVoiceAllowance)
                    showUpgradeModal = false
                }
            })
        }
        .sheet(isPresented: $showSetting){
            SettingsView(speech: synthesizer, settingVM: settingsVM, storeKitManager: storeKitManager, onPurchaseClick: {
                showSetting = false
                showUpgradeModal = true
            })
        }
        .sheet(isPresented: $showLanguageSheet){
            NavigationView {
                LanguageSpeechView(isSheetView: true)
                    .environmentObject(synthesizer)
                    .environmentObject(settingsVM)
            }
        }
        .sheet(isPresented: $storeKitManager.sayThankYou, onDismiss: {
            storeKitManager.thankYouAcknowledged = true
            print("Dismissed")
        }) {
            ThankYouSheet {
                storeKitManager.sayThankYou = false
                storeKitManager.thankYouAcknowledged = true
                print("Closed")
            }
        }
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.pdf, .rtf, .text, .content], allowsMultipleSelection: false, onCompletion: rootVM.onDocumentPick)
        .handle(error: $rootVM.error)
        .alert(Localization.offlineAlertTitle.toString, isPresented: $synthesizer.showOfflineAlert, actions: offlineAlertButton, message: offlineAlertMessage)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            RootView()
                .environment(\.locale, .init(identifier: "en"))
            //            RootView()
            //                .environment(\.locale, .init(identifier: "fr"))
            //            RootView()
            //                .environment(\.locale, .init(identifier: "zh_Hant_HK"))
            //            RootView()
            //                .environment(\.locale, .init(identifier: "de"))
            //            RootView()
            //                .environment(\.locale, .init(identifier: "es"))
        }
    }
}

//MARK: - Controls Section view
extension RootView{
    @ViewBuilder
    private var controlsSectionView: some View{
        CircleControlButtonView(isPlay: isPlay, isDisabled: rootVM.text.isEmpty){
            
            let overAllowance = settingsVM.allowanceLeft() <= 0
            // let overAllowance = true
            let payingUser = storeKitManager.hasPurchasedUnlimitedVoiceAllowance == true
            
            if overAllowance && !payingUser {
                showUpgradeModal = true
                
                print("You've hit the limit! And you've not paid, lets show a modal")
                return
            } else if overAllowance && payingUser {
                print("You are over the limit, but you've paid so its all good")
            } else if payingUser {
                print("You've paid but you still have time left so its all good")
            } else {
                print("You haven't paid, but you still have time left, so its all good")
            }
            
            
            if synthesizer.isActiveCashAudio && rootVM.currentSelectionMode == .all, let audio = synthesizer.savedAudio{
                audioManager.audioAction(audio)
            }else{
                let location = synthesizer.currentWord?.nextLocation ?? 3
                let range = rootVM.setSelectedRangeForMode(with: location < rootVM.text.length ? location : 0)
                
                synthesizer.setSpeakForRange(rootVM.text, range, mode: rootVM.currentSelectionMode.playMode, completion: { duration in
                    settingsVM.trackSecondsUsed(secondsUsed: duration)
                })
            }
        }
        .hCenter()
        .overlay {
            HStack{
                if let voice = settingsVM.activeVoiceModel{
                    Button {
                        if settingsVM.selectedVoices.count == 2{
                            settingsVM.toggleVoice()
                        }else{
                            showLanguageSheet.toggle()
                        }
                        
                    } label: {
                        IconView(title: voice.languageCode.shortLocaleLanguage, subtitle: voice.representableName, icon: "globe.europe.africa.fill")
                    }
                }
                
                Spacer()
                if synthesizer.isActiveCashAudio{
                    Menu {
                        Button(role: .destructive) {
                            synthesizer.removeAudio()
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                        
                        Button {
                            if let audioUrl = synthesizer.savedAudio?.url{
                                Helpers.showShareSheet(data: audioUrl)
                            }
                        } label: {
                            Label("Share", systemImage: "arrowshape.turn.up.right.fill")
                        }
                    } label: {
                        IconView(title: "Audio", icon: "waveform.circle.fill")
                    }
                }
            }
        }
    }
    
    private var isPlay: Bool{
        (synthesizer.isActiveCashAudio && rootVM.currentSelectionMode == .all) ?
        audioManager.isPlaying : synthesizer.isPlay
    }
    
    @ViewBuilder
    private var editButton: some View{
        TextButtonView(title: rootVM.isFocused ? Localization.save.toString : Localization.edit.toString, image: rootVM.isFocused ? "checkmark" : "highlighter", isDisabled: rootVM.isDisabledSaveButton) {
            
            rootVM.onTappedEditSaveButton()
            ///save action
            if rootVM.isFocused{
                if synthesizer.isPlay{
                    synthesizer.stop()
                }
                synthesizer.removeAudio()
                synthesizer.saveSpeechData(rootVM.text)
            }
        }
    }
    
    
    @ViewBuilder
    private var cancelButton: some View{
        if rootVM.isFocused{
            TextButtonView(title: Localization.cancel.toString, image: "xmark", isDisabled: false) {
                rootVM.onCancelTapped()
            }
        }
    }
    
    
    @ViewBuilder
    private var selectedMenuButton: some View{
        if !rootVM.isFocused{
            Menu {
                ForEach(SelectionEnum.allCases, id: \.self) { type in
                    Button(type.locale){
                        rootVM.setSelectionMode(type)
                    }
                    .keyboardShortcut(type.keyboardShortcutValue)
                    /// 1, 2 , 3
                }
            } label: {
                Text(rootVM.currentSelectionMode.locale)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.limeChalk)
                    .frame(width: 120, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    private var rateMenuButton: some View{
        if !rootVM.isFocused && !synthesizer.isAzureSpeech{
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
            SpeachTextViewComponent(currentWord: audioManager.isSetAudio ? $audioManager.currentRange : $synthesizer.currentWord, rootVM: rootVM)
            
            editButton
                .hTrailing()
                .overlay(alignment: .leading){
                    cancelButton
                    selectedMenuButton
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
                showSetting.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.limeChalk)
                    .font(.title)
            }
            
            Text("TextAloud")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.heavy)
            
            Spacer()
            
            Group {
                if !rootVM.text.isEmpty{
                    Button {
                        if synthesizer.isPlay{
                            synthesizer.stop()
                        }else if audioManager.isPlaying{
                            audioManager.stopAudio()
                        }
                        synthesizer.currentWord = nil
                        rootVM.removeText()
                        synthesizer.removeAudio()
                    } label: {
                        Image(systemName: "trash.circle.fill")
                    }
                }
                Button {
                    if synthesizer.isPlay{
                        synthesizer.stop()
                    }else if audioManager.isPlaying{
                        audioManager.stopAudio()
                    }
                    synthesizer.currentWord = nil
                    showFileImporter.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .foregroundColor(.limeChalk)
            .font(.title)
        }
    }
}

extension RootView{
    
    @ViewBuilder
    private var loaderView: some View{
        if rootVM.showLoader{
            ZStack{
                Color.deepOcean.opacity(0.1).ignoresSafeArea()
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .shadow(color: .black.opacity(0.1), radius: 5)
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.deepOcean)
                }
            }
        }
    }
    
}

//MARK: - Offline alert
extension RootView{
    private func offlineAlertMessage() -> some View{
        Text(Localization.offlineAlertMessage.toString)
    }
    
    private func offlineAlertButton() -> some View{
        Button(Localization.selectVoices.toString) {
            showLanguageSheet.toggle()
        }
    }
}
