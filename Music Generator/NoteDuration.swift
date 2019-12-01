//
//  NoteDuration.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

enum NoteDuration: Int {
    case whole = -2
    case half = -1
    case quarter = 0
    case eighth = 1
    case sixteenth = 2
    case thirtysecond = 3
    case sixyfourth = 4

    var value: Double {
        return Double(1/pow(2.0, Double(self.rawValue)))
    }
    
    var floatValue: Float {
        return Float(value)
    }
    
    static func random(slowest: NoteDuration, fastest: NoteDuration) -> NoteDuration {
        guard let rand = NoteDuration(rawValue: Int.random(in: slowest.rawValue...fastest.rawValue)) else {
            fatalError("Couldn't make note length value!")
        }
        return rand
    }
}
