//
//  Composition.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/10/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

protocol CompositionDelegate: AnyObject {
    func didAdd(events: [NoteEvent])
}

enum AccompanymentType: String {
    case slowest
    case downbeat
    case all
    case random
}

enum Rests: String {
    case little
    case lots
    case none
    
    var percentage: Float {
        switch self {
        case .none:
            return 0
        case .little:
            return 0.15
        case .lots:
            return 0.35
        }
    }
}

class Composition {
    var noteEvents = [NoteEvent]()
    var scale = ScaleType.major.value
    var timeSignature = TimeSignature.fourFour
    var totalMeasures: Int = 2
    var tempo: Float64 = 72
    var accompanymentType: AccompanymentType = .downbeat
    var restAmount: Rests = .none
    
    var length: Double {
        return timeSignature.valuePerMeausure * Double(totalMeasures)
    }
    
    var delegate: CompositionDelegate?
    
    var slowest: NoteDuration = .eighth
    var fastest: NoteDuration = .sixteenth
    
    func reset() {
        noteEvents.removeAll()
    }

    func compose() {
        var location: Double = 0
    
        while location < length {
            if isMiddleThird(location: location) {
                scale.variation = ScaleVariation.majorFlavor.value
            } else {
                scale.variation = [:]
            }
            
            let duration = NoteDuration.random(slowest: slowest, fastest: fastest)
            
            let note: Note
            
            if shouldRest {
                note = Note.rest(duration: duration)
            } else {
                note = randomNote(at: randomOctave)
                note.duration = duration
            }
            
            noteEvents.append(NoteEvent(notes: [.melody: note], location: location))
            location += duration.value
        }
        
        generateHarmony()
        
        delegate?.didAdd(events: noteEvents)
    }

    func randomNote(at octave: Int) -> Note {
        var foundNewNote = false
        var newNote: Note!

        while !foundNewNote {
            let rand = scale.randomToneIndex
            let variation = scale.variation[rand] ?? .natural

            newNote = Note.from(scaleTone: rand, value: scale.tones[rand], at: octave, variation: variation)

            let lastNote = noteEvents.lastEvent?.notes[.melody]
            newNote.moveTo(within: 12, of: lastNote)

            let isAtBadInterval = newNote.isAt(interval: 6, to: lastNote) && newNote.isAt(interval: 11, to: lastNote)
            foundNewNote = !isAtBadInterval
        }

        return newNote
    }
    
    private var randomOctave: Int {
        let octave = Int.random(in: 4...6)
        return octave
    }
    
    private var shouldRest: Bool {
        return Float.random(in: 0...1) < restAmount.percentage
    }
    
    private func isMiddleThird(location: Double) -> Bool {
        let startThird = length / 3
        let endThird = startThird * 2
        return location > startThird && location < endThird
    }
    
    private func generateHarmony() {
        switch accompanymentType {
        case .all:
            generateHarmonyAll()
        case .downbeat:
            generateHarmonyDownbeat()
        case .slowest:
            generateHarmonySlowest()
        case .random:
            generateHarmonyRandom()
        }
    }
    
    private func generateHarmonySlowest() {
        for event in noteEvents {
            if let note = event.notes[.melody], note.duration == slowest {
                addHarmony(for: note, at: event.location)
            }
        }
    }
    
    private func generateHarmonyAll() {
        for event in noteEvents {
            if let note = event.notes[.melody] {
                addHarmony(for: note, at: event.location)
            }
        }
    }
    
    private func generateHarmonyDownbeat() {
        var location: Double = 0
        
        while location < length {
            let event = noteEvents.lastEvent(atOrBefore: location)
            
            if let note = event?.notes[.melody] {
                addHarmony(for: note, at: location)
            }
            
            location += timeSignature.duration.value
        }
    }
    
    private func generateHarmonyRandom() {
        for event in noteEvents {
            if let note = event.notes[.melody],
                Int.random(in: 0...1) > 0 {
                addHarmony(for: note, at: event.location)
            }
        }
    }
    
    private func addHarmony(for note: Note, at location: Double) {
        guard let tone = note.scaleTone else {
            return
        }
        
        let root = scale.rootToneIndex(for: Int(tone))
        let harmonyNote = Note.from(scaleTone: root,
                                    value: scale.tones[root],
                                    at: 3,
                                    duration: note.duration,
                                    variation: scale.variation[root] ?? .natural)
        
        if let event = noteEvents.event(at: location) {
            event.notes[.bass] = harmonyNote
        } else {
            noteEvents.append(NoteEvent(notes: [.bass: harmonyNote], location: location))
        }
    }
}
