//
//  Note.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

struct Note {
    let tonalValue: UInt8
    
    func value(at octave: UInt8) -> UInt8 {
        return tonalValue + (12 * octave)
    }
    
    var letter: String {
        let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        return notes[Int(tonalValue) % 12]
    }
}
