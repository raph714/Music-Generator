//
//  Note.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

class Note {
    let value: UInt8?
    let duration: NoteDuration
    let location: Double
    
    init(value: UInt8?, duration: NoteDuration, location: Double) {
        self.value = value
        self.duration = duration
        self.location = location
    }
    
    static func from(tone: UInt8, at octave: UInt8, duration: NoteDuration, location: Double) -> Note {
        let value = tone + (12 * octave)
        return Note(value: value, duration: duration, location: location)
    }
    
    static func rest(duration: NoteDuration, location: Double) -> Note {
        return Note(value: nil, duration: duration, location: location)
    }
}
