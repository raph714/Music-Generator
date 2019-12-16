//
//  MusicBox.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation
import AudioToolbox
import AudioKit

class MusicBox {
    let oscBank = AKOscillatorBank()
    var sequencer: AKSequencer!
    var midi: AKMIDI!
    
    init() {
        oscBank.attackDuration = 0.05
        oscBank.decayDuration = 0.1
        oscBank.sustainLevel = 1.0
        oscBank.releaseDuration = 0.3
    }

    func play(composition: Composition) {
        stop()
        sequencer = AKSequencer()
        midi = AKMIDI()

        let midiNode = AKMIDINode(node: oscBank)
        
        _ = sequencer.addTrack(for: midiNode)
        sequencer.length = 0.0
        sequencer.tracks[0].clear()
        
        for event in composition.melody {
            sequencer.tracks[0].add(noteNumber: event.note.value(at: 5),
                velocity: 65,
                position: event.location,
                duration: event.duration.value)
            sequencer.length += event.duration.value
        }
        
        for event in composition.harmony {
            sequencer.tracks[0].add(noteNumber: event.note.value(at: 4),
                                    velocity: 65,
                                    position: event.location,
                                    duration: event.duration.value)
        }
        
        AudioKit.output = midiNode
        try! AudioKit.start()
        midiNode.enableMIDI(midi.client, name: "midiNode midi in")
        sequencer.tempo = 72
        sequencer.loopEnabled = true
        sequencer.play()
    }
    
    func stop() {
        try! AudioKit.stop()
    }
}
