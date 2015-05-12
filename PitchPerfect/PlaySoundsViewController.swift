//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Benjamin Uliana on 2015-04-08.
//  Copyright (c) 2015 SquashOnline. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
        //GLOBAL VARIABLES
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
    }
        //OPERATION: BUTTONS
    @IBAction func slowRecording(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func fastRecording(sender: UIButton) {
        playAudioWithVariableRate(1.5)
        
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-750)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        prepareAudioEngine()
    }

        //FUNCTIONS:
    func playAudio (){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func prepareAudioEngine () {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariableRate (rate: Float) {
        prepareAudioEngine()
        audioPlayer.rate = rate
        playAudio()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        prepareAudioEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil);
        
        audioPlayerNode.play()
    }
}
