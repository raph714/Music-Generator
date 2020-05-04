//
//  Note.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

enum ScaleToneVariation {
    case sharp
    case flat
    case natural
}

class Note {
    private var value: Int?
    
    //which member of a scale is this?
    var scaleTone: Int?
	var variation: ScaleToneVariation = .natural
    var duration: NoteDuration!
    var octave: Int = 4
    
    var renderedValue: Int? {
        guard let value = value else {
            return nil
        }
        var newVal = value + (12 * octave)
        switch variation {
        case .flat:
            newVal -= 1
        case .sharp:
            newVal += 1
        default:
            break
        }
        
        return newVal
    }



    init(value: Int, scaleTone: Int, duration: NoteDuration, variation: ScaleToneVariation = .natural, octave: Int = 4) {
        self.value = value
        self.duration = duration
        self.scaleTone = scaleTone
        self.variation = variation
        self.octave = octave
    }

	init(duration: NoteDuration) {
		self.duration = duration
	}

    func moveTo(within: Int, of note: Note?) {
        guard let selfVal = renderedValue,
            let otherVal = note?.renderedValue else {
                return
        }

        let distance = selfVal - otherVal
		print("\(selfVal) \(otherVal), \(distance)")

        if abs(distance) > within {
            if selfVal < otherVal {
                octave = octave + (abs(distance) / 12)
            } else {
                octave = octave - (abs(distance) / 12)
            }
        }

		print("\(String(describing: renderedValue))")
    }

    func isAt(interval: [Int], to note: Note?) -> Bool {
        guard let selfVal = value,
            let otherVal = note?.value else {
                return false
        }

        let foundInterval = interval.first(where: { abs(selfVal - otherVal) == $0 })

        return foundInterval != nil
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.value == rhs.value && lhs.duration == rhs.duration
    }
}
