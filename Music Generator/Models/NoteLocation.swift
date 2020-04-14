//
//  NoteLocation.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 3/29/20.
//  Copyright © 2020 defranco. All rights reserved.
//

import Foundation

struct NoteLocationWeight: Weight {
	let weights: [NoteLocation: Int]

	init(weights: [NoteLocation: Int]) {
		self.weights = weights
	}

	static func fourFour(current: NoteLocation) -> NoteLocationWeight {
		let weight = [NoteLocation(0): 100,
					  NoteLocation(0.25): 40,
					  NoteLocation(0.5): 50,
					  NoteLocation(0.75): 30,
					  NoteLocation(1): 80,
					  NoteLocation(1.25): 40,
					  NoteLocation(1.5): 50,
					  NoteLocation(1.75): 30,
					  NoteLocation(2): 90,
					  NoteLocation(2.25): 40,
					  NoteLocation(2.5): 50,
					  NoteLocation(2.75): 30,
					  NoteLocation(3): 70,
					  NoteLocation(3.25): 40,
					  NoteLocation(3.5): 50,
					  NoteLocation(3.75): 30]

		var newWeights = [NoteLocation: Int]()
		for key in weight.keys {
			if key.location < current.location {
				let val = weight[key] ?? 10
				newWeights[key] = val / 10
			} else {
				newWeights[key] = weight[key]
			}
		}

		newWeights[current] = 7500

		return NoteLocationWeight(weights: newWeights)
	}

	var random: NoteLocation {
		return Self.random(for: weights)
	}
}

struct NoteLocation: Hashable {
	let location: Double

	init(_ location: Double) {
		self.location = location
	}

	private var locationInMeasure: NoteLocation {
		//find the current location in the measure from which to base the weights on.
		let currentLocationInMeasure = location.truncatingRemainder(dividingBy: 4)
		return NoteLocation(currentLocationInMeasure)
	}

	var randomNext: NoteLocation {
		let fourFourWeight = NoteLocationWeight.fourFour(current: self.locationInMeasure)

		//now get a random location. for example 2.25
		let randomWeightedLocation = fourFourWeight.random

		//now make sure it's going to happen AFTER where we are currently.
		//if we got one before the current location we just add 4 - random weight. so if we were at 3 and got 2, we'd want to add 2, to get to 5 (2 beat in next measure)
		if randomWeightedLocation.location < locationInMeasure.location {
			let newLocation = location + (randomWeightedLocation.location - locationInMeasure.location) + 4
			return NoteLocation(newLocation)
		} else {
			//we're either at or after the thing, so just add the difference.
			let newLocation = location + (randomWeightedLocation.location - locationInMeasure.location)
			return NoteLocation(newLocation)
		}
	}

	var nextDuration: NoteDuration? {
		let placeInBeat = locationInMeasure.location.truncatingRemainder(dividingBy: 1)

		if placeInBeat == 0.25 || placeInBeat == 0.75 {
			return .sixteenth
		} else if placeInBeat == 0.5 {
			return .eighth
		}

		return nil
	}
}
