//
//  SoundStore.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 8.0, tvOS 13.0, *)
public class SoundStore: ObservableObject {
    @Published public var sounds = [Sound]()
}
