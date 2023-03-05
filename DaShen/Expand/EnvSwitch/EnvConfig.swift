//
//  EnvConfig.swift
//  venom
//
//  Created by BLOM on 8/23/22.
//  Copyright © 2022 Venom. All rights reserved.
//

import Foundation


var MainUrl: String {
    return EnvSwitchManager.shared.selectedModel.app_api_url
}


var IsAppStore: Bool {
    ///上架包 true  超级签包 false
    return false
}


//var UmengKey = "61c950afe0f9bb492bacf6a8"
var UmengKey = "6242aa700059ce2bad0ef3c6" ///"62cd496505844627b5e630f4"
///GDT
var User_action_set_id = "1200806761"
var AppSecretKey = "8d8fddc672481a754745d39992d0558c"
//乐播云
var LbAppId = "21503"
var LbAppSecret = "76f7da0060c6ea8d859332b5912c6dc5"


///全功能官方包 iosofficial 5.1.1
///渠道 JI9WTNP9 9.1.1
///渠道 OIZZABCZ 10.1.1
///
//   H6CH2C6L
//   2SHU3NZZ
//   E5UZ5EXM
let kCHANNEL_NO = "iosofficial"


class EnvConfig {
    static func setConfig(){
        
        //  1  (正式)生产环境   2、3、4 测试环境    5 UAT环境    6 生产环境2
        let defaultIndex = 1   // 从1开始，设置默认域名环境， 打包手动修改    没有手动切换过域名的时候有效
        
        let model1 = SwitchModel()
        model1.envIndex = 1
        model1.title = "正式环境"
        model1.app_api_url_array =  ["https://api.mliveplus.com/api/", "https://yy-media.cn/api/"]
        
        
        let model2 = SwitchModel()
        model2.envIndex = 2
        model2.title = "TEST1环境"
        model2.app_api_url_array =  ["http://test1-api.sun8tv.com/api/"]
        
        
        let model3 = SwitchModel()
        model3.envIndex = 3
        model3.title = "TEST2环境"
        model3.app_api_url_array =  ["http://test2-api.sun8tv.com/api/"]
        
        let model4 = SwitchModel()
        model4.envIndex = 4
        model4.title = "TEST3环境"
        model4.app_api_url_array =  ["http://test3_api.sun8tv.com/api/", "http://test3-api2.sun8tv.com/api/", "http://test3-api3.sun8tv.com/api/"]
        
        let model5 = SwitchModel()
        model5.envIndex = 5
        model5.title = "UAT环境"
        model5.app_api_url_array =  ["https://uat-api.sun8tv.com/api/"]
        
        let model6 = SwitchModel()
        model6.envIndex = 6
        model6.title = "正式环境2"
        model6.app_api_url_array =  ["https://api.zhou618.com/api/"]
        
        let model7 = SwitchModel()
        model7.envIndex = 7
        model7.title = "测试维护环境"
        model7.app_api_url_array =  ["https://test1-api.sun8tv.com/api/"]
        
        
        
        let apiArray = [model1, model2, model3, model4, model5, model6, model7]
        EnvSwitchManager.shared.dataArray = apiArray
        
        EnvSwitchManager.shared.setDefaultConfig(defaultIndex: defaultIndex >= EnvSwitchManager.shared.dataArray.count ? EnvSwitchManager.shared.dataArray.count : defaultIndex)
        
    }
}






/// 切换环境模型
@objcMembers public class SwitchModel: NSObject, Convertible {
    required public override init() {}
    /// 名称
    var title = ""
    
    /// URL数组  url 从这里取数据
    var app_api_url_array: Array<String>?
    
    /// api_url
    var app_api_url: String {
        get {
            if AppConfig.shared.currentEnvIndex == envIndex {
//                let mainUrl: String = VNConfigModel.getBaseApiURL()
//                if mainUrl.count > 0 {
//                    return mainUrl
//                }
            }
            return app_api_url_array?.first ?? ""
        }
    }
    
    /// 友盟Key
    var umengKey = ""
    /// 环境下标
    var envIndex = 0
    
}
