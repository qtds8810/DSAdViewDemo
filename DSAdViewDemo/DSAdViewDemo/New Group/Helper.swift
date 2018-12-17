//
//  Helper.swift
//  OFNews
//
//  Created by 左得胜 on 2018/4/11.
//  Copyright © 2018年 左得胜. All rights reserved.
//

import UIKit
import WebKit

// MARK: - 自定义打印信息
func QL1(_ debug: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).pathComponents.last!):\(line) \(function): \(debug)")
    #endif
}

/// 自定义打印=================
func QLShortLine(_ file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let lineString = "======================================"
    print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
    #endif
}

/// 自定义打印+++++++++++++++++++
func QLPlusLine(_ file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let lineString = "+++++++++++++++++++++++++++++++++++++"
    print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
    #endif
}
/*
// MARK: - 获取最顶层的ViewController
func global_getTopViewController() -> UIViewController? {
    var resultVC: UIViewController?
    if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
        resultVC = getTopVC(rootVC)
        while resultVC?.presentedViewController != nil {
            resultVC = resultVC?.presentedViewController
        }
    }
    return resultVC
}

private func getTopVC(_ vc: UIViewController?) -> UIViewController? {
    if let navVC = vc as? UINavigationController {
        return getTopVC(navVC.viewControllers.last)
    } else if let tabBarVC = vc as? UITabBarController {
        if tabBarVC.selectedIndex < tabBarVC.viewControllers!.count {
            return getTopVC(tabBarVC.viewControllers![tabBarVC.selectedIndex])
        }
    }
    return vc
}
*/
//MARK: - 全局展示警告框
func global_alert(title: String? = nil, message: String?, preferredStyle: UIAlertController.Style = .alert, cancel: (String, UIColor)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil, confirm: (String, UIColor)? = nil, confirmHandler: ((UIAlertAction) -> Void)? = nil, otherAction: [UIAlertAction]? = nil) {
    guard let vc = UIViewController.currentVC(), !vc.isKind(of: UIAlertController.classForCoder()) else { return }
    
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: UI_IS_IPAD ? .alert : preferredStyle)
    if let cancel = cancel {
        let action = UIAlertAction(title: cancel.0, style: .cancel, handler: cancelHandler)
        action.setValue(cancel.1, forKey: "titleTextColor")
        alertVC.addAction(action)
    } else {
        alertVC.addAction(UIAlertAction(title: "确定", style: .cancel, handler: cancelHandler))
    }
    if let confirm = confirm {
        let action = UIAlertAction(title: confirm.0, style: .default, handler: confirmHandler)
        action.setValue(confirm.1, forKey: "titleTextColor")
        alertVC.addAction(action)
    }
    if let otherAction = otherAction {
        for action in otherAction {
            action.setValue(kColor.darkText, forKey: "titleTextColor")
            alertVC.addAction(action)
        }
    }
    
    vc.present(alertVC, animated: true, completion: nil)
}

/// 展示全局 alertView（这个可以在 view 代码中使用，使用比较广）
///
/// - Parameters:
///   - title: 标题
///   - message: 描述
///   - cancelButtonTitle: 取消按钮的文字
func global_alertView(title: String? = nil, message: String?, cancelButtonTitle: String = "确定") {
    let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
    //    alertView.tintColor = kColor.main
    alertView.show()
}

/// 根据设计稿的像素值返回实际物理值【以4.7英寸宽(375.0, 667.0)为基准】
///
/// - Parameter value: 像素值
/// - Returns: 实际物理值
func kw(_ value: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.width / 375 * value
    //    return CGFloat(Int(UIScreen.main.bounds.width / 375 * value))
}

//MARK: - 全局打电话
/// 全局打电话
///
/// - parameter phoneNumber: 要拨打的电话号码
func global_phone(with phoneNumber: String, isShowActionSheet: Bool = true) {
    // 方式一：
    //    let webView = WKWebView()
    //    // 判断用户是否登录，未登录，则拨打公司座机，登录，则拨打对应的交易员电话
    //    webView.load(URLRequest(url: URL(string: "tel://\(phoneNumber)")!))
    //    global_getTopViewController()?.view.addSubview(webView)
    
    // 方式二：
    if isShowActionSheet {
        global_alert(title: "拨打电话：", message: nil, preferredStyle: .actionSheet, cancel: ("取消", kColor.main), cancelHandler: nil, confirm: (phoneNumber, kColor.darkText), confirmHandler: { (_) in
            callPhone(phoneNumber: phoneNumber)
        })
    } else {
        callPhone(phoneNumber: phoneNumber)
    }
    
}

private func callPhone(phoneNumber: String) {
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL.init(string: "telprompt://\(phoneNumber)")!, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(URL(string: "tel://\(phoneNumber)")!)
    }
}

/// 判断是否是正式包
func global_isReleaseVersion() -> Bool {
    return !Bundle.main.ds_buildVersion.contains("beta")
}

public func global_goToAppStore(with urlStr: String) {
    UIApplication.shared.openURL(URL(string: urlStr)!)
}

/// 多个图片拼接成新的图片
func global_composeImageWithLogo(bgImage: UIImage, imageRect: [CGRect], images:[UIImage]) -> UIImage {
    //以bgImage的图大小为底图
    let imageRef = bgImage.cgImage
    let w: CGFloat = CGFloat((imageRef?.width)!)
    let h: CGFloat = CGFloat((imageRef?.height)!)
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContextWithOptions(CGSize.init(width: w, height: h), false, UIScreen.main.scale)
    bgImage.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
    //先把1.png 画到上下文中
    for i in 0..<images.count {
        images[i].draw(in: CGRect(x: imageRect[i].origin.x,
                                  y: imageRect[i].origin.y,
                                  width: imageRect[i].size.width,
                                  height:imageRect[i].size.height))
    }
    //再把小图放在上下文中
    let resultImg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    //从当前上下文中获得最终图片
    UIGraphicsEndImageContext()
    return resultImg!
}
/*
/// 全局，检测是否有新版本
///
/// - Parameter isShowFalse: 接口错误、无新版本是否提示信息
func global_checkNewVersion(isShowFalse: Bool) {
    NetworkTool.ds_request(.configseveral_getData, isShowError: false, type: OFUpdateModel.self, atKeyPath: "data", success: { (model) in
        
        var compareResult = false
        if global_isReleaseVersion() {// 正式包
            compareResult = model.version_name.compare(Bundle.main.ds_version) == ComparisonResult.orderedDescending
        } else {// 测试包
            compareResult = (Bundle.main.ds_version + Bundle.main.ds_buildVersion) != model.version_name
        }
        
        guard compareResult else {// 无新版本
            if isShowFalse {
                global_showAlert(title: "温馨提醒", message: "暂无新版本")
            }
            return
        }
        // 有新版本
        if model.force {// 强制更新
            showUpdateView(model)
        } else {// 非强制更新
            if isShowFalse {// 总是弹框
                showUpdateView(model)
            } else {// 弹框3次后不弹框
                let nowDate = Date()
                if let time = kUserDefaults.object(forKey: kUDKey.updateAlertTime) as? Date,
                    !Calendar.current.isDate(nowDate, inSameDayAs: time),
                    let alertTimes = kUserDefaults.object(forKey: kUDKey.updateAlertTimes) as? Int,
                    alertTimes < 2 {
                    showUpdateView(model)
                }
                
            }
            
        }
    }) { (error) in
        if isShowFalse {
            DSProgressHUD.show(.text, message: error.myErrorDescription)
        }
    }
    
}
*/

