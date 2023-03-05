//
//  Define.swift
//  BMSwiftTools
//
//  Created by BLOM on 4/12/22.
//  Copyright © 2022 HU. All rights reserved.
//

import UIKit
import Foundation

// MARK: - 屏幕
/// 当前屏幕状态 高度
public let dsScreenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
/// 当前屏幕状态 宽度
public let dsScreenHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)


/// 状态栏高度(信号栏高度),刘海屏 44、59等， 正常屏幕20
/// - Returns: 高度
public func dsStatusBarHeight() ->CGFloat {
    UIDevice.vg_statusBarHeight()
}

/// 导航栏高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度  一般 44
public func dsNavBarHeight() ->CGFloat {
    UIDevice.vg_navigationBarHeight()
}

/// 状态栏高度+导航栏高度
public func dsStatusBarAndNavigationHeight() ->CGFloat {
    UIDevice.vg_navigationFullHeight()
}

/// 底部Tabbar高度  TabBar高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化   一般49
public func dsTabBarFullHeight() ->CGFloat {
    UIDevice.vg_tabBarHeight()
}

/// 底部安全区高度  获取刘海屏底部home键高度,  34或0  普通屏为0
public func dsSafeDistanceBottom() ->CGFloat {
    UIDevice.vg_safeDistanceBottom()
}

/// /// 底部导航栏高度 +（包括安全区）
public func dsTabBarFullAndSafeHeight() ->CGFloat {
    UIDevice.vg_tabBarFullHeight()
}



/// 当前屏幕比例
public let dsScare = UIScreen.main.scale
/// 画线宽度 不同分辨率都是一像素
public let dsLineHeight = CGFloat(dsScare >= 1 ? 1/dsScare: 1)


/// 屏幕适配-以屏幕宽度为缩放标准
public func dsFitWidth(_ value: CGFloat) -> CGFloat {
    return (value * (dsScreenWidth / 375))
}

/// 屏幕适配-以屏幕高度为缩放标准  [Real 实际的 真实的]
public func dsFitHeight(_ value: CGFloat) -> CGFloat {
    return (value * (dsScreenHeight / 375))
}




// MARK: - 打印输出
public func BMLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
#if DEBUG
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
    let time = formatter.string(from: Date()) // 不需要可以注释
    
    let fileName = (file as NSString).lastPathComponent
    var funcTempName = funcName
    if funcName == "deinit" {
        funcTempName = "🟢🟢🟢deinit🟢🟢🟢"
    }
    
    print("\n\n----------------------------「LOG-BMLog」----------------------------\n\(time) 🔸文件: \(fileName) 🔸行: \(lineNum) 🔸方法: \(funcTempName) \n🟠内容:  \(message)\n-------------------------------「END」------------------------------- \n")
//    print("\n\n----------------------------「LOG-BMLog」----------------------------\n\(time) 🔸文件: \(fileName) 🔸行: \(lineNum) 🔸方法: \(funcTempName) 🔸线程: \(Thread.current)\n🟠内容:  \(message)\n-------------------------------「END」------------------------------- \n")
#endif
}
