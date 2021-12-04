//
//  String.swift
//  
//
//  Created by Ostap on 04.12.2021.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: CVarArg, specifier: String) {
        appendInterpolation(String(format: specifier, value))
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)!
    }
}
