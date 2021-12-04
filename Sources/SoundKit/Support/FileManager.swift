//
//  FileManager.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import Foundation

extension FileManager {
    var applicationSupportDirectory: URL? {
        try? url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

