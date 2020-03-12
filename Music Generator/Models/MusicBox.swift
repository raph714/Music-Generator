//
//  MusicBox.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation
import MIKMIDI

class MusicBox {
    private var sequencer: MIKMIDISequencer?
    
    init() {
    }

    func play(composition: Composition) {
        stop()
        
        let sequence = MIKMIDISequence()
        let track = try! sequence.addTrack()
        sequencer = MIKMIDISequencer(sequence: sequence)
        
        addNotes(in: composition.noteEvents, to: track)
        
        sequencer?.tempo = composition.tempo
        sequencer?.overriddenSequenceLength = composition.length
        sequencer?.shouldLoop = true
        sequencer?.startPlayback()
    }
    
    private func addNotes(in array: [NoteEvent], to track: MIKMIDITrack) {
        for event in array {
            event.notes.forEach { _, note in
                add(note: note, to: track, location: event.location)
            }
        }
    }
    
    private func add(note: Note, to track: MIKMIDITrack, location: Double) {
        guard let value = note.renderedValue,
            let duration = note.duration else {
                fatalError(String(describing: note))
        }
        
        let event = MIKMIDINoteEvent(timeStamp: location,
                                     note: value,
                                     velocity: 65,
                                     duration: Float32(duration.value),
                                     channel: 0)
        track.addEvent(event)
    }
    
    func stop() {
        sequencer?.stop()
    }
}
