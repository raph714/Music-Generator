//
//  File.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 3/13/20.
//  Copyright © 2020 defranco. All rights reserved.
//

import Foundation

extension Int {
    var letter: String {
        let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let note = notes[Int(self) % 12] + "\(self/12)"
        return note
    }

    func distance(to noteValue: Int?) -> Int {
        guard let note = noteValue else {
            return 0
        }

        if self > note {
            return Int(self - note)
        } else {
            return Int(note - self)
        }
    }
}
