//
//  Scale.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

enum ScaleType: String {
    case twelve
    case major
    case minor

    var value: Scale {
        switch self {
        case .twelve:
            return Scale(noteValues: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
        case .major:
            return Scale(noteValues: [0, 2, 4, 5, 7, 9, 11])
        case .minor:
            return Scale(noteValues: [0, 2, 3, 5, 7, 8, 10])
        }
    }
}

enum ScaleVariation {
    case majorFlavor
    
    var value: [Int: ScaleToneVariation] {
        switch self {
        case .majorFlavor:
            return [6: .flat, 7: .flat]
        }
    }
}

struct Scale {
    let tones: [UInt8]
    var variation = [Int: ScaleToneVariation]()
    
    private var randomToneIndex: Int {
        return Int.random(in: 0...tones.count-1)
    }
    
    func randomNote(at octave: UInt8) -> Note {
        let rand = randomToneIndex
        let variation = self.variation[rand] ?? .natural
        return Note.from(scaleTone: rand, value: tones[rand], at: octave, variation: variation)
    }
    
    init(noteValues: [UInt8]) {
        var notes: [UInt8] = []
        for note in noteValues {
            notes.append(note)
        }
        
        self.tones = notes
    }
    
    func chord(for tone: UInt8) -> [UInt8] {
        guard let index = tones.firstIndex(of: tone) else {
            fatalError("Note not found in scale")
        }
        
        var chord = [tone]
        
        //for now each note passed in will be the top note of the chord
        //find the root
        if index - 4 >= 0 {
            chord.append(tones[index - 4])
        } else {
            chord.append(tones[index + 3])
        }
        
        //find the 3rd
        if index - 2 >= 0 {
            chord.append(tones[index - 2])
        } else {
            chord.append(tones[index + 5])
        }
        
        return chord
    }
    
    func rootToneIndex(for tone: Int) -> Int {
        if tone - 2 >= 0 {
            return tone
        } else {
            return tone + 5
        }
    }
    
    func root(for third: UInt8) -> UInt8 {
        guard let index = tones.firstIndex(of: third % 12) else {
            fatalError("Note not found in scale")
        }

        if index - 2 >= 0 {
            let note = tones[index - 2]
            return note
        } else {
            let note = tones[index + 5]
            return note
        }
    }
}

extension UInt8 {
    var letter: String {
        let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        return notes[Int(self) % 12]
    }
}
