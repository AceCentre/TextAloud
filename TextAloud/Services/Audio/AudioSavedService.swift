//
//  AudioSavedService.swift
//  TextAloud
//
//

import Foundation

class AudioSavedService{
    
    let fileManager = LocalFileManager.instance
    
    func storeAudioFile(for data: Data) -> URL?{
        let name = "audio-\(Date().ISO8601Format()).mp3"
        return fileManager.save(for: data, fileNameWithExt: name)
    }
    
    @discardableResult
    func remove(for url: URL) -> Bool{
        return fileManager.remove(for: url)
    }
    
}




