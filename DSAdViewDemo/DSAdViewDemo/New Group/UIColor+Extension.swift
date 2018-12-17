//
//  UIColor+Extension.swift
//  RefuelingAssistant
//
//  Created by 左得胜 on 2016/10/24.
//  Copyright © 2016年 zds. All rights reserved.
//

import UIKit

extension UIColor {
    /// 扩展随机色
    class var random: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    
    /// 扩展 rgba 颜色
    ///
    /// - Parameters:
    ///   - r: red（0~256）
    ///   - g: green（0 ~ 256）
    ///   - b: blue（0 ~ 256）
    ///   - alpha: 透明度
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 扩展十六进制颜色（格式：##cccccc、#cccccc、0Xcccccc、0xcccccc、cccccc）
    ///
    ///   - hexString: 十六进制颜色值
    convenience init(hexString: String) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 如果字符串是 0XFF0022
        if hex.hasPrefix("0X") || hex.hasPrefix("##") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {// 如果字符串是以 # 开头
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        
        // 方法一：
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
            print(#file, #line, "色值错误，请检查~")
        }
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    // 从颜色重获取 RGB 的值
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat) {
        /*
         guard let components = cgColor.components else {
         fatalError("错误：请确定颜色是通过 rgb 创建的！")
         }
         
         return (components[0] * 255, components[1] * 255, components[2] * 255)
         */
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
}
