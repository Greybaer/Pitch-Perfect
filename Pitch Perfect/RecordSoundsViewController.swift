//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Greybear on 3/3/15.
//  Copyright (c) 2015 Infinite Loop, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    //flag to determine the state of the pause button
    var paused:Bool!
    
    @IBOutlet weak var recordinginProgress: UILabel!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(animated: Bool) {
        //Default the stop button to hidden
        stopBtn.hidden=true
        //Make sure the button contains the correct text
        recordinginProgress.text="Tap to Record"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func RecordAudo(sender: UIButton) {
        //Show Text to indicate recording in progress
        recordinginProgress.text="Recording in Progress"
        
        //Show the stop and pause buttons
        stopBtn.hidden=false
        pauseBtn.hidden=false
        //And set the flag to false as we're not currently paused
        paused=false
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //File name is the datestamp.wav
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        //Build the ful path to the sound file
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
  
        //Instance an AVAudioSession
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //This View Controller is responsible for setting up the audio session and recording the file.
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    //When the recording is finished, grab the filepath and name of the sound file and get ready to pass it to the Play Sounds View Controller
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //GB - 3/11/15 Changed creation to utilize constructor init method
            recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("Recording not successful")
            stopBtn.hidden=true
        }

    }
    
    //Before actually changing views, create a new instance of the Plays Sounds View Controller so we can pass the data to it. Then populate the audio property with the file we recorded.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
        let PlaySoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
        let data = sender as RecordedAudio
            PlaySoundsVC.receivedAudio = data
        }
    }
    
    //GB - Added a new function to pause and re-enable recording without losing data
    @IBAction func pauseRecording(sender: UIButton) {
       //What's the current image of the button?
       if paused == false{  //user wants to pause recording
            //Change the button to record
            pauseBtn.setImage(UIImage(named:"record.png"), forState: UIControlState.Normal)
            //Pause the recorder
            audioRecorder.pause()
            //Change text to show pause
            recordinginProgress.text="Paused"
            paused=true
            }
        else{               //user wants to re-start recording
            //Button back to pause
            pauseBtn.setImage(UIImage(named:"pause.png"), forState: UIControlState.Normal)
            //Re-start recording
            audioRecorder.record()
            //...and change the text back
            recordinginProgress.text="Recording in Progress"
            paused=false
        }
        
    }
    @IBAction func stopRecording(sender: UIButton) {
        //hide the stop button and the pause button
        stopBtn.hidden=true
        pauseBtn.hidden=true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
 }

