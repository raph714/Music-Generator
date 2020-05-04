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

	var chordProgression = ChordProgression(chords: [.I], configuration: .standard)
    
    func reset() {
        noteEvents.removeAll()
	}

	func composeWithChords() {
		//start by throwing down some chords
		addChords()

		//next layer on some melody
		addMelody()

		delegate?.didAdd(events: noteEvents)
	}

	func addChords() {
		var location: Double = 0

		chordProgression = ChordProgression(chords: [.I], configuration: .standard)

		while location < length {
			let nextLocation = NoteLocation.init(location).randomNext
			let duration = randomDuration(for: nextLocation, weights: DurationWeight.chordWeight)

			let note = Note(value: chordProgression.chords.last!.root, scaleTone: scale.tones.firstIndex(of: chordProgression.chords.last!.root)!, duration: duration, octave: 2)
			noteEvents.append(NoteEvent(notes: [.bass: note], location: nextLocation.location))

			for tone in chordProgression.chords.last!.valueBySemiTone {
				let note = Note(value: tone, scaleTone: scale.tones.firstIndex(of: tone)!, duration: duration, octave: 4)
				noteEvents.append(NoteEvent(notes: [.chord: note], location: nextLocation.location))
			}

			chordProgression.addCalculatedChord()

			location = duration.value + nextLocation.location
		}
	}

	func addMelody() {
		var location: Double = 0

		while location < length {
			let nextLocation = NoteLocation.init(location).randomNext
			let duration = randomDuration(for: nextLocation, weights: DurationWeight.melodyWeight)

			if nextLocation.location + duration.value > length {
				continue
			}

			let previousNotes = noteEvents.notes(at: location, of: .chord)

			if !previousNotes.isEmpty {
				let note = previousNotes[Int.random(in: 0...previousNotes.count - 1)]
				noteEvents.append(NoteEvent(notes: [.melody: note], location: nextLocation.location))
			} else {
				let note = randomNote(duration: duration)
				noteEvents.append(NoteEvent(notes: [.melody: note], location: nextLocation.location))
			}

			location = duration.value + nextLocation.location
		}
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
			let duration = randomDuration(for: nextLocation, weights: DurationWeight.melodyWeight)

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

	func randomDuration(for location: NoteLocation, weights: DurationWeight) -> NoteDuration {
		if let duration = location.nextDuration {
			return duration
		}

		return NoteDuration.random(slowest: slowest, fastest: fastest, weights: weights)
	}

    func randomNote(duration: NoteDuration) -> Note {
        var foundNewNote = false
        var newNote: Note!

        while !foundNewNote {
            let rand = scale.randomToneIndex
            let variation = scale.variation[rand] ?? .natural

			newNote = Note(value: scale.tones[rand], scaleTone: rand, duration: duration, variation: variation, octave: randomOctave)

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
				addChord(for: note, at: event.location)
            }
        }
    }
    
    private func generateHarmonyAll() {
        for event in noteEvents {
            if let note = event.notes[.melody] {
				addChord(for: note, at: event.location)
            }
        }
    }
    
    private func generateHarmonyDownbeat() {
        var location: Double = 0
        
        while location < length {
            let event = noteEvents.lastEvent(atOrBefore: location)
            
            if let note = event?.notes[.melody] {
				addChord(for: note, at: location)
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

			newNote = Note(value: scale.tones[rand], scaleTone: rand, duration: note.duration, variation: variation, octave: 2)

            //RULE: We don't want the next note to be 1, 6 or 11 semitones apart from the last.
            let isAtBadInterval = newNote.isAt(interval: [0, 1, 2, 6, 11], to: note)

            foundNewNote = !isAtBadInterval
        }

        addBass(note: newNote, location: location)
    }

	private func addChord(for melodyNote: Note, at location: Double) {
		let rootTone = chordProgression.chords.last!.root
		let note = Note(value: rootTone, scaleTone: scale.tones.firstIndex(of: rootTone)!, duration: melodyNote.duration, octave: 2)
		noteEvents.append(NoteEvent(notes: [.bass: note], location: location))

		for tone in chordProgression.chords.last!.valueBySemiTone {
			let note = Note(value: tone, scaleTone: scale.tones.firstIndex(of: tone)!, duration: melodyNote.duration, octave: 4)
			noteEvents.append(NoteEvent(notes: [.melody: note], location: location))
		}

		chordProgression.addCalculatedChord()
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

			newNote = Note(value: scale.tones[rand], scaleTone: rand, duration: note.duration, variation: variation, octave: 3)
            //RULE: We want a member of a scale to go with our melody note
            let isAtGoodInterval = newNote.isAt(interval: [4, 5, 7], to: note)

            foundNewNote = isAtGoodInterval
        }

        addBass(note: newNote, location: location)
    }

    private func addBass(note: Note, location: Double) {
		if let event = noteEvents.first(where: { $0.location == location }) {
            event.notes[.bass] = note
        } else {
            noteEvents.append(NoteEvent(notes: [.bass: note], location: location))
        }
    }
}
