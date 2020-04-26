//
//  ChordProgression.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 4/13/20.
//  Copyright © 2020 defranco. All rights reserved.
//

import Foundation

enum Chord: String {
	case IMaj7
	case II7
	case III7
	case IVMaj7
	case V7
	case VI7
	case VII7b5

	/// The values that form a chord in any given key, with 0 being the root,
	/// articulated in semitones (11 is the octave)
	var valueBySemiTone: [Int] {
		switch self {
		case .IMaj7:
			return [0, 4, 7, 11]
		case .II7:
			return [0, 2, 5, 9]
		case .III7:
			return [2, 4, 7, 11]
		case .IVMaj7:
			return [0, 4, 5, 9]
		case .V7:
			return [2, 5, 7, 11]
		case .VI7:
			return [0, 4, 7, 9]
		case .VII7b5:
			return [2, 5, 9, 11]
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
		}
	}

	static var all: [Chord] {
		return [.IMaj7, .II7, .III7, .IVMaj7, .V7, .VI7, .VII7b5]
	}

	func next() -> Chord {
		//figure out which way we're going, up, down, progress or resolve
		let progress = self.progressionDescending + self.progressionAscending
		let resolve = self.resolutionDescending + self.resolutionAscending

		if !progress.isEmpty {
			let randIndex = Int.random(in: 0...progress.count - 1)
			return progress[randIndex]
		} else {
			let randIndex = Int.random(in: 0...resolve.count - 1)
			return resolve[randIndex]
		}
	}

	var progressionAscending: [Chord] {
		switch self {
		case .IMaj7:
			return [.II7, .V7]
		case .II7:
			return []
		case .III7:
			return [.IVMaj7]
		case .IVMaj7:
			return [.V7]
		case .V7:
			return []
		case .VI7:
			return []
		case .VII7b5:
			return []
		}
	}

	var resolutionAscending: [Chord] {
		switch self {
		case .IMaj7:
			return []
		case .II7:
			return [.III7, .VI7]
		case .III7:
			return []
		case .IVMaj7:
			return [.IMaj7]
		case .V7:
			return [.VI7, .II7]
		case .VI7:
			return []
		case .VII7b5:
			return []
		}
	}

	var progressionDescending: [Chord] {
		switch self {
		case .IMaj7:
			return [.IVMaj7]
		case .II7:
			return [.V7]
		case .III7:
			return [.II7]
		case .IVMaj7:
			return []
		case .V7:
			return []
		case .VI7:
			return [.V7, .IVMaj7, .II7]
		case .VII7b5:
			return []
		}
	}

	var resolutionDescending: [Chord] {
		switch self {
		case .IMaj7:
			return []
		case .II7:
			return [.IMaj7]
		case .III7:
			return []
		case .IVMaj7:
			return [.III7]
		case .V7:
			return [.VI7, .III7, .IMaj7, .II7]
		case .VI7:
			return [.III7]
		case .VII7b5:
			return []
		}
	}

	var noChange: [Chord] {
		switch self {
		case .IMaj7:
			return [.III7, .VI7]
		case .II7:
			return [.IVMaj7]
		case .III7:
			return [.IMaj7, .VI7]
		case .IVMaj7:
			return [.II7, .VI7]
		case .V7:
			return []
		case .VI7:
			return [.III7]
		case .VII7b5:
			return []
		}
	}
}
