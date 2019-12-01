//
//  ViewController.swift
//  Music Generator
//
//  Created by Raphael DeFranco on 12/1/19.
//  Copyright © 2019 defranco. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    @IBOutlet weak var textField: NSTextField!

    private var musicBox: MusicBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        musicBox = MusicBox()
        musicBox.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func playTwelveNote(sender: Any) {
        textField.stringValue = ""
        musicBox.playRandomMusic(with: Scale.twelveTone)
    }
    
    @IBAction func playMajor(sender: Any) {
        textField.stringValue = ""
        musicBox.playRandomMusic(with: Scale.major)
    }
}

extension ViewController: MusicBoxDelegate {
    func willAdd(note: Note, duration: NoteDuration) {
        textField.stringValue.append(contentsOf: "\(note.letter), \(duration)\n")
    }
}

