//
//  Color.swift
//  TextAloud
//
//

import SwiftUI


extension Color{
    
    
    static let deepOcean = Color("Deep Ocean")
    
    static let lightOcean = Color("Light Ocean")
    
    static let limeChalk = Color("Lime Chalk")
    
    static let orange = Color("Orange")
    
}




extension Color: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        do{
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? .black
            
            self = Color(color)
        }catch{
            self = .black
        }
    }
    public var rawValue: String {
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        }catch{
            return ""
        }
    }
}
