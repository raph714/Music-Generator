//
//  Scale.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

struct Scale {
    let tones: [UInt8]
    
    func randomized() -> [UInt8] {
        var notesCopy = tones
        var randomized = [UInt8]()
        for _ in 0...tones.count-1 {
            let randIndex = Int.random(in: 0...notesCopy.count-1)
            let noteValue = notesCopy[randIndex]
            randomized.append(noteValue)
            notesCopy.remove(at: randIndex)
        }
        return randomized
    }
    
    var random: UInt8 {
        return tones[Int.random(in: 0...tones.count-1)]
    }
    
    func random(at randomOctave: [UInt8], duration: NoteDuration, location: Double, restProbability: Float) -> Note {
        let octave = Int.random(in: 0...randomOctave.count - 1)
        let rest = Float.random(in: 0...1)
        
        if rest < restProbability {
            return Note.rest(duration: duration, location: location)
        } else {
            return Note.from(tone: random, at: randomOctave[octave], duration: duration, location: location)
        }
    }
    
    func random(number: Int) -> [UInt8] {
        var randomized = [UInt8]()
        for _ in 0...number {
            let randIndex = Int.random(in: 0...tones.count-1)
            let noteValue = tones[randIndex]
            randomized.append(noteValue)
        }

        return randomized
    }
    
    init(noteValues: [UInt8]) {
        var notes: [UInt8] = []
        for note in noteValues {
            notes.append(note)
        }
        
        self.tones = notes
    }
    
    static var twelveTone: Scale {
        return Scale(noteValues: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    }
    
    static var major: Scale {
        return Scale(noteValues: [0, 2, 4, 5, 7, 9, 11])
    }
    
    static var minor: Scale {
        return Scale(noteValues: [0, 2, 3, 5, 7, 8, 10])
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
