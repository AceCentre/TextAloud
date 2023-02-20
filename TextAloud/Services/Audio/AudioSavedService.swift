//
//  AudioSavedService.swift
//  TextAloud
//
//  Created by Богдан Зыков on 20.02.2023.
//

import Foundation

class AudioSavedService{
    
    let fileManager = LocalFileManager.instance
    let folderName = "AzureText"
    
    func storeAudioFile(for data: Data) -> URL?{
        let name = "audio-\(Date().ISO8601Format()).mp3"
        return fileManager.save(for: data, fileNameWithExt: name, folderName: folderName)
    }
    
    
    func remove(for url: URL) -> Bool{
        return fileManager.remove(for: url)
    }
    
}




