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
        
        addNotes(in: composition.melody, to: track)
        addNotes(in: composition.harmony, to: track)
        
        sequencer?.shouldLoop = true
        sequencer?.startPlayback()
    }
    
    private func addNotes(in array: [Note], to track: MIKMIDITrack) {
        var position: Double = 0
        for note in array {
            guard let value = note.value else {
                position += note.duration.value
                continue
            }
            
            let event = MIKMIDINoteEvent(timeStamp: position,
                                         note: value,
                                         velocity: 65,
                                         duration: Float32(note.duration.value),
                                         channel: 0)
            track.addEvent(event)
            position += note.duration.value
        }
    }
    
    func stop() {
        sequencer?.stop()
    }
}
