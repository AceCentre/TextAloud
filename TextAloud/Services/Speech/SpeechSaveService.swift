//
//  SpeechSaveService.swift
//  TextAloud
//
//

import Foundation
import TextAloudKit

class SpeechSaveService {

    static let shared = SpeechSaveService()
    private let userDefault = UserDefaults.standard
    private let userDataKey = "speechSaveService"
    private init(){}


    func save(_ model: SpeechSaveModel){
        userDefault.saveObject(model, key: userDataKey)
    }


    func load() -> SpeechSaveModel?{
        let model: SpeechSaveModel? = userDefault.loadObject(key: userDataKey)
        return model
    }

    func remove(){
        userDefault.removeObject(forKey: userDataKey)
    }
}


struct SpeechSaveModel: Codable{
    var audio: Audio?
    var text: String
    var lastWordRange: NSRange?
}

