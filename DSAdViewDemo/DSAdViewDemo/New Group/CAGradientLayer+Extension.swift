//
//  CAGradientLayer+Extension.swift
//  RefuelingAssistant
//
//  Created by 左得胜 on 2018/4/11.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

enum GradientDirections: Int {
    case LeftToRight
    case RightToLeft
    case TopToBottom
    case BottomToTop
    case TopLeftToBottomRight
    case TopRightToBottomLeft
    case BottomLeftToTopRight
    case BottomRightToTopLeft
}

extension CAGradientLayer {
    /// 颜色渐变的起点和终点，范围为 (0~1.0, 0~1.0)
    convenience init(direction: GradientDirections) {
        self.init()
        
        switch direction {
        case .TopToBottom:
            self.startPoint = CGPoint(x: 0.5, y: 0)
            self.endPoint = CGPoint(x: 0.5, y: 1)
            
        case .BottomToTop:
            self.startPoint = CGPoint(x: 0.5, y: 1)
            self.endPoint = CGPoint(x: 0.5, y: 0)
            
        case .LeftToRight:
            self.startPoint = CGPoint(x: 0, y: 0.5)
            self.endPoint = CGPoint(x: 1, y: 0.5)
            
        case .RightToLeft:
            self.startPoint = CGPoint(x: 1, y: 0.5)
            self.endPoint = CGPoint(x: 0, y: 0.5)
            
        case .TopLeftToBottomRight:
            self.startPoint = CGPoint(x: 0, y: 0)
            self.endPoint = CGPoint(x: 1, y: 1)
            
        case .TopRightToBottomLeft:
            self.startPoint = CGPoint(x: 1, y: 0)
            self.endPoint = CGPoint(x: 0, y: 1)
            
        case .BottomLeftToTopRight:
            self.startPoint = CGPoint(x: 0, y: 1)
            self.endPoint = CGPoint(x: 1, y: 0)
            
        case .BottomRightToTopLeft:
            self.startPoint = CGPoint(x: 1, y: 1)
            self.endPoint = CGPoint(x: 0, y: 0)
        }
    }
    
    /// 便利构造器：只需要给出起点颜色、终点颜色和渐变方向即可
    convenience init(startColor: UIColor, endColor: UIColor, direction: GradientDirections) {
        self.init(direction: direction)
    
        let gradientColors = [startColor.cgColor, endColor.cgColor]
        colors = gradientColors
    }
    
    convenience init(colors: [UIColor], locations: [NSNumber], direction: GradientDirections = .LeftToRight) {
        self.init(direction: direction)
        
        var cgColors: [CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        self.colors = cgColors
        self.locations = locations
    }
}
