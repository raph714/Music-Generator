//
//  TimeSignature.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/25/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Foundation

/// Represents a
struct TimeSignature {
    let beats: Int
    let duration: NoteDuration
    
    static var fourFour: TimeSignature {
        return TimeSignature(beats: 4, duration: .quarter)
    }
    
    static var fiveEight: TimeSignature {
        return TimeSignature(beats: 5, duration: .eighth)
    }
    
    var valuePerMeausure: Double {
        return Double(beats) * duration.value
    }
}
