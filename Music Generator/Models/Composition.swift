//
//  Composition.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/10/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

protocol CompositionDelegate: AnyObject {
    func willAdd(note: Note)
}

class Composition {
    var melody = [Note]()
    var harmony = [Note]()
    var scale = Scale.major
    var timeSignature = TimeSignature.fourFour
    var totalMeasures: Int = 2
    
    var delegate: CompositionDelegate?
    
    let slowest: NoteDuration = .quarter
    let fastest: NoteDuration = .sixteenth
    
    func reset() {
        melody.removeAll()
        harmony.removeAll()
    }

    func compose() {
        var location: Double = 0
    
        while location < 16 {
            let duration = NoteDuration.random(slowest: slowest, fastest: fastest)
            let note = scale.random(at: [5, 6, 7], duration: duration, location: location)
            delegate?.willAdd(note: note)

            melody.append(note)

            if (location == 0 || duration == slowest),
                let val = note.value {
                let root = scale.root(for: val)
                let harmonyNote = Note.from(tone: root, at: 4, duration: duration, location: location)
                harmony.append(harmonyNote)
            } else {
                harmony.append(Note.silence(duration: duration, location: location))
            }

            location += duration.value
        }
    }
}
