//
//  DifficultyController.swift
//  Yell it Up
//
//  Created by Juliang Li on 10/10/15.
//  Copyright (c) 2015 Hackthon. All rights reserved.
//

import UIKit

class DifficultyController: UIViewController {
    @IBOutlet var easy: UIButton!
    @IBOutlet var medium: UIButton!
    @IBOutlet var hard: UIButton!
    @IBOutlet var brutal: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.blackColor().CGColor,UIColor.whiteColor().CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "easy") {
            var svc = segue.destinationViewController as! ViewController;
            svc.accelerationFactor = 7.0
        }else if (segue.identifier == "medium") {
            var svc = segue.destinationViewController as! ViewController;
            svc.accelerationFactor = 6.5

        }else if (segue.identifier == "hard") {
            var svc = segue.destinationViewController as! ViewController;
            svc.accelerationFactor = 6.0
        }else if (segue.identifier == "brutal") {
            var svc = segue.destinationViewController as! ViewController;
            svc.accelerationFactor = 5.0
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
