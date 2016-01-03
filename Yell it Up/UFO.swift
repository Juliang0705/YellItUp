//
//  UFO.swift
//  Yell it Up
//
//  Created by Juliang Li on 10/10/15.
//  Copyright (c) 2015 Hackthon. All rights reserved.
//

import UIKit

class UFO: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        /*// Drawing code
        // get context first
        let context = UIGraphicsGetCurrentContext()
        // set the line width
        CGContextSetLineWidth(context, 2.0)
        // create color
       /* let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        */
        //set color
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.frame.width, self.frame.height))
        // fill a color
        CGContextSetFillColorWithColor(context,UIColor.redColor().CGColor)
        CGContextFillEllipseInRect(context, self.frame)
        CGContextDrawPath(context, kCGPathFillStroke)*/
      //  UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
        let context = UIGraphicsGetCurrentContext()
        let rectangle = CGRect(x: 2, y: 2, width: self.frame.width-3, height: self.frame.height-3)
        
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2)
        CGContextAddEllipseInRect(context, rectangle)
        CGContextDrawPath(context, kCGPathFillStroke)
        
       // let img = UIGraphicsGetImageFromCurrentImageContext()
      //  UIGraphicsEndImageContext()
    }
}
class Boundary: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.greenColor().CGColor)
        CGContextFillRect(context, rect)
        CGContextStrokeRect(context, rect)
    }
}


class Obstacle: UIView {
    var randomColor:UIColor!
    var myGradient: CGGradientRef!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        resetColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    func resetColor() -> Void{
        var red1 = CGFloat(arc4random_uniform(255))/255.0
        var green1 = CGFloat(arc4random_uniform(255))/255.0
        var blue1 = CGFloat(arc4random_uniform(255))/255.0
        var red2 = CGFloat(arc4random_uniform(255))/255.0
        var green2 = CGFloat(arc4random_uniform(255))/255.0
        var blue2 = CGFloat(arc4random_uniform(255))/255.0
       // println("\(red),\(green),\(blue)")
       // randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        var myColorspace: CGColorSpaceRef
        var num_locations: size_t  = 2;
        var locations: [CGFloat] = [ 0.0, 1.0 ];
        var components: [CGFloat] = [ red1, green1, blue1, 1.0,  // Start color
            red2, green2, blue2, 1.0 ]; // End color
        myColorspace = CGColorSpaceCreateDeviceRGB()
        myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
            locations, num_locations);
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
       // CGContextSetFillColorWithColor(context, randomColor.CGColor)
       // CGContextDrawLinearGradient (context, myGradient, CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1.0,y: 1.0), 0);
      //  CGContextFillRect(context, rect)
      //  CGContextStrokeRect(context, rect)
        var startPoint:CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        var endPoint:CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        CGContextSaveGState(context);
        CGContextAddRect(context, rect);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint, 0);
        CGContextRestoreGState(context);
    }

}
