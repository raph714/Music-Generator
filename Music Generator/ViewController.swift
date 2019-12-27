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
    @IBOutlet weak var restType: NSPopUpButton!

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
        composeAndPlay(scale: Scale.twelveTone)
    }
    
    @IBAction func playMajor(sender: Any) {
        composeAndPlay(scale: Scale.major)
    }
    
    @IBAction func playMinor(sender: Any) {
        composeAndPlay(scale: Scale.minor)
    }
    
    private func composeAndPlay(scale: Scale) {
        textField.stringValue = ""
        composition.scale = scale
        
        if let accompanyment = accompanymentPopupButton.selectedItem?.identifier?.rawValue,
            let accVal = AccompanymentType(rawValue: accompanyment) {
            composition.accompanymentType = accVal
        }
        
        
        if let rest = restType.selectedItem?.identifier?.rawValue,
            let restVal = Rests(rawValue: rest){
            composition.restAmount = restVal
        }
        
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

