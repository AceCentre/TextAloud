//
//  SettingsView.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 30.10.2022.
//

import SwiftUI
import YouTubePlayerKit
import TextAloudKit

struct SettingsLink<Content: View>: View {
    var label: String
    var pageLink: String?
    @ViewBuilder var content: Content
    
    var body: some View {
        if let url = pageLink, let fullUrl = URL(string: url) {
            
            
            Link(destination: fullUrl) {
                HStack{
                    Text(label)
                        .font(.callout.weight(.medium))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            } } else {
                
                NavigationLink {
                    content
                } label: {
                    Text(label)
                        .font(.callout.weight(.medium))
                    Spacer()
                    Image(systemName: "chevron.right")
                }}
    }
}

struct YoutubeVideo: View {
    var title: String
    var description: String
    var videoURL: String
    
    var body: some View {
        Section{
            
            
            VStack(alignment: .leading) {
                Text(title).font(.title)
                Text(description).font(.caption)
                GeometryReader { reader in
                    
                    YouTubePlayerView(
                        YouTubePlayer(
                            source: YouTubePlayer.Source.url(videoURL),
                            configuration: .init(useModestBranding:true)
                        ),
                        placeholderOverlay: {
                            ProgressView()
                        }
                    )
                    .frame(width: reader.size.width, height: reader.size.width / 16 * 9)
                }.aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
            }.padding(.vertical)
        }
    }
}

struct SettingsView: View {
    @ObservedObject var speech: SpeechSynthesizer
    @ObservedObject var settingVM: SettingViewModel
    @ObservedObject var storeKitManager: StoreKitManager
    var onPurchaseClick: () -> ()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group{
            if #available(iOS 16.0, *) {
                NavigationStack{
                    viewContainer
                }
            } else {
                NavigationView{
                    viewContainer
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test").sheet(isPresented: .constant(true)) {
            SettingsView(speech: SpeechSynthesizer(), settingVM: SettingViewModel(), storeKitManager: StoreKitManager(), onPurchaseClick: {})
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}



//MARK: - Setting view container
extension SettingsView{
    
    private var viewContainer: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Group{
                    GroupBox {
                        SettingsLink(label: "Voice Selection") {
                            LanguageSpeechView()
                                .environmentObject(speech)
                                .environmentObject(settingVM)
                        }
                        Divider().padding(.vertical, 4)
                        SettingsLink(label: "Voice Usage Stats") {
                            voiceAllowanceView
                        }
                        Divider().padding(.vertical, 4)
                        SettingsLink(label: "Text Display Customisation") {
                            customizationGroupView
                        }
                        Divider().padding(.vertical, 4)

                        SettingsLink(label: "Help Videos") {
                            videosList
                        }
                    }
                }
                Spacer().padding(.vertical, 2)
                
                Group {
                    GroupBox {
                        
                        SettingsLink(label:"Documentation", pageLink: "https://docs.acecentre.org.uk/products/v/textaloud/") {}
                        Divider().padding(.vertical, 4)
                        SettingsLink(label:"Find out more about Ace Centre", pageLink: "https://acecentre.org.uk") {}
                        Divider().padding(.vertical, 4)
                        SettingsLink(label:"Contact Us", pageLink: "https://acecentre.org.uk/contact") {}
                        Divider().padding(.vertical, 4)
                        SettingsLink(label:"Recieve our Newsletter", pageLink: "https://acecentre.org.uk/?newsletter=textaloud") {}
                    }
                    Spacer().padding(.vertical, 2)
}
                
                Group {
                    GroupBox {
                        HStack{
                            Text("Version")
                                .font(.callout.weight(.medium))
                            Spacer()
                            Text(Bundle.main.appVersionShort)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }.padding(.horizontal)
            
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Localization.settings.toString)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

extension SettingsView {
    var timeUsedInMinutesLabel: String {
        let measurment = Measurement(value: settingVM.timeUsedInSeconds.rounded(), unit: UnitDuration.seconds)
        let formatter = MeasurementFormatter()
        
        formatter.unitStyle = .long
        formatter.unitOptions = .naturalScale
        
        return formatter.string(from: measurment)
    }
    
    var timeLeftInMinutesLabel: String {
        
        if storeKitManager.hasPurchasedUnlimitedVoiceAllowance == true {
            return "Unlimited"
        }
        
        let timeLeftInSeconds = settingVM.timeCapInSeconds - settingVM.timeUsedInSeconds
        let measurment = Measurement(value: timeLeftInSeconds.rounded(), unit: UnitDuration.seconds)
        let formatter = MeasurementFormatter()
        
        formatter.unitStyle = .long
        formatter.unitOptions = .naturalScale
        
        
        
        return formatter.string(from: measurment)
    }
    
    private var videosList: some View {
        List {
            
            
            YoutubeVideo(
                title: "App Tour",
                description: "A tour of all the features in TextAloud",
                videoURL: "https://www.youtube.com/watch?v=692w57FaGgQ"
            )
            YoutubeVideo(
                title: "Switching Voices",
                description: "How to switch voices and languages",
                videoURL: "https://www.youtube.com/watch?v=pVjykJ9PEOE"
            )
            YoutubeVideo(
                title: "Importing Files",
                description: "How to import documents into text aloud",
                videoURL: "https://www.youtube.com/watch?v=t9-YGbD2fmE"
            )
            YoutubeVideo(
                title: "Keyboard Access",
                description: "How to use TextAloud with a keyboard",
                videoURL: "https://www.youtube.com/watch?v=hMKcAZVX_K0"
            )
            YoutubeVideo(
                title: "Switch Access",
                description: "How to use TextAloud with a switch",
                videoURL: "https://www.youtube.com/watch?v=D8jP3dbSxK4"
            )
            YoutubeVideo(
                title: "Unlimited Time Usage",
                description: "How to use purchase unlimited usage of TextAloud",
                videoURL: "https://www.youtube.com/watch?v=ncxU0ZOoKXw"
            )
        }
        
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Help Videos")
    }
    
    private var voiceAllowanceView: some View {
        VStack{
            Group{
                GroupBox {
                    HStack{
                        Text("Used")
                            .font(.callout.weight(.medium))
                        Spacer()
                        Text(timeUsedInMinutesLabel)
                            .foregroundColor(.secondary)
                    }
                    Divider().padding(.vertical, 4)
                    HStack{
                        Text("Left")
                            .font(.callout.weight(.medium))
                        Spacer()
                        Text(timeLeftInMinutesLabel)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            if storeKitManager.hasPurchasedUnlimitedVoiceAllowance == false {
                Button(action: {
                    onPurchaseClick()
                }) {
                    Text("Purchase Unlimited Time")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .padding(10)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .buttonBorderShape(.capsule)
                .padding(.top)
            }
            Spacer().frame(maxHeight: .infinity)
        }.padding(.horizontal)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Voice Allowance")
    }
}


//MARK: - View components
extension SettingsView{
    private var aboutGroupView: some View{
        GroupBox(label: SettingsLabelView(labelText: "TextAloud", labelImage: "info.circle")) {
            Divider().padding(.vertical, 4)
            Text("aboutTextAloud \("TextAloud")")
                .padding(.vertical, 8)
                .font(.footnote)
                .multilineTextAlignment(.leading)
            Divider().padding(.vertical, 4)
            languageLink
        }
    }
    
    private var customizationGroupView: some View{
        VStack {
            GroupBox() {
                Text(Localization.aboutCustomization.toString)
                    .fixedSize(horizontal: false, vertical: true)
                Divider().padding(.vertical, 4)
                
                
                Group{
                    ColorPicker(Localization.pickSelection.toString, selection: $settingVM.selectedColor, supportsOpacity: true)
                    
                    Divider().padding(.vertical, 4)
                    
                    ColorPicker(Localization.pickHighlight.toString, selection: $settingVM.readingColor, supportsOpacity: true)
                    
                    Divider().padding(.vertical, 4)
                    
                    Stepper {
                        HStack {
                            Text(Localization.fontSize.toString)
                            Spacer()
                            Text("\(settingVM.fontSize)")
                        }
                    } onIncrement: {
                        settingVM.incrementStep()
                    } onDecrement: {
                        settingVM.decrementStep()
                    }
                }
                .font(.headline.weight(.medium))
                Divider().padding(.vertical, 4)
                VStack {
                    Text(Localization.textWillLook.toString)
                        .hLeading()
                    HStack {
                        Text(settingVM.getNewString())
                            .font(.system(size: CGFloat(settingVM.fontSize)))
                            .fontWeight(.heavy)
                            .padding()
                    }
                    .hCenter()
                    .background(.white)
                    .cornerRadius(8)
                    .padding()
                }
            }
            Spacer().frame(maxHeight: .infinity)
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Text Customisation")
        
        
    }
    
    
    
    private var languageLink: some View{
        NavigationLink {
            LanguageSpeechView()
                .environmentObject(speech)
                .environmentObject(settingVM)
        } label: {
            Text("Language and Speech")
                .font(.callout.weight(.medium))
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}
