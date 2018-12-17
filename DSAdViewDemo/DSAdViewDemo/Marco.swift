//
//  Marco.swift
//  YXJY
//
//  Created by 左得胜 on 2018/8/7.
//  Copyright © 2018年 得胜. All rights reserved.
//

import UIKit
import AdSupport

// MARK: - 项目上线配置
/// target 中的 Build 以 beta 开头标识测试版；0~9开头标识正式版
/// 请求用的 URL


// MARK: - 各种key
struct kAPPKEY {
}

// MARK: - 全局尺寸
/// 主屏幕
struct kScreen {
    /// 主屏幕--尺寸
    static let bounds: CGRect = UIScreen.main.bounds
    /// 主屏幕--宽
    static let width: CGFloat = UIScreen.main.bounds.size.width
    /// 主屏幕--高
    static let height: CGFloat = UIScreen.main.bounds.size.height
}


// MARK: - 全局高度
struct kHeight {
    static let d003: CGFloat = 0.33
    static let d005: CGFloat = 0.5
    static let d02: CGFloat = 2
    static let d05: CGFloat = 5
    static let d06: CGFloat = 6
    static let d08: CGFloat = 8
    static let d10: CGFloat = 10
    static let d12: CGFloat = 12
    static let d15: CGFloat = 15
    static let d18: CGFloat = 18
    static let d20: CGFloat = 20
    static let d21: CGFloat = 21
    static let d30: CGFloat = 30
    static let d35: CGFloat = 35
    static let d37: CGFloat = 37
    static let d50: CGFloat = 50
    static let d44: CGFloat = 44
    static let d45: CGFloat = 45
    static var tabBar: CGFloat {
        return 49 + safeArea
    }//(UI_IS_IPHONE_FULLSCREEN) ? (49 + 34) : 49
    static let navBar: CGFloat = 44 + kHeight.status//UI_IS_IPHONE_X ? 88 : 64
    static let status: CGFloat = UIApplication.shared.statusBarFrame.height//UI_IS_IPHONE_X ? 44 : 20
    /// 底部安全距离
    static var safeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat(0))
        }
        return 0
    }
    static let blurAlpha: CGFloat = 0.98
    /// 订单滑动菜单高度
    static let spPageMenu: CGFloat = 60
}

// MARK: - 判断屏幕类型
public let UI_IS_IPAD = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
public let UI_IS_IPHONE = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone)
public let UI_IS_IPHONE_4 = (UI_IS_IPHONE && kScreen.height < 568)
public let UI_IS_IPHONE_5 = (UI_IS_IPHONE && kScreen.height ~= 568)
public let UI_IS_IPHONE_6 = (UI_IS_IPHONE && kScreen.height ~= 667)
public let UI_IS_IPHONE_6P = (UI_IS_IPHONE && kScreen.height ~= 736)
/// 全面屏手机（iPhone X，iPhone X，iPhone XS Max， iPhone XR）
//public let UI_IS_IPHONE_FULLSCREEN = (UI_IS_IPHONE && kScreen.height >= 812)
public var UI_IS_IPHONE_FULLSCREEN: Bool {
    var isIPhoneXSeries: Bool = false
    if #available(iOS 11.0, *), UI_IS_IPHONE {
        if let window = UIApplication.shared.delegate?.window as? UIWindow,
            window.safeAreaInsets.bottom > CGFloat(0) {
            isIPhoneXSeries = true
        }
    }
    return isIPhoneXSeries
}

// MARK: - 全局颜色
struct kColor {
    /// 导航栏颜色，这里需要设置透明度
    /// 主背景色【混合导航栏】
    static let navSystem: UIColor? = nil//UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let navWhite = kColor.white.withAlphaComponent(0.98)
    
    /// 导航栏原色：272732
    static let navDark = UIColor(hexString: "161623")
    
//    static let blue = UIColor.init(hexString: "#3399ff")
    static let navDarkText = UIColor.darkText
    static let login_btn_bg_no = UIColor(red:0.8, green:0.8, blue:0.8, alpha:1.000)
    static let login_btm_text = UIColor.init(hexString: "#9b9b9b")
    //个人信息页面深色
    static let text_4a = UIColor.init(hexString: "#4a4a4a")
    //订单详情中浅色文字深色
    static let text_bc = UIColor.init(hexString: "#bcbcbc")
    //订单详情中分割线颜色
    static let line_e9 = UIColor.init(hexString: "#e9e9e9")

    /// 主色、标题部分
    static let main = UIColor.init(hexString: "#ff7517")
    /// 辅色、凸显部分
    static let subMain = UIColor.init(hexString: "#F5A623")
    /// 深灰色文案
    static let darkGray = UIColor.init(hexString: "#9b9b9b")
    /// 浅灰色文案
    static let lightGray = UIColor.lightGray
    /// 分割线、轮播点
    static let line = UIColor.init(hexString: "d6d5d9")
    /// 遮罩层，有透明度
    static let mask = UIColor.black.withAlphaComponent(0.7)
    /// 警示红点
    static let warn = UIColor.init(hexString: "#f26333")
    
