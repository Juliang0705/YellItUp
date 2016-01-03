//
//  Microphone.swift
//  Yell it Up
//
//  Created by Juliang Li on 10/10/15.
//  Copyright (c) 2015 Hackthon. All rights reserved.
//

import Foundation
import AVFoundation

class Microphone: NSObject, AVAudioRecorderDelegate{
    var recorder: AVAudioRecorder!
    var soundFileURL:NSURL?
    override init(){
        super.init()
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
       // print(currentFileName)
        
        let documentsDirectory: AnyObject = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:UInt32(kAudioFormatAppleLossless)),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        var error: NSError?
        recorder = AVAudioRecorder(URL: soundFileURL, settings: recordSettings,error: &error)
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
    }
    func startRecording() -> Void {
        recorder.record()
    }
    func pauseRecording() ->Void{
        recorder.pause()
    }
    func isRecording() -> Bool{
        return recorder.recording
    }
    func stopRecording() -> Void{
        recorder.stop()
    }
    func isPeakWithinRange(Max max:Float,Min min:Float) -> Bool{
        recorder.updateMeters()
        var peak = recorder.peakPowerForChannel(0)
        if (peak <= max) && (peak >= min){
            return true
        }else {
            return false
        }
    }
    func isPeakHigherThan(value:Float) -> Bool{
        recorder.updateMeters()
        var peak = recorder.peakPowerForChannel(0)
        if peak >= value {
            return true
        }else{
            return false
        }
    }
    func getPeakValue() -> Float {
        return recorder.peakPowerForChannel(0)
    }
    deinit{
        recorder.stop()
        if recorder.deleteRecording(){
            println("Successfully delete audio")
        }else{
            println("Audio deletion fails")
        }
    }
}