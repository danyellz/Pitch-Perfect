//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by TY on 2/2/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet var slowButton: UIButton!
    @IBOutlet var fastButton: UIButton!
    @IBOutlet var stopAudio: UIButton!
    @IBOutlet var playChipmunkAudio: UIButton!
    @IBOutlet var playDarthVaderAudio: UIButton!
    @IBOutlet var rippleButton: UIButton!
    @IBOutlet var reverbButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Import audio file for slow/fast
        audioPlayer = try! AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        //Import previously recorded audio .wav for AVAudioEngine
        audioFile = try! AVAudioFile(forReading: recievedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func slowAudio(sender: UIButton) {
        print("slowing down...")
        playSoundAtVariousSpeed(0.9)
    }
    @IBAction func speedAudio(sender: UIButton) {
        print("speeding up...")
        playSoundAtVariousSpeed(2)
    }
    
    //Was previsouly effectsWithVariableSpeeds, should have named it differently but it is fixed in previous commmit
    func playSoundAtVariousSpeed(speed: Float){
        self.stopPlayBack()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        //Define the pitch of the pitch modulating function
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func rippleButton(sender: AnyObject) {
        self.playAudioWithDelay()
    }
    
    @IBAction func stopCurrentAudio(sender: AnyObject) {
        self.stopPlayBack()
    }
    @IBAction func reverbButton(sender: AnyObject) {
        self.playAudioWithReverb()
        
    }
    
    func stopPlayBack(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    //Function to change pitch of audio .wav audio created in previous view
    func playAudioWithVariablePitch(pitch: Float){
        
        self.stopPlayBack()
        
        //Attach audioPlayerNode to audioEngine
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Attach the pitch effect modulation to audioEngine
        let changePitchEfect = AVAudioUnitTimePitch()
        changePitchEfect.pitch = pitch
        audioEngine.attachNode(changePitchEfect)
        
        //Connect audioPlayerNode to changePitchEffect
        audioEngine.connect(audioPlayerNode, to: changePitchEfect, format: nil)
        
        //Create an outlet of the modified pitch to speakers--outputNode
        audioEngine.connect(changePitchEfect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        //Begin audioEngine modifier
        try! audioEngine.start()
        audioPlayerNode.play()
        
    }
    
    func playAudioWithDelay(){
        self.stopPlayBack()
        
        let delayPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(delayPlayerNode)
        
        let delay = AVAudioUnitDelay()
        delay.delayTime = (0.5)
        audioEngine.attachNode(delay)
        
        audioEngine.connect(delayPlayerNode, to: delay, format: nil)
        
        audioEngine.connect(delay, to: audioEngine.outputNode, format: nil)
        
        delayPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        delayPlayerNode.play()
    }
    
    func playAudioWithReverb(){
        
        self.stopPlayBack()
        
        let reverbPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(reverbPlayerNode)
        
        let reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 75
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(reverbPlayerNode, to: reverb, format: nil)
        
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        reverbPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        reverbPlayerNode.play()
    }
}
