//
//  ChordProgression.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 4/13/20.
//  Copyright © 2020 defranco. All rights reserved.
//

import Foundation

enum ChordType {
	case major
	case minor
	case diminished
	case major7
	case minor7
	case dominant7
	case suspended2
	case suspended4
	case augmented

	func from(tone: Int) -> [Int] {
		switch self {
		case .major:
			return [tone, tone + 4, tone + 7]
		case .minor:
			return [tone, tone + 3, tone + 7]
		case .diminished:
			return [tone, tone + 3, tone + 6]
		case .major7:
			return [tone, tone + 4, tone + 7, tone + 11]
		case .minor7:
			return [tone, tone + 3, tone + 7, tone + 10]
		case .dominant7:
			return [tone, tone + 4, tone + 7, tone + 10]
		case .suspended2:
			return [tone, tone + 2, tone + 7]
		case .suspended4:
			return [tone, tone + 5, tone + 7]
		case .augmented:
			return [tone, tone + 4, tone + 8]
		}
	}
}


enum Chord: String {
	case I
	case IMaj7
	case II
	case II7
	case III
	case III7
	case IV
	case IVMaj7
	case V
	case V7
	case VI
	case VI7
	case VII
	case VII7b5

	/// The values that form a chord in any given key, with 0 being the root,
	/// articulated in semitones (11 is the octave)
	var valueBySemiTone: [Int] {
		switch self {
		case .I:
			return [0, 4, 7]
		case .IMaj7:
			return [0, 4, 7, 11]
		case .II:
			return [2, 5, 9]
		case .II7:
			return [0, 2, 5, 9]
		case .III:
			return [4, 7, 11]
		case .III7:
			return [2, 4, 7, 11]
		case .IV:
			return [0, 5, 9]
		case .IVMaj7:
			return [0, 4, 5, 9]
		case .V:
			return [2, 7, 11]
		case .V7:
			return [2, 5, 7, 11]
		case .VI:
			return [0, 4, 9]
		case .VI7:
			return [0, 4, 7, 9]
		case .VII:
			return [2, 5, 11]
		case .VII7b5:
			return [2, 5, 9, 11]
		}
	}

	var root: Int {
		switch self {
		case .I, .IMaj7:
			return 0
		case .II, .II7:
			return 2
		case .III, .III7:
			return 4
		case .IV, .IVMaj7:
			return 5
		case .V, .V7:
			return 7
		case .VI, .VI7:
			return 9
		case .VII, .VII7b5:
			return 11
		}
	}

	var valueNo5th: [Int] {
		switch self {
		case .IMaj7:
			return [0, 4, 11]
		case .II7:
			return [0, 2, 9]
		case .III7:
			return [2, 4, 11]
		case .IVMaj7:
			return [0, 4, 9]
		case .V7:
			return [2, 5, 11]
		case .VI7:
			return [0, 4, 9]
		case .VII7b5:
			return [2, 5, 11]
		default:
			return []
		}
	}

	static var all: [Chord] {
		return [.IMaj7, .II7, .III7, .IVMaj7, .V7, .VI7, .VII7b5]
	}

	var progressionAscending: [Chord] {
		switch self {
		case .I, .IMaj7:
			return [.II, .II7, .V, .V7]
		case .II, .II7:
			return []
		case .III, .III7:
			return [.IV, .IVMaj7]
		case .IV, .IVMaj7:
			return [.V, .V7]
		case .V, .V7:
			return []
		case .VI, .VI7:
			return []
		case .VII, .VII7b5:
			return []
		}
	}

	var resolutionAscending: [Chord] {
		switch self {
		case .I, .IMaj7:
			return []
		case .II, .II7:
			return [.III, .III7, .VI, .VI7]
		case .III, .III7:
			return []
		case .IV, .IVMaj7:
			return [.I, .IMaj7]
		case .V, .V7:
			return [.VI, .VI7, .II, .II7]
		case .VI, .VI7:
			return []
		case .VII, .VII7b5:
			return []
		}
	}

	var progressionDescending: [Chord] {
		switch self {
		case .I, .IMaj7:
			return [.IV, .IVMaj7]
		case .II, .II7:
			return [.V, .V7]
		case .III, .III7:
			return [.II, .II7]
		case .IV, .IVMaj7:
			return []
		case .V, .V7:
			return []
		case .VI, .VI7:
			return [.V, .V7, .I, .IVMaj7, .II, .II7]
		case .VII, .VII7b5:
			return []
		}
	}

	var resolutionDescending: [Chord] {
		switch self {
		case .I, .IMaj7:
			return []
		case .II, .II7:
			return [.I, .IMaj7]
		case .III, .III7:
			return []
		case .IV, .IVMaj7:
			return [.III, .III7]
		case .V, .V7:
			return [.VI, .VI7, .III, .III7, .I, .IMaj7, .II, .II7]
		case .VI, .VI7:
			return [.III, .III7]
		case .VII, .VII7b5:
			return []
		}
	}

	var noChange: [Chord] {
		switch self {
		case .I, .IMaj7:
			return [.III, .III7, .VI, .VI7]
		case .II, .II7:
			return [.IV, .IVMaj7]
		case .III, .III7:
			return [.I, .IMaj7, .VI, .VI7]
		case .IV, .IVMaj7:
			return [.II, .II7, .VI, .VI7]
		case .V, .V7:
			return []
		case .VI, .VI7:
			return [.III, .III7]
		case .VII, .VII7b5:
			return []
		}
	}
}

struct ChordProgression {
	private(set) var chords = [Chord]()
	let configuration: ChordConfiguration

	mutating func addCalculatedChord() {
		//figure out which way we're going, up, down, progress or resolve
		let progress = chords.last?.progressionDescending ?? [] + (chords.last?.progressionAscending ?? [])
		let resolve = chords.last?.resolutionDescending ?? [] + (chords.last?.resolutionAscending ?? [])

		//find a chord that is allowed in the configuration.
		var found = false
		while !found {
			if !progress.isEmpty {
				let randIndex = Int.random(in: 0...progress.count - 1)
				let chord = progress[randIndex]
				if configuration.allowedChords.contains(chord) {
					chords.append(chord)
					found = true
				}

			} else {
				let randIndex = Int.random(in: 0...resolve.count - 1)
				let chord = resolve[randIndex]
				if configuration.allowedChords.contains(chord) {
					chords.append(chord)
					found = true
				}
			}
		}
	}

	mutating func reset() {
		chords.removeAll()
	}

	mutating func append(_ chord: Chord) {
		chords.append(chord)
	}
}

enum ChordConfiguration {
	case standard

	var allowedChords: [Chord] {
		return [.I, .II, .III, .IV, .V, .VI]
	}
}
