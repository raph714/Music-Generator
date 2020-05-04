//
//  NoteDuration.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

enum NoteDuration: Int, CaseIterable {
    case whole = -2
    case half = -1
    case quarter = 0
    case eighth = 1
    case sixteenth = 2
    case thirtysecond = 3
    case sixtyfourth = 4
    
    /// Returns the double value, with 1.0 representing a quarter note.
    var value: Double {
        return Double(1/pow(2.0, Double(self.rawValue)))
    }
    
	static func random(slowest: NoteDuration, fastest: NoteDuration, weights: DurationWeight) -> NoteDuration {
		var rand = weights.random

		while rand.rawValue < slowest.rawValue || rand.rawValue > fastest.rawValue {
			rand = weights.random
		}

        return rand
    }
}

class DurationWeight: Weight {
	var weights = [NoteDuration: Int]()

	init(weights: [NoteDuration: Int]) {
		self.weights = weights
	}

	static var chordWeight: DurationWeight {
		return DurationWeight(weights: [.whole: 14, .half: 20, .quarter: 15, .eighth: 5, .sixteenth: 5, .thirtysecond: 3, .sixtyfourth: 2])
	}

	static var melodyWeight: DurationWeight {
		return DurationWeight(weights: [.whole: 3, .half: 5, .quarter: 12, .eighth: 12, .sixteenth: 8, .thirtysecond: 3, .sixtyfourth: 2])
	}

	var random: NoteDuration {
		return Self.random(for: weights)
	}
}
