//
//  Scale.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

struct Scale {
    let notes: [Note]
    
    func randomized() -> [Note] {
        var notesCopy = notes
        var randomized = [Note]()
        for _ in 0...notes.count-1 {
            let randIndex = Int.random(in: 0...notesCopy.count-1)
            let noteValue = notesCopy[randIndex]
            randomized.append(noteValue)
            notesCopy.remove(at: randIndex)
        }
        return randomized
    }
    
    init(noteValues: [UInt8]) {
        var notes: [Note] = []
        for note in noteValues {
            notes.append(Note(tonalValue: note))
        }
        
        self.notes = notes
    }
    
    static var twelveTone: Scale {
        return Scale(noteValues: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    }
    
    static var major: Scale {
        return Scale(noteValues: [0, 2, 4, 5, 7, 9, 11, 12])
    }
    
    func chord(for note: Note) -> [Note] {
        guard let index = notes.firstIndex(of: note) else {
            fatalError("Note not found in scale")
        }
        
        var chord = [note]
        
        //for now each note passed in will be the top note of the chord
        //find the root
        if index - 4 >= 0 {
            chord.append(notes[index - 4])
        } else {
            chord.append(notes[index + 3])
        }
        
        //find the 3rd
        if index - 2 >= 0 {
            chord.append(notes[index - 2])
        } else {
            chord.append(notes[index + 5])
        }
        
        return chord
    }
    
    func root(for third: Note) -> Note {
        guard let index = notes.firstIndex(of: third) else {
            fatalError("Note not found in scale")
        }

        if index - 2 >= 0 {
            let note = notes[index - 2]
            print(note.letter, third.letter)
            return notes[index - 2]
        } else {
            let note = notes[index + 5]
            print(note.letter, third.letter)
            return notes[index + 5]
        }
    }
}
