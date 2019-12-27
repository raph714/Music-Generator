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
            return 0.25
        case .lots:
            return 0.50
        }
    }
}

class Composition {
    var melody = [Note]()
    var harmony = [Note]()
    var scale = Scale.major
    var timeSignature = TimeSignature.fourFour
    var totalMeasures: Int = 2
    var tempo: Float64 = 72
    var accompanymentType: AccompanymentType = .downbeat
    var restAmount: Rests = .none
    
    var length: Double {
        return timeSignature.valuePerMeausure * Double(totalMeasures)
    }
    
    var delegate: CompositionDelegate?
    
    let slowest: NoteDuration = .quarter
    let fastest: NoteDuration = .sixteenth
    
    func reset() {
        melody.removeAll()
        harmony.removeAll()
    }

    func compose() {
        var location: Double = 0
    
        while location < length {
            let duration = NoteDuration.random(slowest: slowest, fastest: fastest)
            let note = scale.random(at: [5, 6, 7],
                                    duration: duration,
                                    location: location,
                                    restProbability: restAmount.percentage)
            delegate?.willAdd(note: note)

            melody.append(note)
            location += duration.value
        }
        
        generateHarmony()
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
            if note.duration == slowest,
                let val = note.value {
                
                let root = scale.root(for: val)
                let harmonyNote = Note.from(tone: root,
                                            at: 4,
                                            duration: note.duration,
                                            location: note.location)
                harmony.append(harmonyNote)
            }
        }
    }
    
    private func generateHarmonyAll() {
        for note in melody {
            if let val = note.value {
                let root = scale.root(for: val)
                let harmonyNote = Note.from(tone: root,
                                            at: 4,
                                            duration: note.duration,
                                            location: note.location)
                harmony.append(harmonyNote)
            }
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
            
            if let note = note, let val = note.value {
                let root = scale.root(for: val)
                let harmonyNote = Note.from(tone: root,
                                            at: 4,
                                            duration: timeSignature.duration,
                                            location: location)
                harmony.append(harmonyNote)
            }
            
            location += timeSignature.duration.value
        }
    }
    
    private func generateHarmonyRandom() {
        for note in melody {
            if let val = note.value,
                Int.random(in: 0...1) > 0 {
                let root = scale.root(for: val)
                let harmonyNote = Note.from(tone: root,
                                            at: 4,
                                            duration: note.duration,
                                            location: note.location)
                harmony.append(harmonyNote)
            }
        }
    }
}
