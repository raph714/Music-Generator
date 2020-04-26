//
//  Composition.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/10/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

protocol CompositionDelegate: AnyObject {
    func didAdd(events: [NoteEvent])
}

enum AccompanymentType: String {
    case slowest
    case downbeat
    case all
    case random
}

class Composition {
    var noteEvents = [NoteEvent]()
    var scale = ScaleType.major.value
    var timeSignature = TimeSignature.fourFour
    var totalMeasures: Int = 2
    var tempo: Float64 = 72
    var accompanymentType: AccompanymentType = .downbeat
    var maxMelodyDistance: Int = 8
    
    var length: Double {
        return timeSignature.valuePerMeausure * Double(totalMeasures)
    }
    
    var delegate: CompositionDelegate?
    
    var slowest: NoteDuration = .eighth
    var fastest: NoteDuration = .sixteenth

	var currentChord = Chord.IMaj7
    
    func reset() {
        noteEvents.removeAll()
    }

	func addChords() {
		var location: Double = 0

		currentChord = .IMaj7

		while location < length {
			let nextLocation = NoteLocation.init(location).randomNext
			let duration = randomDuration(for: nextLocation)
//
//			print(currentChord.rawValue)
			let note = Note(value: currentChord.valueNo5th.first, scaleTone: nil, duration: duration, octave: 2)
			noteEvents.append(NoteEvent(notes: [.melody: note], location: nextLocation.location))

			for tone in currentChord.valueNo5th {
				let note = Note(value: tone, scaleTone: nil, duration: duration, octave: 4)
				noteEvents.append(NoteEvent(notes: [.melody: note], location: nextLocation.location))
			}

			print(currentChord)

			currentChord = currentChord.next()

			location = duration.value + nextLocation.location
		}

		delegate?.didAdd(events: noteEvents)
	}

    func compose() {
        var location: Double = 0
    
        while location < length {
//            if isMiddleThird(location: location) {
//                scale.variation = ScaleVariation.majorFlavor.value
//            } else {
//                scale.variation = [:]
//            }

			let nextLocation = NoteLocation.init(location).randomNext
			let duration = randomDuration(for: nextLocation)

			if nextLocation.location + duration.value > length {
				continue
			}

            let note = randomNote(duration: duration)
			noteEvents.append(NoteEvent(notes: [.melody: note], location: nextLocation.location))
            location = duration.value + nextLocation.location
        }
        
        generateHarmony()
        
        delegate?.didAdd(events: noteEvents)
    }

	func randomDuration(for location: NoteLocation) -> NoteDuration {
		if let duration = location.nextDuration {
			return duration
		}

		return NoteDuration.random(slowest: slowest, fastest: fastest)
	}

    func randomNote(duration: NoteDuration) -> Note {
        var foundNewNote = false
        var newNote: Note!

        while !foundNewNote {
            let rand = scale.randomToneIndex
            let variation = scale.variation[rand] ?? .natural

            newNote = Note.from(scaleTone: rand, value: scale.tones[rand], at: randomOctave, duration: duration, variation: variation)

            let lastNote = noteEvents.lastEvent?.notes[.melody]

            if let note = scale.get(next: newNote, from: lastNote) {
                newNote = note
            }

            //RULE: We don't want notes to be more than an octave away from each other.
            newNote.moveTo(within: maxMelodyDistance, of: lastNote)

            //RULE: We don't want the next note to be 6 or 11 semitones apart from the last.
            let isAtBadInterval = newNote.isAt(interval: [6, 11], to: lastNote)

            foundNewNote = !isAtBadInterval
        }

        return newNote
	}
    
    private var randomOctave: Int {
        let octave = Int.random(in: 4...6)
        return octave
    }
    
    private func isMiddleThird(location: Double) -> Bool {
        let startThird = length / 3
        let endThird = startThird * 2
        return location > startThird && location < endThird
    }
    
    private func generateHarmony() {
        switch accompanymentType {
        case .all:
            generateHarmonyAll()
        case .downbeat:
            generateHarmonyDownbeat()
        case .slowest:
            generateHarmonySlowest()
        case .random:
            generateHarmonyRandom()
        }
    }
    
    private func generateHarmonySlowest() {
        for event in noteEvents {
            if let note = event.notes[.melody], note.duration == slowest {
                addRelatedBass(for: note, at: event.location)
            }
        }
    }
    
    private func generateHarmonyAll() {
        for event in noteEvents {
            if let note = event.notes[.melody] {
                addRelatedBass(for: note, at: event.location)
            }
        }
    }
    
    private func generateHarmonyDownbeat() {
        var location: Double = 0
        
        while location < length {
            let event = noteEvents.lastEvent(atOrBefore: location)
            
            if let note = event?.notes[.melody] {
                addRelatedBass(for: note, at: location)
            }
            
            location += timeSignature.duration.value
        }
    }
    
    private func generateHarmonyRandom() {
        for event in noteEvents {
            if let note = event.notes[.melody],
                Int.random(in: 0...1) > 0 {
                addRandomBassTone(for: note, at: event.location)
            }
        }
    }

    private func addRandomBassTone(for note: Note, at location: Double) {
        var foundNewNote = false
        var newNote: Note!

        while !foundNewNote {
            let rand = scale.randomToneIndex
            let variation = scale.variation[rand] ?? .natural

            newNote = Note.from(scaleTone: rand, value: scale.tones[rand], at: 3, duration: note.duration, variation: variation)

            //RULE: We don't want the next note to be 1, 6 or 11 semitones apart from the last.
            let isAtBadInterval = newNote.isAt(interval: [0, 1, 2, 6, 11], to: note)

            foundNewNote = !isAtBadInterval
        }

        addBass(note: newNote, location: location)
    }
    
    private func addRelatedBass(for note: Note, at location: Double) {
        guard note.renderedValue != nil else {
            return
        }
        
        var foundNewNote = false
        var newNote: Note!

        while !foundNewNote {
            let rand = scale.randomToneIndex
            let variation = scale.variation[rand] ?? .natural

            newNote = Note.from(scaleTone: rand, value: scale.tones[rand], at: 3, duration: note.duration, variation: variation)

            //RULE: We want a member of a scale to go with our melody note
            let isAtGoodInterval = newNote.isAt(interval: [4, 5, 7], to: note)

            foundNewNote = isAtGoodInterval
        }

        addBass(note: newNote, location: location)
    }

    private func addBass(note: Note, location: Double) {
        if let event = noteEvents.event(at: location) {
            event.notes[.bass] = note
        } else {
            noteEvents.append(NoteEvent(notes: [.bass: note], location: location))
        }
    }
}
