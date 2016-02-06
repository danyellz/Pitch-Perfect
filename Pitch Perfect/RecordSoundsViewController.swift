//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by TY on 2/1/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    @IBOutlet var newView: UIView!
    @IBOutlet weak var audioStatus: UILabel!
    @IBOutlet var tapToRecord: UILabel!
    @IBOutlet var stopAudio: UIButton!
    @IBOutlet var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        audioStatus.hidden = true
        stopAudio.hidden = true
        tapToRecord.textColor = getRandomColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Do setup for views such as mic button and hiding audioStatus label
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopAudio.hidden = true
        audioStatus.hidden = true
        tapToRecord.hidden = false
        tapToRecord.alpha = 1
        
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //Disable microphone button when record button is pressed
        //Enable/make stop button visible
        //Hide tapToRecord label
        
        recordButton.enabled = false
        audioStatus.hidden = false
        tapToRecord.hidden = true
        stopAudio.hidden = false
        
        //Create a storage location of new audio recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Utilize device date and time as name of new recording
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        
        //File path created from storage location and name
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print (filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do{
            //Found this implemetation of AVAudiosessionPortOverride due to quietness during playback
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        }catch{
            print("could not set output to speaker")
        }
        
        //Pass this audio to next view when audioRecorderDidFinishRecording is executed
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    override func viewDidAppear(animated: Bool) {
        //Created an animation to draw attention to record button
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(),{
        self.performAnimation()
        })
    }
    
    func performAnimation(){
        UIView.animateWithDuration(1, delay: 0.25, options: .Repeat, animations: {
            self.tapToRecord.alpha = 0.0
            self.audioStatus.alpha = 0.0
            },completion: nil)
    }
    
    //Generate random text color
    func getRandomColor() -> UIColor{
        
        let newRed:CGFloat = CGFloat(drand48())
        let newGreen:CGFloat = 0
        let newBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    //Boolean flag can be used for if statement to prove if successful
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool){
        if(flag){
            //Save the recorded audio name and url and store in ReocordedAudio NSObject
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender:recordedAudio)//Perform segue if recorded successfully
        }else{
            //prints error if audio save was unsuccessful
            print("recording was unsuccessful...")
            recordButton.enabled = true;
            stopAudio.hidden = true
        }
    }
    //Pass data to the PlaySoundsViewController before segue occurs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
    
        }else{
            print("unsuccessful segue")
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordButton.enabled = true
        audioStatus.hidden = true
        stopAudio.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
}

