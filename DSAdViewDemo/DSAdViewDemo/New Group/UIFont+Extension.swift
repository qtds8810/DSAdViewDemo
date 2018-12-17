//
//  UIFont+Extension.swift
//  RefuelingAssistant
//
//  Created by 左得胜 on 2016/10/18.
//  Copyright © 2016年 zds. All rights reserved.
//

import UIKit

enum kFontWeight {
    /// 超细字体
    case ultraLight
    /// 纤细字体
    case thin
    /// 亮字体
    case light
    /// 常规字体
    case regular
    /// 介于Regular和Semibold之间
    case medium
    /// 半粗字体
    case semibold
    /// 加粗字体
    case bold
    /// 介于Bold和Black之间
    case heavy
    /// 最粗字体(理解)
    case black
}

extension UIFont {
    
    /// 新方法，设置字体，单位：像素【兼容 iOS8.0~iOS8.2】
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - weight: 字体 weight
    class func fontOfPX(ofSize fontSize: CGFloat, weight: kFontWeight = .regular) -> UIFont {
        var pt = (fontSize*0.5)
        if UI_IS_IPHONE_4 || UI_IS_IPHONE_5 {// iPhone 4s、iPhone 5
            pt = pt - 0.5
        } else if UI_IS_IPHONE_6P || UI_IS_IPHONE_FULLSCREEN {// iPhone 6sp
            pt = pt + 0.5
        }
        if #available(iOS 8.2, *) {
            return systemFont(ofSize: pt, weight: getFontWeight(weight))
        } else {
            if weight == .regular {
                return systemFont(ofSize: pt)
            } else {
                return boldSystemFont(ofSize: pt)
            }
        }
    }
    
    /// 新方法，设置字体，单位：点【兼容 iOS8.0~iOS8.2】
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - weight: 字体 weight
    class func fontOfDP(ofSize fontSize: CGFloat, weight: kFontWeight = .regular) -> UIFont {
        // 默认为 iPhone 6s、其它未知尺寸
        var size = fontSize
        if UI_IS_IPHONE_4 || UI_IS_IPHONE_5 {// iPhone 4s、iPhone 5
            size = fontSize - 0.5
        } else if UI_IS_IPHONE_6P || UI_IS_IPHONE_FULLSCREEN {// iPhone 6sp
            size = fontSize + 0.5
        }
        
        if #available(iOS 8.2, *) {
            return systemFont(ofSize: size, weight: getFontWeight(weight))
        } else {
            if weight == .regular {
                return systemFont(ofSize: size)
            } else {
                return boldSystemFont(ofSize: size)
            }
        }
    }
    
    @available (iOS 8.2, *)
    private class func getFontWeight(_ weight: kFontWeight) -> UIFont.Weight {
        var type = UIFont.Weight.regular
        
        switch weight {
        case .ultraLight:
            type = .ultraLight
        case .thin:
            type = .thin
        case .light:
            type = .light
        case .regular:
            type = .regular
        case .medium:
            type = .medium
        case .semibold:
            type = .semibold
        case .bold:
            type = .bold
        case .heavy:
            type = .heavy
        case .black:
            type = .black
        }
        return type
    }
}
