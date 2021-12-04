//
//  SoundStore.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public class SoundStore: ObservableObject, Codable {
    @Published public var sounds: [Sound]
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(sounds)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        sounds = try container.decode([Sound].self)
    }
    
    public init(sounds: [Sound] = []) {
        self.sounds = sounds
    }
}
