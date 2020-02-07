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
    var melody = [Note]()
    var harmony = [Note]()
    var scale = ScaleType.major.value
    var timeSignature = TimeSignature.fourFour
    var totalMeasures: Int = 2
    var tempo: Float64 = 172
    var accompanymentType: AccompanymentType = .downbeat
    var restAmount: Rests = .none
    
    var length: Double {
        return timeSignature.valuePerMeausure * Double(totalMeasures)
    }
    
    var delegate: CompositionDelegate?
    
    var slowest: NoteDuration = .eighth
    var fastest: NoteDuration = .sixteenth
    
    func reset() {
        melody.removeAll()
        harmony.removeAll()
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
                note = Note.rest(duration: duration, location: location)
            } else {
                note = nextNote(duration: duration, location: location)
            }
            
            delegate?.willAdd(note: note)
            melody.append(note)
            location += duration.value
        }
        
        generateHarmony()
    }
    
    private var randomOctave: UInt8 {
        let octave = Int.random(in: 4...6)
        return UInt8(octave)
    }
    
    private func nextNote(duration: NoteDuration, location: Double) -> Note {
        let octave = randomOctave
        
        var newNote: Note = scale.randomNote(at: octave)
        
        //avoid 6 and 11 semi tones.
        if let lastNote = melody.last, let lastNoteValue = lastNote.value {
            for _ in 0...100 {
                let diff = abs(Int(newNote.value!) - Int(lastNoteValue)) % 12
                if diff != 11 || diff != 6 {
                    break
                }
                
                newNote = scale.randomNote(at: octave)
            }
        }
        
        newNote.duration = duration
        newNote.location = location

        return newNote
    }
    
    private var shouldRest: Bool {
        return Float.random(in: 0...1) < restAmount.percentage
    }
    
    private func isMiddleThird(location: Double) -> Bool {
        let startThird = length / 3
        let endThird = startThird * 2
        return location > startThird && location < endThird
    }
    
    //gives us the last note played
    private var lastNote: Note? {
        for (_, note) in melody.enumerated().reversed() {
            if note.value != nil {
                return note
            }
        }
        
        return nil
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
        for note in melody {
            if note.duration == slowest {
                addHarmony(for: note)
            }
        }
    }
    
    private func generateHarmonyAll() {
        for note in melody {
            addHarmony(for: note)
        }
    }
    
    private func generateHarmonyDownbeat() {
        var location: Double = 0
        
        while location < length {
            //find the last note that happened before the time we want.
            let note = melody.first { aNote -> Bool in
                if aNote.location == location {
                    return true
                } else {
                    return aNote.location + aNote.duration.value > location
                }
            }
            
            if let note = note {
                addHarmony(for: note)
            }
            
            location += timeSignature.duration.value
        }
    }
    
    private func generateHarmonyRandom() {
        for note in melody {
            if Int.random(in: 0...1) > 0 {
                addHarmony(for: note)
            }
        }
    }
    
    private func addHarmony(for note: Note) {
        guard let tone = note.scaleTone else {
            return
        }
        
        let root = scale.rootToneIndex(for: Int(tone))
        let harmonyNote = Note.from(scaleTone: root,
                                    value: scale.tones[root],
                                    at: 4,
                                    duration: note.duration,
                                    location: note.location,
                                    variation: scale.variation[root] ?? .natural)
        harmony.append(harmonyNote)
    }
}
