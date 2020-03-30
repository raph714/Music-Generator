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
    @IBOutlet weak var accompanymentPopupButton: NSPopUpButton!
    @IBOutlet weak var scaleTypePopup: NSPopUpButton!
    @IBOutlet weak var restTypePopup: NSPopUpButton!
    @IBOutlet weak var slowestNotePopup: NSPopUpButton!
    @IBOutlet weak var fastestNotePopup: NSPopUpButton!
    @IBOutlet weak var tempoTextField: NSTextField!
    @IBOutlet weak var barsTextField: NSTextField!
    @IBOutlet weak var maxMelodyDistance: NSTextField!
    
    @IBOutlet weak var timeSignatureBeats: NSTextField!
    @IBOutlet weak var timeSignatureDurationPopup: NSPopUpButton!

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
    
    @IBAction func play(sender: Any) {
        textField.stringValue = ""
        
        if let scaleString = scaleTypePopup.selectedItem?.identifier?.rawValue,
            let scale = ScaleType(rawValue: scaleString) {
            composition.scale = scale.value
        }
        
        if let slowest: Int = slowestNotePopup.selectedItem?.tag,
            let duration = NoteDuration(rawValue: slowest) {
            composition.slowest = duration
        }
        
        if let fastest: Int = fastestNotePopup.selectedItem?.tag,
            let duration = NoteDuration(rawValue: fastest) {
            composition.fastest = duration
        }
        
        if let signatureDuration: Int = timeSignatureDurationPopup.selectedItem?.tag,
            let duration = NoteDuration(rawValue: signatureDuration) {
            composition.timeSignature = TimeSignature(beats: timeSignatureBeats.integerValue, duration: duration)
        }
        
        if let accompanyment = accompanymentPopupButton.selectedItem?.identifier?.rawValue,
            let accVal = AccompanymentType(rawValue: accompanyment) {
            composition.accompanymentType = accVal
        }
        
        composition.tempo = tempoTextField.doubleValue
        composition.totalMeasures = barsTextField.integerValue
        composition.maxMelodyDistance = maxMelodyDistance.integerValue
        composition.reset()
        composition.compose()
        musicBox.play(composition: composition)
    }
    
    @IBAction func stop(sender: Any) {
        musicBox.stop()
    }
}

extension ViewController: CompositionDelegate {
    func didAdd(events: [NoteEvent]) {
        for event in events.sorted {
            let melody = event.notes[.melody]
            let bass = event.notes[.bass]

            var msg = "Melody: \(melody?.renderedValue?.letter ?? "rest")"
            if let dur = melody?.duration {
                msg.append(" \(dur)")
            }
            
            msg.append(", Harmony: \(bass?.renderedValue?.letter ?? "rest")")
            if let dur = bass?.duration {
                msg.append(" \(dur)")
            }

			textField.stringValue.append(contentsOf: "\(msg), Location: \(event.location)\n")
        }
    }
}

