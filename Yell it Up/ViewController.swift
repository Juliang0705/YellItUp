//
//  ViewController.swift
//  Yell it Up
//
//  Created by Juliang Li on 10/9/15.
//  Copyright (c) 2015 Hackthon. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    var recorder: Microphone!
    var timer: NSTimer!
    var spf = 1.0/27.0 // second per frame
   //...collision
    var dog: UIImageView!
    var topBoundary: Boundary!
    var bottomBoundary: Boundary!
    var brick: Obstacle!
    //...collision
    @IBOutlet var highestLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    var acceleration:Int = 0
    var accelerationFactor:Float = 0.0
    var randomHeight:CGFloat!
    var score:Int = 0
    var scoreUpdated:Bool = false
    var explosion:UIImageView!
    var highestScore:Int = 0
    var audioPlayer:AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        self.setUp()
    }
    func setUp() -> Void {
        recorder = Microphone()
        dog = UIImageView(image: UIImage(named: "dog.png"))
        dog.frame = CGRectMake(100, 200,50,50)
        topBoundary = Boundary(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50))
        bottomBoundary = Boundary(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 50, UIScreen.mainScreen().bounds.width, 50))
        randomHeight = CGFloat(Int(arc4random_uniform(450))+50);
        brick = Obstacle(frame: CGRectMake(UIScreen.mainScreen().bounds.width, randomHeight, 50, 150))
        explosion = UIImageView(image: UIImage(named: "boom.png"))
        explosion.frame = CGRectMake(-200, -200, 100, 100)   // out of view
        audioPlayer = AVAudioPlayer()
        self.view.addSubview(brick)
        self.view.addSubview(topBoundary)
        self.view.addSubview(bottomBoundary)
        self.view.addSubview(dog)
        self.view.addSubview(explosion)
        highestLabel.text = "Highest: \(highestScore)"
        timer = NSTimer.scheduledTimerWithTimeInterval(self.spf, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    func restartTheGame() -> Void{
        dog.frame = CGRectMake(100, 200,50,50)
        randomHeight = CGFloat(Int(arc4random_uniform(450))+50);
        brick.frame = CGRectMake(UIScreen.mainScreen().bounds.width, randomHeight, 50, 150)
        explosion.frame = CGRectMake(-200, -200, 100, 100)
        score = 0
        acceleration = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(self.spf, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    func collisionDetection() -> Bool{
        if dog.frame.intersects(topBoundary.frame) ||
           dog.frame.intersects(bottomBoundary.frame) ||
            dog.frame.intersects(brick.frame){
                return true
        }else{
            return false
        }
    }
    func updateScore() -> Void{
        if (brick.frame.origin.x > dog.frame.origin.x){
            scoreUpdated = false
        }
        if (brick.frame.origin.x < dog.frame.origin.x && !self.scoreUpdated){
            ++self.score
            self.scoreUpdated = true
        }
        scoreLabel.text = "Score: \(self.score)"
        if score > highestScore{
            highestScore = score
            highestLabel.text = "Highest: \(highestScore)"
        }
        scoreLabel.setNeedsDisplay()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func playSound()->Void{
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bomb", ofType: "wav")!)
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    func gameOver(){
        var message:String!
        if score < 5 {
            message = "Congratulations, Freshman."
        }else if score < 10 {
            message = "You're ok as a sophomore."
        }else if score < 15 {
            message = "You're a junior! One more year!"
        }else if score < 20 {
            message = "Welcome, senior! 🐂"
        }else {
            message = "YOU ARE A YELL LEADER CANDIDATE!"
        }
        var popWindow = UIAlertController(title: "You crashed Reveille :(", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        popWindow.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default, handler: {alertAction in
                self.restartTheGame()
            }))
        popWindow.addAction(UIAlertAction(title: "Go Back", style: UIAlertActionStyle.Default, handler: {alertAction in
            self.recorder.stopRecording()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        playSound()
        self.presentViewController(popWindow, animated: true, completion: nil)
    }
    func update(){
        recorder.startRecording()
        if recorder.isPeakWithinRange(Max: 200, Min: -25){
            acceleration -= 1
            var yPosition = CGFloat(Float(dog.frame.origin.y) +  Float(acceleration)/self.accelerationFactor)
            dog.frame = CGRectMake(dog.frame.origin.x, yPosition, dog.frame.width, dog.frame.height)
        }
        else {
            ++acceleration
            var yPosition = Float(dog.frame.origin.y) +  Float(acceleration) / (self.accelerationFactor - 4)
            dog.frame = CGRectMake(dog.frame.origin.x, CGFloat(yPosition) , dog.frame.width, dog.frame.height)
        }
        recorder.pauseRecording()
        dog.setNeedsDisplay()
        brick.frame = CGRectMake(brick.frame.origin.x - CGFloat(13 - self.accelerationFactor) - CGFloat(Float(score)/(self.accelerationFactor-3.0)), brick.frame.origin.y, brick.frame.width, brick.frame.height)
        if brick.frame.origin.x <  -50 {
            randomHeight = CGFloat(Int(arc4random_uniform(450))+50);
            brick.frame = CGRectMake(UIScreen.mainScreen().bounds.width, randomHeight, brick.frame.width, brick.frame.height)
            brick.resetColor()
        }
        brick.setNeedsDisplay()
        self.updateScore()
        if collisionDetection(){
            timer.invalidate()
            timer = nil
            explosion.frame = CGRectMake(dog.frame.origin.x - 25, dog.frame.origin.y - 25, explosion.frame.width, explosion.frame.height)
            gameOver()
        }else{
        }
    }

}

