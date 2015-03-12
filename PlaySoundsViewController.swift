//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Greybear on 3/4/15.
//  Copyright (c) 2015 Infinite Loop, LLC. All rights reserved.
//
// 3-10-15 - Added code to make sure sound doesn't overlap inappropriately when multiple buttons are pushed.

import UIKit
import AVFoundation

var audioEngine:AVAudioEngine!
var audioFile:AVAudioFile!


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine=AVAudioEngine()
        audioFile=AVAudioFile(forReading: receivedAudio.filePath, error: nil)
        //Init the audioplayer object using the filepath passed in from the previous View
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePath, error: nil)
        //Allow the rate to be set by the user via button
        audioPlayer.enableRate=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        resetAudioEngine()
        audioPlayer.currentTime=0.0
        audioPlayer.rate=0.5
        audioPlayer.play()
    }

    @IBAction func playFastSound(sender: UIButton) {
        resetAudioEngine()
        audioPlayer.currentTime=0.0
        audioPlayer.rate=2.0
        audioPlayer.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        resetAudioEngine()
    }
    
    @IBAction func playChipMunkSound(sender: UIButton) {
        resetAudioEngine()
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderSound(sender: UIButton) {
        resetAudioEngine()
        playAudioWithVariablePitch(-500)
    }
  

    @IBAction func playReverbSound(sender: UIButton) {
        resetAudioEngine()
        playAudioWithReverb(50)
    }
    
    //GB - 3/11/15 - Create a reuseable method to stop/reset the audio engine
    func resetAudioEngine(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch:Float){
        //Make sure the player is ready
        resetAudioEngine()
        
        var audioPlayerNode=AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect=AVAudioUnitTimePitch()
        changePitchEffect.pitch=pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format:nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    func playAudioWithReverb(mix:Float){
        //Make sure the player is ready
        resetAudioEngine()
        
        var audioPlayerNode=AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeReverbEffect=AVAudioUnitReverb()
        changeReverbEffect.wetDryMix=mix
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
  }
