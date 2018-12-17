//
//  UIImage+Extension.swift
//  RefuelingAssistant
//
//  Created by 左得胜 on 2016/10/18.
//  Copyright © 2016年 zds. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 用颜色生成一张图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: size
    /// - Returns: 默认宽度屏宽，高度为1
    class func image(color: UIColor, size: CGSize = CGSize.init(width: kScreen.width, height: 1)) -> UIImage {
        let rect = CGRect.init(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// 绘制绘制渐变色 image
    ///
    /// - Parameters:
    ///   - size: 图片size
    ///   - gradientColors: 渐变颜色数组
    ///   - locations: 渐变位置数组（范围0~1），这个数组的个数不小于gradientColors中存放颜色的个数
    ///   - direction: 渐变方向
    /// - Returns: 绘制的渐变图片
    class func image(size: CGSize, gradientColors: [UIColor], locations: [CGFloat], direction: GradientDirections = .LeftToRight) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        /*
         /*
         指定渐变色
         space:颜色空间
         components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
         如果有三个颜色则这个数组有4*3个元素
         locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
         count:渐变个数，等于locations的个数
         */
         let components: [CGFloat] = [0.999, 0.084, 0.004, 1.0,
         1.000, 0.809, 0.263, 1.0,
         0.000, 0.543, 0.954, 1.0,
         0.198, 0.822, 0.384, 1.0
         ]
         
         let locas:[CGFloat] = [0, 0.2, 0.3, 1.0]
         */
        var components: [CGFloat] = []
        for color in gradientColors {
            components += color.cgColor.components ?? [0, 0, 0, 1]
        }
        
        //生成渐变色（count参数表示渐变个数）
        guard let gradient = CGGradient.init(colorSpace: colorSpace, colorComponents: components, locations: locations, count: locations.count) else { return nil }
        
        var startPoint: CGPoint = CGPoint.zero
        var endPoint: CGPoint = CGPoint.zero
        switch direction {
        case .TopToBottom:
            startPoint = CGPoint(x: size.width * 0.5, y: 0)
            endPoint = CGPoint(x: size.width * 0.5, y: size.height)
            
        case .BottomToTop:
            startPoint = CGPoint(x: size.width * 0.5, y: size.height)
            endPoint = CGPoint(x: size.width * 0.5, y: 0)
            
        case .LeftToRight:
            startPoint = CGPoint(x: 0, y: size.height * 0.5)
            endPoint = CGPoint(x: size.width, y: size.height * 0.5)
            
        case .RightToLeft:
            startPoint = CGPoint(x: size.width, y: size.height * 0.5)
            endPoint = CGPoint(x: 0, y: size.height * 0.5)
            
        case .TopLeftToBottomRight:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: size.width, y: size.height)
            
        case .TopRightToBottomLeft:
            startPoint = CGPoint(x: size.width, y: 0)
            endPoint = CGPoint(x: 0, y: size.height)
            
        case .BottomLeftToTopRight:
            startPoint = CGPoint(x: 0, y: size.height)
            endPoint = CGPoint(x: size.width, y: 0)
            
        case .BottomRightToTopLeft:
            startPoint = CGPoint(x: size.width, y: size.height)
            endPoint = CGPoint(x: 0, y: 0)
        }
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return im
    }
    
    /// 拍照后，如果取info[UIImagePickerControllerOriginalImage] as? UIImage中的图片，如果修改图片信息但并未修改方向的话，原来的图像旋转90°，该方法可以修复旋转图片的问题
    func fixOrientation(aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation == UIImage.Orientation.up {
            return aImage
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .up, .upMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(aImage.size.width
        ), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
        default:
            ctx?.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
            break
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx!.makeImage()
        let img = UIImage.init(cgImage: cgimg!)
        
        return img;
    }
    
    class func image(name: String, with renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysOriginal) -> UIImage? {
        return UIImage.init(named: name)?.withRenderingMode(renderingMode)
    }
    
    /// 设置图片透明度
    class func image(image: UIImage, size: CGSize? = nil, alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size ?? image.size, false, 0.0)
        
        guard let ctx: CGContext = UIGraphicsGetCurrentContext() else {
            return image
        }
        let area = CGRect.init(origin: CGPoint.zero, size: size ?? image.size)
        
        ctx.ctm.scaledBy(x: 1, y: -1)
        ctx.ctm.translatedBy(x: 0, y: -area.size.height)
        
        ctx.setBlendMode(CGBlendMode.multiply)
        
        ctx.setAlpha(alpha)
        
        ctx.draw(image.cgImage!, in: area)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //    /**
    //     *  重设图片大小
    //     */
    //    func reSizeImage(reSize:CGSize)->UIImage {
    //        //UIGraphicsBeginImageContext(reSize);
    //        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
    //        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
    //        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    //        UIGraphicsEndImageContext();
    //        return reSizeImage;
    //    }
    //
    //    /**
    //     *  等比率缩放
    //     */
    //    func scaleImage(scaleSize:CGFloat)->UIImage {
    //        let reSize = CGSize(width: self.size.width * scaleSize,height:  self.size.height * scaleSize)
    //        return reSizeImage(reSize: reSize)
    //    }
}
