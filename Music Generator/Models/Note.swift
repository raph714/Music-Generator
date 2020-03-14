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
    private var value: Int?
    
    //which member of a scale is this?
    var scaleTone: Int?
    var variation: ScaleToneVariation
    var duration: NoteDuration!
    var octave: Int
    
    var renderedValue: Int? {
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

    init(value: Int?, scaleTone: Int?, duration: NoteDuration?, variation: ScaleToneVariation = .natural, octave: Int) {
        self.value = value
        self.duration = duration
        self.scaleTone = scaleTone
        self.variation = variation
        self.octave = octave
    }
    
    static func from(scaleTone: Int, value: Int, at octave: Int = 4, duration: NoteDuration? = nil, variation: ScaleToneVariation = .natural) -> Note {
        return Note(value: value, scaleTone: scaleTone, duration: duration, variation: variation, octave: octave)
    }
    
    static func rest(duration: NoteDuration) -> Note {
        return Note(value: nil, scaleTone: nil, duration: duration, variation: .natural, octave: 4)
    }

    func moveTo(within: Int, of note: Note?) {
        guard let selfVal = renderedValue,
            let otherVal = note?.renderedValue else {
                return
        }

        let distance = selfVal - otherVal

        if abs(distance) > within {
            if selfVal < otherVal {
                octave = octave + (abs(distance) / 12)
            } else {
                octave = octave - (abs(distance) / 12)
            }
        }
    }

    func isAt(interval: Int, to note: Note?) -> Bool {
        guard let selfVal = value,
            let otherVal = note?.value else {
                return false
        }

        return abs(selfVal - otherVal) == interval
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.value == rhs.value && lhs.duration == rhs.duration
    }
}
