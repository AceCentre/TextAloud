//
//  Color.swift
//  TextAloud
//
//

import SwiftUI


extension Color{
    static public let deepOcean = Color(red: 0, green: 0.325, blue: 0.498)
    static public let lightOcean = Color(red: 0.416, green: 0.616, blue: 0.780)
    static public let limeChalk = Color(red: 0.671, green: 0.800, blue: 0.349)
    static public let orange = Color(red: 0.882, green: 0.533, blue: 0.000)
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
