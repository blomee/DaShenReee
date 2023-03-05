//
//  Color.swift
//  Sport
//
//  Created by Steve on 2021/11/5.
//

import Foundation
import UIKit

public final class  R {
    
    public final class Color {
        static let tabSelect = UIColor.white
        
        static let navBack = UIColor.black
        static let navTitleText = UIColor.black
        
    }
    
    public final class String {
        private init() { }

        // ServerError
        public static let Error_Server_ParseJson           = "服务器返回数据 JSON 解析失败"
        public static let Error_Server_ParseData            = "服务器返回数据格式错误"
        public static let Error_Server_StatusCodeType       = "服务器返回状态码格式错误"
        // ResourceProviderError
        public static let Error_Resource_NotFound           = "没有找到资源文件"
        public static let Error_Resource_Empty              = "资源文件空白"
        public static let Error_Resource_ParseJson          = "资源文件 JSON 解析失败"
        public static let Error_ParsingFailedMsg          = "数据解析失败"
        public static let Error_NetworkUnavailableMsg          = "当前网络不可用，请检查网络设置"

        public static let LiveChatWordCountMaxMsg          = "最多只能输入30个字符哦"
    }
    
    public final class Image {
        
        private init(){
            
        }
        
    }
    
    
    
    public final class Key {
        private init(){}
        public static let KHistory = "KHistory"
        public static let KUserInfor = "KUserInfor"
        public static let KfastLoginInfor = "KfastLogin"
        public static let KisHoverPlay = "KisHoverPlay"
        public static let KEYUUID = "com.dufig.lieying"
    }
    
    
}




extension Notification.Name {
    /// 网络变化通知
    static let NetworkChangeNotification = Notification.Name(rawValue: "NetworkChangeNotification")
    /// 登录
    static let LoginThenRefresh = Notification.Name(rawValue: "LoginThenRefresh")
    /// 当在我的页面中快速登录后，要刷新我的页面数据
    static let refreshMineVc = Notification.Name(rawValue: "refreshMineVc")
    /// 登出
    static let LogoutNotification = Notification.Name(rawValue: "LogoutNotification")
    
    
}

