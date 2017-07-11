//
//  ViewController.swift
//  GlowingEffectView
//
//  Created by harshalrj25 on 07/11/2017.
//  Copyright (c) 2017 harshalrj25. All rights reserved.
//

import UIKit
import GlowingEffectView

class ViewController: UIViewController {
    
    func generateView() {
        let viewWidth: Float = Float(view.frame.size.width)
        let viewHeight: Float = Float(view.frame.size.height)
        var numViews: Int = 0
        // change the below number for more than 1 view at a time
        while numViews < 1 {
            var goodView: Bool = true
            let candidateView:GlowingEffectView = GlowingEffectView()
            candidateView.frame = CGRect(x: CGFloat(arc4random() % UInt32(viewWidth)), y: CGFloat(arc4random() % UInt32(viewHeight)), width: CGFloat(arc4random_uniform(UInt32(50.0))), height: CGFloat(arc4random_uniform(UInt32(50.0))))
            candidateView.radius = CGFloat(arc4random_uniform(UInt32(50.0)))
            candidateView.baseColor = UIColor.randomColor()
            for placedView: UIView in view.subviews {
                if candidateView.frame.insetBy(dx: CGFloat(-10), dy: CGFloat(-10)).intersects(placedView.frame) {
                    goodView = false
                    break
                }
            }
            if goodView {
                view.addSubview(candidateView)
                numViews += 1
            }
        }
    }
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        self.generateView()
    }
}
extension UIColor {
    class func randomColor(randomAlpha randomApha:Bool = false)->UIColor{
        
        let redValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let greenValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let blueValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let alphaValue = randomApha ? CGFloat(arc4random_uniform(255)) / 255.0 : 1;
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
    }
}

