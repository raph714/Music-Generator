//
//  Scale.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

 enum ScaleType: String {
    case major
    case minor
	case dorian

    var value: Scale {
        switch self {
        case .major:
            return Scale(noteValues: [0, 2, 4, 5, 7, 9, 11])
        case .minor:
            return Scale(noteValues: [0, 2, 3, 5, 7, 8, 10])
		case .dorian:
			return Scale(noteValues: [0, 2, 3, 5, 7, 9, 10])
        }
    }
	func midiValues(for keyTone: Int) -> [ScaleTone: Int] {
		switch self {
		case .major:
			return [.I: keyTone,
					.II: keyTone + 2,
					.III: keyTone + 4,
					.IV: keyTone + 5,
					.V: keyTone + 7,
					.VI: keyTone + 9,
					.VII: keyTone + 11]
		case .minor:
			return [.I: keyTone,
					.II: keyTone + 2,
					.III: keyTone + 3,
					.IV: keyTone + 5,
					.V: keyTone + 7,
					.VI: keyTone + 8,
					.VII: keyTone + 10]
		case .dorian:
			return [.I: keyTone,
					.II: keyTone + 2,
					.III: keyTone + 3,
					.IV: keyTone + 5,
					.V: keyTone + 7,
					.VI: keyTone + 9,
					.VII: keyTone + 10]
		}
	}

	var chords: [ChordType] {
		switch self {
		case .major:
			return [.major, .minor, .minor, .major, .major, .minor, .diminished]
		case .minor:
			return [.minor, .diminished, .major, .minor, .minor, .major, .major]
		case .dorian:
			return [.minor, .minor, .major, .major, .minor, .diminished, .major]
		}
	}
}

enum ScaleTone: String {
	case I
	case II
	case III
	case IV
	case V
	case VI
	case VII

	var intValue: Int {
		switch self {
		case .I:
			return 1
		case .II:
			return 2
		case .III:
			return 3
		case .IV:
			return 4
		case .V:
			return 5
		case .VI:
			return 6
		case .VII:
			return 7
		}
	}
}



enum ScaleVariation {
    case majorFlavor
    
    var value: [Int: ScaleToneVariation] {
        switch self {
        case .majorFlavor:
            return [5: .flat, 6: .flat]
        }
    }
}

class ScaleWeight: Weight {
    var weights = [Int: Int]()

    init(weights: [Int: Int]) {
        self.weights = weights
    }

    static var major: ScaleWeight {
        return ScaleWeight(weights: [0: 12, 1: 10, 2: 12, 3: 10, 4: 12, 5: 10, 6: 8])
    }

	var random: Int {
		return Self.random(for: weights)
	}
}

struct Scale {
    let tones: [Int]
    var variation = [Int: ScaleToneVariation]()

    //we want to give a higher probability for some notes at some times.
    //the index will be the scale tone index, and the value will be the weight.
    //add all the weights up, do a random and figure out where it should sit.
    var scaleWeight: ScaleWeight = ScaleWeight.major
    
    var randomToneIndex: Int {
		return scaleWeight.random
    }
    
    init(noteValues: [Int]) {
        var notes: [Int] = []
        for note in noteValues {
            notes.append(note)
        }
        
        self.tones = notes
    }

    func get(next: Note, from last: Note?) -> Note? {
        guard let last = last else {
            return nil
        }

        if last.scaleTone == 6 {
            return Note(value: tones[1], scaleTone: 0, duration: next.duration, variation: variation[1] ?? .natural, octave: next.octave)
        } else if last.scaleTone == 3 {
            return Note(value: tones[2], scaleTone: 2, duration: next.duration, variation: variation[2] ?? .natural, octave: next.octave)
        }

        return nil
    }
    
    func chord(for tone: Int) -> [Int] {
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
        let tone = tones[tone]
        
        //let's see if a fifth is in range
        if let index = tones.firstIndex(where: {$0 == (tone + 5) % 12}) {
            return index
        }
        
        //ok no fifth, let's see if the third is there
        if let index = tones.firstIndex(where: {$0 == (tone + 8) % 12}) {
            return index
        }
        
        //oops, how about a minor third?
        if let index = tones.firstIndex(where: {$0 == (tone + 9) % 12}) {
            return index
        }
        
        fatalError()
    }
    
    func root(for third: Int) -> Int {
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
