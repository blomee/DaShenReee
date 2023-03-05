//
//  AppConfig.swift
//  venom
//
//  Created by BLOM on 7/30/22.
//  Copyright © 2022 Venom. All rights reserved.
//

import UIKit

class AppConfig  {
    /// AppConfig单例
    static let shared = AppConfig()
    
//    public var myConfig = Config()
//    public var qChips: [QuizChips]?
    
    public var disableGiftAnimation = false
    public var disableEntryAnimation = false

    /// 当前环境
    public var currentEnvIndex: Int = 1
    /// 赛事筛选保存，只保存整个App生命周期
    public var groupGameMattersFilterItems: [String: [IndexPath]]  = [:]
    /// 保存筛选名称
    public var groupGameMattersFilterNames: [String: [String]]  = [:]
    
    /// 是否世界杯赛事页面
    public var isMatchWorldCupPage = false
    
    
    /// 当前主题
//    public var currentTheme = VNThemes.normal
}