    static let d_cccccc = UIColor(hexString: "cccccc")
    static let d_4a4a4a = UIColor(hexString: "#4a4a4a")
    static let d_272732 = UIColor(hexString: "272732")
    static let d_777777 = UIColor(hexString: "777777")
    static let d_c4c4c4 = UIColor(hexString: "c4c4c4")
    static let d_eeeeee = UIColor(hexString: "eeeeee")
    static let d_353535 = UIColor(hexString: "353535")
    static let d_e9e9e9 = UIColor(hexString: "e9e9e9")
    static let d_9b9b9b = UIColor(hexString: "9b9b9b")
    static let d_e7e7e7 = UIColor(hexString: "e7e7e7")
    static let d_c7c7c7 = UIColor(hexString: "c7c7c7")
    static let d_f5a623 = UIColor(hexString: "f5a623")
    static let d_878787 = UIColor(hexString: "878787")
    static let d_cfcfcf = UIColor(hexString: "cfcfcf")
    static let d_949494 = UIColor(hexString: "949494")
    static let d_ed792a = UIColor(hexString: "ed792a")
    static let d_989898 = UIColor(hexString: "989898")
    
    static let oilDitailDarkGray = UIColor.init(hexString: "#272732")

    /// 白色
    static let white = UIColor.white
    /// 绿色
    static let green = UIColor.green
    /// 棕色
    static let brown = UIColor.brown
    /// 黑色
    static let black = UIColor.black
    /// gray
    static let gray = UIColor.gray
    /// darkText
    static let darkText = UIColor.darkText//UIColor.init(hexString: "#313131")
    /// tableView 背景色
    static let groupTableViewBackground = UIColor.groupTableViewBackground
    /// 无色
    static let clear = UIColor.clear
    static let disabled = UIColor(hexString: "d4d4d6")
}



// MARK: - 全局字号
/// 全局字号
struct kFontSize {
    static let system_11 = UIFont.fontOfDP(ofSize: 11)
    static let system_12 = UIFont.fontOfDP(ofSize: 12)
    static let system_13 = UIFont.fontOfDP(ofSize: 13)
    static let system_14 = UIFont.fontOfDP(ofSize: 14)
    static let system_15 = UIFont.fontOfDP(ofSize: 15)
    static let system_16 = UIFont.fontOfDP(ofSize: 16)
    static let system_17 = UIFont.fontOfDP(ofSize: 17)
    static let system_18 = UIFont.fontOfDP(ofSize: 18)
    static let system_19 = UIFont.fontOfDP(ofSize: 19)
    
    static let bold_20 = UIFont.fontOfDP(ofSize: 20, weight: .bold)
    static let bold_19 = UIFont.fontOfDP(ofSize: 19, weight: .bold)
    static let bold_18 = UIFont.fontOfDP(ofSize: 18, weight: .bold)
    static let bold_17 = UIFont.fontOfDP(ofSize: 17, weight: .bold)
    static let bold_16 = UIFont.fontOfDP(ofSize: 16, weight: .bold)
    static let bold_15 = UIFont.fontOfDP(ofSize: 15, weight: .bold)
    
    static let name_bebas = "Bebas"
    static let name_din = "DIN Condensed"
}


// MARK: - 全局时间
/// 全局时间
struct kTime {
    static let d_01: TimeInterval = 0.1
    static let duration: TimeInterval = 0.25
    /// 全局时间：1秒
    public let d_1: Int = 1
    /// 全局时间：一天
    static let day1: TimeInterval = 60 * 60 * 24
    /// 获取验证码倒计时的时间
    static let authCodeTime = 120
    /// 油卡刷新时间
    static let cardCodeRefresh = 180
    /// 用于请求网络成功后延时一会儿，然后处理接下来的时间
    static let after1s = DispatchTime.now() + .seconds(1)
    /// 延时0.25秒
    static let afterDuration = DispatchTime.now() + 0.25
}


// MARK: - UserDefaults
/// 全局快捷获取UserDefaults
public let kUserDefaults = UserDefaults.standard
/// UserDefaults的 key 名字
struct kUDKey {
    /// 存入到沙盒中的URL
    static let urlWithHost = "urlWithHost"
    /// 弹框弹出次数
    static let updateAlertTimes = "updateAlertTimes"
}


// MARK: - Notification
/// 全局快捷获取通知
public let kNotificationCenter = NotificationCenter.default

public extension NSNotification.Name {
    /// 通知用户登录【object传true，不用提示，传false、nil或其他，提示需要登录的信息HUD】
    static let kIsUserShouldLogin = Notification.Name(rawValue: "kIsUserShouldLogin")
    // 登录成功，切换至登录成功的界面
    static let kUserLoginSuccess = Notification.Name(rawValue: "kUserLoginSuccess")
    /// 跳转到登录界面
    static let kUserShouldLogin = Notification.Name(rawValue: "kUserShouldLogin")
}


// MARK: - 文案相关
/// 文案相关
struct kTitle {
    static let nativeError = "系统出错，请联系找油客服"
    static let netError = "服务异常，请重试"
    static let loading = "正在加载..."
    static let dealing = "正在处理..."
    static let noMoreData = "暂无更多数据~"
}

// MARK: - 全局订单状态
enum OrderStatusEnum: Int, Decodable {
    /// 待付款
    case waitPay = 1
    /// 支付中
    case paying = 2
    /// 已付款
    case paySuccess = 3
    /// 支付失败
    case payError = 4
    /// 订单取消（已取消）
    case canceled = 0
    /// 退款申请提交
    case refundCheckPost = 5
    /// 退款审核成功
    case refundCheckSuccess = 6
    /// 退款中
    case refunding = 7
    /// 退款成功（已退款）
    case refundSuccess = 8
    /// 退款审核失败
    case refundCheckError = -6
    /// 退款失败
    case refundError = -8
    /// 未知状态
    case unknown = 9
    
}
