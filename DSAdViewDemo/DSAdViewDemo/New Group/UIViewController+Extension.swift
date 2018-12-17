//
//  UIViewController+Extension.swift
//  YXJY
//
//  Created by 左得胜 on 2018/8/7.
//  Copyright © 2018年 得胜. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Public Method
    /// 获取当前 APP 的栈顶控制器
    class func currentVC() -> UIViewController? {
        var rootViewController: UIViewController?
        for window in UIApplication.shared.windows where !window.isHidden {
            if let rootVC = window.rootViewController {
                rootViewController = rootVC
                break
            }
        }
        return getTopVC(of: rootViewController)
    }
    
    /// Returns the top most view controller from given view controller's stack.
    private class func getTopVC(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return getTopVC(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return getTopVC(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return getTopVC(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return getTopVC(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return getTopVC(of: childViewController)
            }
        }
        
        return viewController
    }
    
}
