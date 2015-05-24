//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sulaiman Azhar on 22.11.14.
//  Copyright (c) 2014 Kazmi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseToggle: UIButton!
    
    var audioRecorer:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    var paused:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        pauseToggle.hidden = true
        recordButton.enabled = true
        resetPauseButton()
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        recordingInProgress.hidden = false
        stopButton.hidden = false
        pauseToggle.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Initialize and prepare the recorder
        audioRecorer = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorer.delegate = self
        audioRecorer.meteringEnabled = true
        audioRecorer.prepareToRecord()
        audioRecorer.record()
        
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        recordingInProgress.hidden = true;
        stopButton.hidden = true
        pauseToggle.hidden = true
        recordButton.enabled = true
        
        audioRecorer.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive((false), error: nil)
    }
    
    @IBAction func pauseRecordingAudio(sender: UIButton) {
        if (paused == true) {
            recordingInProgress.text = "recording"
            audioRecorer.record()
            
            var pauseImage = UIImage(named: "pause")
            pauseToggle.setImage(pauseImage, forState: .Normal)
            paused = false
        } else {
            recordingInProgress.text = "paused"
            audioRecorer.pause()
            
            var resumeImage = UIImage(named: "resume")
            pauseToggle.setImage(resumeImage, forState: .Normal)
            paused = true
        }
        
    }
    
    func resetPauseButton() {
        paused = false;
        recordingInProgress.text = "recording"
        var pauseImage = UIImage(named: "pause")
        pauseToggle.setImage(pauseImage, forState: .Normal)
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(url: recorder.url, text: recorder.url.lastPathComponent);
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            pauseToggle.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

