//
//  VoiceSaveService.swift
//  TextAloud
//
//

import Foundation
import TextAloudKit

class VoiceSaveService {
    
    static let shared = VoiceSaveService()
    private let userDefault = UserDefaults.standard
    private let userDataKey = "voiceSaveService"
    private init(){}
    
    
    func save(_ model: [Voice]){
        userDefault.saveObject(model, key: userDataKey)
    }
    
    
    func load() -> [Voice]?{
        return userDefault.loadObject(key: userDataKey)
    }
    
    func remove(){
        userDefault.removeObject(forKey: userDataKey)
    }
}
