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
        stopPlayBack()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        //Define the pitch of the pitch modulating function
        let modifyAudioPitch = AVAudioUnitTimePitch()
        modifyAudioPitch.pitch = 1000
        playAudioWithEffects(modifyAudioPitch)
        
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        let modifyAudioPitch = AVAudioUnitTimePitch()
        modifyAudioPitch.pitch = -1000
        playAudioWithEffects(modifyAudioPitch)
    }
    
    @IBAction func rippleButton(sender: AnyObject) {
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.5
        playAudioWithEffects(echoEffect)
    }
    
    @IBAction func stopCurrentAudio(sender: AnyObject) {
        stopPlayBack()
    }
    @IBAction func reverbButton(sender: AnyObject) {
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 75
        playAudioWithEffects(reverbEffect)
        
    }
    
    func stopPlayBack(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithEffects(audioEffect: AVAudioUnit){
        //Stop playback before executing audio with effects
        stopPlayBack()
        
        //Create an instance of AVAduioPlayerNode
        let audioEffectsPlayerNode = AVAudioPlayerNode()
        
        //Attach node to AudioEngine
        audioEngine.attachNode(audioEffectsPlayerNode)
        
        //Attach node audioEffect in order to define effect type in mutiple Actions
        audioEngine.attachNode(audioEffect)
        
        //Connect AVAdudioPlayerNode to audioEffect node
        audioEngine.connect(audioEffectsPlayerNode, to: audioEffect, format: nil)
        //Connect AVAudioUnit to audioEngine
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: nil)
        
        //Select file which will be played back
        audioEffectsPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

        //Start the audio
        try! audioEngine.start()
        //Start the AVAudioPlayerNode
        audioEffectsPlayerNode.play()
    }
}
