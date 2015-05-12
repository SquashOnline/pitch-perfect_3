//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Benjamin Uliana on 2015-04-05.
//  Copyright (c) 2015 SquashOnline. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingProgress: UILabel!
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var startRecording: UIButton!
    
    
    //DECLARED GLOABALLY
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopRecording.hidden = true
    }
        //OPERATION: BUTTON OPERATION RECORD
    @IBAction func recordAudio(sender: UIButton) {
        stopRecording.hidden = false
        startRecording.hidden = true
        recordingProgress.hidden = false
        tapToRecord.hidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
                
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
        //OPERATION: ASSIGN TITLE INFO TO AUDIO RECORDING
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title:recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("recodring was not successful")
            startRecording.enabled = true
            stopRecording.hidden = true
        }
    }
    
        //OPERATION: SEGUE TO AUDIO PLAY BACK
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as!  PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
        //OPERATION: BUTTON OPERATION STOP
    @IBAction func stopButton(sender: UIButton) {
        recordingProgress.hidden = true
        stopRecording.hidden = true
        startRecording.hidden = false
        tapToRecord.hidden = false
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
    }

}

