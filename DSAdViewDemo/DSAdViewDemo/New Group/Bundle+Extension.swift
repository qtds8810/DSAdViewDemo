//
//  Bundle+Extension.swift
//  RefuelingAssistant
//
//  Created by 左得胜 on 2017/4/5.
//  Copyright © 2017年 zds. All rights reserved.
//

import Foundation

extension Bundle {
    /// 利用计算型属性动态获取命名空间
    var ds_nameSpace: String {
        return infoDictionary?["CFBundleExecutable"] as? String ?? ""
    }
    
    /// APP的bundleIdentifier
    var ds_bundleIdentifier: String {
        return bundleIdentifier ?? ""
    }
    
    /// APP 的版本号（给用户看）
    var ds_version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// APP 的 build 号（内部开发标识）
    var ds_buildVersion: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
