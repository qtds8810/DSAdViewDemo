//
//  UIButton+Extension.swift
//  RefuelingAssistant
//
//  Created by 左得胜 on 2017/4/3.
//  Copyright © 2017年 zds. All rights reserved.
//

import UIKit

extension UIButton {
    /// 便利构造器，默认值的可以删除不写
    convenience init(frame: CGRect, title: String?, bgColor: UIColor?, normalTitleColor: UIColor?, highlightedTitleColor: UIColor? = UIColor.lightText, target: Any?, action: Selector) {
        // 实例化对象
        self.init(frame: frame)
        // 访问属性
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(highlightedTitleColor, for: .highlighted)
        addTarget(self, action: action, for: .touchUpInside)
    }
    
    /// 便利构造器
    ///
    /// - Parameters:
    ///   - type: btn类型
    ///   - title: 文字
    ///   - normalTitleColor: 常规文字颜色
    ///   - highlightedTitleColor: 高亮文字颜色
    ///   - normalBGColor: 常规背景颜色
    ///   - disableBGColor: 不可点击背景色
    ///   - font: 字号
    convenience init(type: UIButton.ButtonType = UIButton.ButtonType.system, title: String?, image: UIImage?, normalTitleColor: UIColor? = nil, highlightedTitleColor: UIColor? = nil, normalBGColor: UIColor? = nil, highlightedBGColor: UIColor? = nil, disableBGColor: UIColor? = nil, font: UIFont = kFontSize.system_17) {
        // 实例化对象
        self.init(type: type)
        // 访问属性
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(highlightedTitleColor, for: .highlighted)
        titleLabel?.font = font
        setImage(image, for: .normal)
        
        if let disableBGColor = disableBGColor {
            setBackgroundImage(UIImage.image(color: disableBGColor), for: .disabled)
        }
        if let normalBGColor = normalBGColor {
            setBackgroundImage(UIImage.image(color: normalBGColor), for: .normal)
        }
        if let highlightedBGColor = highlightedBGColor {
            setBackgroundImage(UIImage.image(color: highlightedBGColor), for: .highlighted)
        }
    }
}
