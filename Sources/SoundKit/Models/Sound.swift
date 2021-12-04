//
//  Sound.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import Foundation
import AVFAudio

public struct Sound: Hashable, Codable, Identifiable {
    public var id = UUID()
    public var name: String
    public var url: String
    
    @available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
    public func player() async -> AVAudioPlayer? {
        try? await SoundLoader.shared.player(for: URL(string: url)!)
    }
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

extension Sound {
    static let exampleData = (0..<100).map { i in
        Sound(
            name: "Sound \(i + 1)",
            url: "https://bigsoundbank.com/UPLOAD/mp3/0\(i + 1, specifier: "%03i")"
        )
    }
}

public struct BuiltinSound: Hashable, Codable, Identifiable {
    public var id = UUID()
    public var name: String
    public var fileName: String
    
    public func player() -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return nil
        }
        return try! AVAudioPlayer(contentsOf: url)
    }
    
    public init(name: String, fileName: String) {
        self.name = name
        self.fileName = fileName
    }
    
    public init(named name: String) {
        self.name = name
        self.fileName = "\(name).mp3"
    }
}
 
extension BuiltinSound {
    static let exampleData = [
        BuiltinSound(named: "Beep"),
        BuiltinSound(named: "Meditation Bell"),
        BuiltinSound(named: "Ding")
    ]
}

public enum SoundUnion: Hashable {
    case builtin(BuiltinSound)
    case userCreated(Sound)
    
    public var name: String {
        switch self {
            case .builtin(let builtinSound):
                return builtinSound.name
            case .userCreated(let sound):
                return sound.name
        }
    }
}
