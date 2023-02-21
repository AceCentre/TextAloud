//
//  AudioSavedService.swift
//  TextAloud
//
//

import Foundation

class AudioSavedService{
    
    let fileManager = LocalFileManager.instance
    
    func storeAudioFile(name: String, for data: Data) -> URL?{
        let name = "audio-\(name).mp3"
        return fileManager.save(for: data, fileNameWithExt: name)
    }
    
    @discardableResult
    func remove(for url: URL) -> Bool{
        return fileManager.remove(for: url)
    }
    
}




