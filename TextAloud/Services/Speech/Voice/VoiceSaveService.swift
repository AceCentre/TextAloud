//
//  VoiceSaveService.swift
//  TextAloud
//
//

import Foundation


class VoiceSaveService {
    
    static let shared = VoiceSaveService()
    private let userDefault = UserDefaults.standard
    private let userDataKey = "voiceSaveService"
    private init(){}
    
    
    func save(_ model: [VoiceModel]){
        userDefault.saveObject(model, key: userDataKey)
    }
    
    
    func load() -> [VoiceModel]?{
        return userDefault.loadObject(key: userDataKey)
    }
    
    func remove(){
        userDefault.removeObject(forKey: userDataKey)
    }
}
