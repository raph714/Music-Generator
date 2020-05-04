//
//  NoteEvent.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 3/11/20.
//  Copyright © 2020 defranco. All rights reserved.
//

import Foundation

class NoteEvent {
    enum NoteType {
        case melody
		case chord
        case bass
    }
    
    var notes: [NoteType: Note]
    let location: Double
    
    init(notes: [NoteType: Note], location: Double) {
        self.notes = notes
        self.location = location
    }

	var description: String {
		var desc = ""
		for (type, note) in notes {
			desc += "\(type)"
			desc += " \(String(describing: note.renderedValue?.letter ?? "rest")) "
			desc += "at \(location)"
		}

		return desc
	}
}

extension NoteEvent: Equatable {
    static func == (lhs: NoteEvent, rhs: NoteEvent) -> Bool {
        return lhs.notes == rhs.notes && lhs.location == rhs.location
    }
}

extension Array where Element == NoteEvent {
    /// Returns array sorted earliest to latest location
    var sorted: [NoteEvent] {
        return self.sorted(by: { $0.location < $1.location })
    }
    
    var lastEvent: NoteEvent? {
        return sorted.last
    }
    
    func event(before event: NoteEvent) -> NoteEvent? {
        let sorted = self.sorted
        guard let index = sorted.firstIndex(where: { $0 == event }), index > 0 else {
            return nil
        }
        
        if index == 0 {
            return nil
        }

        return sorted[index - 1]
    }
    
	func notes(at location: Double, of type: NoteEvent.NoteType) -> [Note] {
		let notesAtLocation = filter({ $0.location == location })

		return notesAtLocation.compactMap({ $0.notes[type] })
    }
    
    func lastEvent(atOrBefore location: Double) -> NoteEvent? {
        let sorted = self.sorted
        
        guard let index = sorted.firstIndex(where: { $0.location >= location }) else {
            return nil
        }
        
        if sorted[index].location > location, index > 0 {
            return sorted[index - 1]
        }
        
        return sorted[index]
    }
}
