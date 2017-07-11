//
//  GlowingEffectView.swift
//  Pods
//
//  Created by Harshal Jadhav on 11/07/17.
//
//

import Foundation
import UIKit
@IBDesignable
class GlowingEffectView: UIView {
    @IBInspectable var radius:CGFloat = 55
    @IBInspectable var shine:CGFloat = 1.6
    @IBInspectable var baseColor:UIColor = UIColor(red: (39.0/255.0), green: (252.0/255), blue: (196.0/255.0), alpha: 1.0)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.glowing(baseColor: baseColor, radius: radius, shine: shine)
    }
    
    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor.clear
        
        
    }
    
    func glowing(baseColor: UIColor, radius: CGFloat, shine: CGFloat) {
        let growColor = baseColor
        Shadow(radius, increaseColor: growColor, shine: shine)
        
        //Inner circle inside the UIView
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)).cgPath
        let circleGradient = CircularGradientLayer(colors: [growColor, UIColor(white: 1.0, alpha: 0)])
        //set frame of inner circle to middle of the UIView
        circleGradient.frame = CGRect(x: self.frame.size.width/2 - (radius * 2.0)/2, y: self.frame.size.height/2 - (radius * 2.0)/2, width: radius * 2.0, height: radius * 2.0)
        circleGradient.opacity = 0.25
        circleGradient.mask = circle
        layer.addSublayer(circleGradient)
    }
    
    func Shadow(_ radius: CGFloat, increaseColor: UIColor, shine: CGFloat) {
        let origin = self.center.minus(self.frame.origin).minus(CGPoint(x: radius * shine, y: radius * shine))
        let ovalRect = CGRect(origin: origin, size: CGSize(width: 2 * radius * shine, height: 2 * radius * shine))
        let shadowPath = UIBezierPath(ovalIn: ovalRect)
        self.layer.shadowColor = increaseColor.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowOpacity = 1.0
        self.layer.shouldRasterize = true
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
}
class CircularGradientLayer : CALayer {
    let colors: [UIColor]
    init(colors: [UIColor]) {
        self.colors = colors
        super.init()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in context: CGContext) {
        
        var locations = self.calculateLocations(0.0, to: 1.0, n: colors.count)
        locations = Array(locations.map {1.0 - $0 * $0 }.reversed())
        
        let colorsObj = colors.map { $0.cgColor }
        //create gradient
        let gradients = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colorsObj as CFArray, locations: locations)
        //draw gradient
        context.drawRadialGradient(gradients!, startCenter:  self.frame.center, startRadius: CGFloat(0.0), endCenter:  self.frame.center, endRadius: max(self.frame.width, self.frame.height), options: CGGradientDrawingOptions(rawValue: 10))
        
    }
    func calculateLocations(_ from: CGFloat, to: CGFloat, n: Int) -> [CGFloat] {
        var values: [CGFloat] = []
        for i in 0..<n {
            values.append((to - from) * CGFloat(i) / CGFloat(n - 1) + from)
        }
        return values
    }
    
}
extension CGRect {
    var rightBottom: CGPoint {
        get {
            return CGPoint(x: origin.x + width, y: origin.y + height)
        }
    }
    var center: CGPoint {
        get {
            return origin.plus(rightBottom).mul(0.5)
        }
    }
}


extension CGPoint {
    func mul(_ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * rhs, y: self.y * rhs)
    }
    func plus(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    func minus(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
}
