//
//  NoteTests.swift
//  Music GeneratorTests
//
//  Created by Raphael DeFranco on 3/14/20.
//  Copyright © 2020 defranco. All rights reserved.
//

import XCTest
@testable import Music_Generator

class NoteTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoteMoveTo() {
        // first test that the notes don't change if they are close.
        let note1 = Note(value: 10, scaleTone: 1, duration: .eighth, octave: 1)
        let note2 = Note(value: 10, scaleTone: 1, duration: .eighth, octave: 2)

        let rendered = note1.renderedValue

        note1.moveTo(within: 12, of: note2)

        XCTAssertEqual(rendered, note1.renderedValue)

        //now let's see it move down.
        let note3 = Note(value: 11, scaleTone: 1, duration: .eighth, octave: 3)

        note1.moveTo(within: 12, of: note3)
        XCTAssertEqual(note1.renderedValue, 46)

        let note4 = Note(value: 2, scaleTone: 1, duration: .eighth, octave: 1)
        let note5 = Note(value: 10, scaleTone: 1, duration: .eighth, octave: 3)

        note5.moveTo(within: 12, of: note4)
        XCTAssertEqual(note1.renderedValue, 46)
    }

    func testIsAtInterval() {
        let note1 = Note(value: 1, scaleTone: 1, duration: .eighth, octave: 1)
        let note2 = Note(value: 7, scaleTone: 1, duration: .eighth, octave: 1)

        XCTAssertEqual(note1.isAt(interval: 6, to: note2), true)

        let note3 = Note(value: 1, scaleTone: 1, duration: .eighth, octave: 1)
        let note4 = Note(value: 7, scaleTone: 1, duration: .eighth, octave: 4)

        XCTAssertEqual(note3.isAt(interval: 6, to: note4), true)

        let note5 = Note(value: 1, scaleTone: 1, duration: .eighth, octave: 1)
        let note6 = Note(value: 7, scaleTone: 1, duration: .eighth, octave: 1)

        XCTAssertEqual(note5.isAt(interval: 3, to: note6), false)
    }
}
