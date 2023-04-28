//
//  RootView.swift
//  TextAloud
//
//

import SwiftUI
import TextAloudKit

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var settings: RootSettings
    
    @StateObject var audioManager = AudioPlayerManager()
    @StateObject var settingsVM = SettingViewModel()
    @StateObject var rootVM = RootViewModel()
    @StateObject var storeKitManager = StoreKitManager()
    @StateObject var synthesizer: SpeechSynthesizer = SpeechSynthesizer()
    @StateObject var networkManager = NetworkMonitorManager()
    @State var showSetting: Bool = false
    @State var showFileImporter: Bool = false
    @State var showLanguageSheet: Bool = false
    @State var showUpgradeModal: Bool = false
    
    @State var activityItemsToShare: ActivityItems?
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0){
                customNavHeaderView
                speachTextViewComponet
            }
            .padding(.horizontal)
            loaderView
        }
        .onAppear() {
            storeKitManager.isTextAloudPro = settings.isTextAloudPro
            storeKitManager.setup()
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
        .sheet(item: $activityItemsToShare) { shareItem in
            ActivityView(activityItems: shareItem.activityItems)
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
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.pdf, .rtf, .text], allowsMultipleSelection: false, onCompletion: rootVM.onDocumentPick)
        .handle(error: $rootVM.error)
        .alert(
            "No Internet Connection",
            isPresented: $networkManager.presentOfflineNotification,
            actions: {
                Button(Localization.selectVoices.toString) {
                    showLanguageSheet.toggle()
                }
                Button("Ignore") {
                    networkManager.presentExpensiveNotification = false
                }
            },            message: offlineAlertMessage
        )
        .alert(
            "Using Mobile Data",
            isPresented: $networkManager.presentExpensiveNotification,
            actions: {
                Button(Localization.selectVoices.toString) {
                    showLanguageSheet.toggle()
                }
                Button("Ignore") {
                    networkManager.presentExpensiveNotification = false
                }
            },
            message: expensiveAlertMessage
        )
        .onOpenURL { url in
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            if let unwrappedHost = url.host {
                if unwrappedHost == "insertText" {
                    let text = components?.queryItems?.filter({ $0.name == "text" }).first
                    
                    if let unwrappeQuery = text, let unwrappedText = unwrappeQuery.value {
                        rootVM.text = unwrappedText
                        
                        if let decoded = Data(base64Encoded: unwrappedText) {
                            rootVM.text = String(data: decoded, encoding: .utf8) ?? "Error sharing text"
                        }
                    }
                } else {
                    print("You called an unsupported host")
                }
            } else {
                print("Couldn't unwrap host")
            }
            
          
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            RootView()
                .environment(\.locale, .init(identifier: "en"))
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

extension RootView {
    @ViewBuilder
    private var globeLanguageSwitcher: some View {
        if let voice = settingsVM.activeVoiceModel{
            Button {
                if settingsVM.selectedVoices.count == 2{
                    settingsVM.toggleVoice()
                }else{
                    showLanguageSheet.toggle()
                }
                
            } label: {
                IconWithTitle(title: voice.languageCode.shortLocaleLanguage, subtitle: voice.representableName, icon: "globe.europe.africa.fill")
            }
        }
    }
}

//MARK: - Controls Section view
extension RootView{
    @ViewBuilder
    private var controlsSectionView: some View{
        PlayPauseButton(isPlay: isPlay, isDisabled: rootVM.text.isEmpty){
            
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
            } else {
                let location = synthesizer.currentWord?.nextLocation ?? 3

                var range = rootVM.setSelectedRangeForMode(with: location < rootVM.text.count ? location : 0)
                
                if let cursorPos = rootVM.cursorPos, rootVM.isEditMode {
                    range = rootVM.setSelectedRangeForMode(with: cursorPos < rootVM.text.count ? cursorPos : rootVM.text.count - 1)
                }
                
                
                synthesizer.setSpeakForRange(rootVM.text, range, textSelectionMode: rootVM.currentSelectionMode, completion: { duration in
                    settingsVM.trackSecondsUsed(secondsUsed: duration)
                })
            }
        }
        
    }
    
    @ViewBuilder
    private var cacheView: some View {
        if synthesizer.isActiveCashAudio && !rootVM.isFocused {
            Menu {
                Button(role: .destructive) {
                    synthesizer.removeAudio()
                } label: {
                    Label("Remove", systemImage: "trash")
                }
                
                Button {
                    if let audioUrl = synthesizer.savedAudio?.url{
                        activityItemsToShare = ActivityItems([audioUrl])
                    }
                } label: {
                    Label("Share", systemImage: "arrowshape.turn.up.right.fill")
                }
            } label: {
                IconWithTitle(title: "Audio", icon: "waveform.circle.fill")
            }
        }
    }
    
    private var isPlay: Bool{
        (synthesizer.isActiveCashAudio && rootVM.currentSelectionMode == .all) ?
        audioManager.isPlaying : synthesizer.isPlay
    }
    
    @ViewBuilder
    private var fullWidthSpacer: some View {
        Spacer().frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var fullHeightSpacer: some View {
        Spacer().frame(maxHeight: .infinity)
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
            }.hLeading()
        }
    }
    
    
    @ViewBuilder
    private var selectedMenuButton: some View{
        if !rootVM.isFocused{
            Menu {
                ForEach(TextSelectionEnum.allCases, id: \.self) { type in
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
                    .frame(width: 120, alignment: .center)
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
                .padding(.top, 32)
                        
            HStack {
                HStack {
                    VStack {
                        if !rootVM.isFocused {
                            selectedMenuButton
                            globeLanguageSwitcher
                        } else {
                            cancelButton
                        }
                    }
                    fullWidthSpacer
                }.frame(maxWidth: .infinity)
                
                controlsSectionView.frame(maxWidth: .infinity)
                
                HStack {
                        fullWidthSpacer
                        VStack {
                            editButton.padding(.bottom, synthesizer.isActiveCashAudio || rootVM.isFocused ? 0 : 80)
                            cacheView
                        }
                    
                }.frame(maxWidth: .infinity)
            }
            
        }.padding(.bottom)
        
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
            
            Text("TextAloud Pro")
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

//MARK: - Offline alert
extension RootView{
    private func offlineAlertMessage() -> some View {
        Text("Please switch to an offline voice to continue using TextAloud.")
    }
    
    private func expensiveAlertMessage() -> some View {
        Text("TextAloud will use your mobile data allowance. Switch to Wifi or switch to an offline voice.")
    }
}
