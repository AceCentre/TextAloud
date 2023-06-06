//
//  PlayPauseButton.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 27/04/2023.
//

import SwiftUI

/// TODO - Delete this
public struct PlayPauseButton: View {
    var isPlay: Bool
    var isDisabled: Bool = false
    var action: () -> Void
    
    public init(isPlay: Bool, isDisabled: Bool, action: @escaping () -> Void) {
        self.isPlay = isPlay
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public init(isPlay: Bool, action: @escaping () -> Void) {
        self.isPlay = isPlay
        self.isDisabled = false
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isPlay ? "stop.fill" : "play.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
                .background{
                    Circle()
                        .fill(Color.limeChalk)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 4)
                }
                .opacity(isDisabled ? 0.7 : 1)
        }
        .keyboardShortcut(isPlay ? .escape : .return)
        .disabled(isDisabled)
    }
}

public struct StopButton: View {
    var action: () -> Void
    
    public init(action:  @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "stop.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
                .background{
                    Circle()
                        .fill(Color.limeChalk)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 4)
                }
        }
        .keyboardShortcut(.escape)
    }
}


public struct PlayButton: View {
    var action: () -> Void
    
    public init(action:  @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
                .background{
                    Circle()
                        .fill(Color.limeChalk)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 4)
                }

        }
        .keyboardShortcut(.return)
    }
}

struct PlayPauseButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            PlayPauseButton(isPlay: false, action: {})
            PlayPauseButton(isPlay: true, action: {})
            PlayPauseButton(isPlay: true, isDisabled: true, action: {})
            PlayPauseButton(isPlay: false, isDisabled: true, action: {})
        }
       
    }
}
