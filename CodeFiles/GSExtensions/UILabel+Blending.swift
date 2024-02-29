//
//  UILabelExtension.swift
//  Clikat Supplier
//
//  Created by Night Reaper on 08/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    func blendLabelWithImage(blendingImage : UIImage?, color : UIColor) -> UIImage?{
        guard let image = blendingImage else{return nil}
        let backgroundSize : CGSize = image.size
        UIGraphicsBeginImageContextWithOptions(backgroundSize, false, UIScreen.main.scale)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    
        context.translateBy(x: 0, y: (backgroundSize.height - self.frame.origin.y)/2)
        context.scaleBy(x: 1, y: -1)
        
        
        let rect : CGRect = CGRect(x: 0, y: 0, width : image.size.width, height : image.size.height)
        
        context.clip(to: rect, mask: image.cgImage!)
        
        var r = CGFloat()
        var g = CGFloat()
        var b = CGFloat()
        var a = CGFloat()
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var rgbColorspace : CGColorSpace
        let locations : [CGFloat] = [0.0, 1.0]
        let components  = [UIColor(red: r, green: g, blue: b, alpha: 1.0).cgColor, UIColor(red: r, green: g, blue: b, alpha: 1.0).cgColor]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        
        let glossGradient : CGGradient = CGGradient(colorsSpace: rgbColorspace, colors: components as CFArray, locations: locations)!
        let topCenter : CGPoint = CGPoint(x: 0,y: 0)
        let bottomCenter : CGPoint = CGPoint(x: 0, y: self.frame.size.height)
        
        context.drawLinearGradient(glossGradient, start: topCenter, end: bottomCenter, options: .drawsBeforeStartLocation)
        context.setFillColor(red: r, green: g, blue: b, alpha: a)
        context.fill(rect)
        
        guard let coloredImg: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        coloredImg.draw(in: rect, blendMode: CGBlendMode.multiply, alpha: 0.5)
        
        UIGraphicsEndImageContext()
        
        return coloredImg
        
    }
    
    
    
}
