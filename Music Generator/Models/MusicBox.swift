//
//  MusicBox.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation
import AudioToolbox

protocol MusicBoxDelegate: AnyObject {
    func willAdd(note: Note, duration: NoteDuration)
}

struct MusicBox {
    weak var delegate: MusicBoxDelegate?

    func playRandomMusic(with scale: Scale) {
        var sequence : MusicSequence? = nil
        NewMusicSequence(&sequence)

        var track : MusicTrack? = nil
        var musicTrack = MusicSequenceNewTrack(sequence!, &track)

        // Adding notes
        var time = MusicTimeStamp(1.0)

        let randomNotes = scale.randomized()
        
        for index in 0...randomNotes.count-1 {
            let noteValue = randomNotes[index]
            let duration = NoteDuration.random(slowest: .half, fastest: .sixteenth)

            delegate?.willAdd(note: noteValue, duration: duration)

            var note = MIDINoteMessage(channel: 0,
                                       note: noteValue.value(at: 5),
                                       velocity: 64,
                                       releaseVelocity: 0,
                                       duration: duration.floatValue )

            musicTrack = MusicTrackNewMIDINoteEvent(track!, time, &note)
            time += duration.value
        }

        // Creating a player

        var musicPlayer : MusicPlayer? = nil
        var player = NewMusicPlayer(&musicPlayer)

        player = MusicPlayerSetSequence(musicPlayer!, sequence)
        player = MusicPlayerStart(musicPlayer!)
    }
}
