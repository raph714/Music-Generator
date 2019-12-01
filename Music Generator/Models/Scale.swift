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
}
