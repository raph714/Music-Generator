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
        
        sequencer?.tempo = composition.tempo
        sequencer?.overriddenSequenceLength = composition.length
        sequencer?.shouldLoop = true
        sequencer?.startPlayback()
    }
    
    private func addNotes(in array: [Note], to track: MIKMIDITrack) {
        for note in array {
            guard let value = note.renderedValue,
                let location = note.location,
                let duration = note.duration else {
                continue
            }
            
            let event = MIKMIDINoteEvent(timeStamp: location,
                                         note: value,
                                         velocity: 65,
                                         duration: Float32(duration.value),
                                         channel: 0)
            track.addEvent(event)
        }
    }
    
    func stop() {
        sequencer?.stop()
    }
}
