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
    private var composition: Composition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        musicBox = MusicBox()
        composition = Composition()
        composition.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func playTwelveNote(sender: Any) {
        textField.stringValue = ""
        composition.scale = Scale.twelveTone
        composeAndPlay()
    }
    
    @IBAction func playMajor(sender: Any) {
        textField.stringValue = ""
        composition.scale = Scale.major
        composeAndPlay()
    }
    
    private func composeAndPlay() {
        composition.reset()
        composition.compose()
        musicBox.play(composition: composition)
    }
    
    @IBAction func stop(sender: Any) {
        musicBox.stop()
    }
}

extension ViewController: CompositionDelegate {
    func willAdd(note: Note) {
        textField.stringValue.append(contentsOf: "\(note.value?.letter ?? "rest"), \(note.duration)\n")
    }
}

