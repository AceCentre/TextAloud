//
//  User.swift
//  TextAloud
//
//

import Foundation

extension UserDefaults{
    
    
    public func saveObject<T: Codable>(_ object: T, key: String){
        guard let encodeObject = try? JSONEncoder().encode(object) else{return}
        self.set(encodeObject, forKey: key)
    }
    
    public func loadObject<T: Codable>(key: String) -> T?{
        guard let object = self.object(forKey: key) as? Data else{return nil}
        guard let returnedObject = try? JSONDecoder().decode(T.self, from: object) else{return nil}
        return returnedObject
    }
}
