//
//  Note.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

enum ScaleToneVariation {
    case sharp
    case flat
    case natural
}

class Note {
    var value: UInt8?
    
    //which member of a scale is this?
    var scaleTone: Int?
    var variation: ScaleToneVariation
    var duration: NoteDuration!
    var location: Double!
    var octave: UInt8
    
    var renderedValue: UInt8? {
        guard let value = value else {
            return nil
        }
        var newVal = value + (12 * octave)
        switch variation {
        case .flat:
            newVal -= 1
        case .sharp:
            newVal += 1
        default:
            break
        }
        
        return newVal
    }

    init(value: UInt8?, scaleTone: Int?, duration: NoteDuration?, location: Double?, variation: ScaleToneVariation = .natural, octave: UInt8) {
        self.value = value
        self.duration = duration
        self.location = location
        self.scaleTone = scaleTone
        self.variation = variation
        self.octave = octave
    }
    
    static func from(scaleTone: Int, value: UInt8, at octave: UInt8 = 4, duration: NoteDuration? = nil, location: Double? = nil, variation: ScaleToneVariation = .natural) -> Note {
        return Note(value: value, scaleTone: scaleTone, duration: duration, location: location, variation: variation, octave: octave)
    }
    
    static func rest(duration: NoteDuration, location: Double) -> Note {
        return Note(value: nil, scaleTone: nil, duration: duration, location: location, variation: .natural, octave: 4)
    }
}
