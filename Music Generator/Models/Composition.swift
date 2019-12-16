//
//  Composition.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/10/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

struct NoteEvent {
    let note: Note
    let location: Double
    let duration: NoteDuration
}

protocol CompositionDelegate: AnyObject {
    func willAdd(note: Note, duration: NoteDuration)
}

class Composition {
    var melody = [NoteEvent]()
    var harmony = [NoteEvent]()
    
    var delegate: CompositionDelegate?
    
    let slowest: NoteDuration = .half
    let fastest: NoteDuration = .eighth
    
    func reset() {
        melody.removeAll()
        harmony.removeAll()
    }
    
    func compose(with scale: Scale) {
        let randomNotes = scale.randomized()
        
        var location: Double = 0
        
        for index in 0...randomNotes.count-1 {
            let noteValue = randomNotes[index]
            let duration = NoteDuration.random(slowest: slowest, fastest: fastest)

            delegate?.willAdd(note: noteValue, duration: duration)
            
            let event = NoteEvent(note: noteValue, location: location, duration: duration)
            melody.append(event)
            
            
            if location == 0 {
                let root = scale.root(for: event.note)
                let hevent = NoteEvent(note: root, location: event.location, duration: duration)
                harmony.append(hevent)
            } else if duration == slowest {
                let root = scale.root(for: event.note)
                let hevent = NoteEvent(note: root, location: event.location, duration: slowest)
                harmony.append(hevent)
            }
            
            location += duration.value
        }
    }
}
