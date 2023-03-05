//
//  EnvSwitchManager.swift
//  venom
//
//  Created by BLOM on 8/23/22.
//  Copyright © 2022 Venom. All rights reserved.
//

import Foundation
import UIKit

/// 当前设置的环境名称
public let selectNetworkName = "NetworkSettingHost"
/// 当前设置的环境配置
public let kSelectAPIURL = "SelectAPIURL"
/// 保存的环境下标  保存时加1 ,使用时减1
public let kSaveEnvSelectedIndex = "kSaveEnvSelectedIndex"


@objcMembers public class EnvSwitchManager: NSObject {
    /// 单例使用
    public static let shared = EnvSwitchManager()
    ///保证单例调用
    private override init(){ }
    
    public let userDefaults = UserDefaults.init(suiteName: "SwiftNetSwitch")
    
    /// 是否不可修改， YES 不可修改
    public var isEnforce: Bool = false
    
    /// 网络环境
    public var selectedModel = SwitchModel()
    
    /// 环境地址
    public var dataArray = [SwitchModel]() {
        didSet {
            if dataArray.count == 0 {
                return
            }
        }
    }
    
    private var isExitApp : Bool? = false
    
    private var callBack : ((_ model : SwitchModel) -> Void)?
    
    private var controller : UIViewController?
    
    private lazy var button : UIButton = {
        let instance = UIButton.init(type: .custom)
        instance.frame = CGRect.init(x: 0, y: 0, width: 80, height: 44)
        instance.contentHorizontalAlignment = .center
        instance.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        instance.titleLabel?.adjustsFontSizeToFitWidth = true
        instance.setTitleColor(.red, for: .normal)
        instance.setTitleColor(.lightGray, for: .highlighted)
        
        instance.setTitle(self.selectedModel.title, for: .normal)
        instance.addTarget(self, action: #selector(changeNetwork), for: .touchUpInside)
        return instance
    }()

    
    @objc
    public func changeNetwork() {
        
        print("设置前：\(self.selectedModel.title)--\(self.selectedModel.app_api_url)")
        
       let vc = EnvSwitchController()
        vc.dataArray = self.dataArray
       
       vc.configSelected = { [weak self] model in
           guard let `self` = self else { return }
           
          print("设置后：\(self.selectedModel.title)--\(self.selectedModel.app_api_url)")

           self.selectedModel = model
           self.button.setTitle(model.title, for: .normal)
           self.changeNetworkSucc()
           
       }
       
       let nav = UINavigationController.init(rootViewController: vc)
       controller?.present(nav, animated: true, completion: {
           
       })
   }
    
   
   private func changeNetworkSucc(){
       
       callBack?(self.selectedModel)
       guard let ex = isExitApp else {
           return
       }
       if ex {
           exit(0)
       }
       
   }
}
extension EnvSwitchManager {
    
    /// 设置默认环境
    /// - Parameters:
    ///   - defaultIndex: 默认环境下标
    ///   - isenforce: 是否强制默认， true ，为不可修改，每次启动都是这个，  默认 false 为可以修改
    public func setDefaultConfig(defaultIndex: Int, isenforce: Bool = false) {
        self.isEnforce = isenforce
        if self.dataArray.count >= defaultIndex {
        
            if isenforce {
                UserDefaults.standard.set(defaultIndex, forKey: kSaveEnvSelectedIndex)
                AppConfig.shared.currentEnvIndex = defaultIndex
                selectedModel = self.dataArray[defaultIndex-1]
            } else {
                
                let saveIndex = UserDefaults.standard.integer(forKey: kSaveEnvSelectedIndex)
                if saveIndex <= 0 {
//                    UserDefaults.standard.set(defaultIndex, forKey: kSaveEnvSelectedIndex)
                    AppConfig.shared.currentEnvIndex = defaultIndex
                    selectedModel = self.dataArray[defaultIndex-1]
                } else {
                    AppConfig.shared.currentEnvIndex = saveIndex
                    selectedModel = self.dataArray[saveIndex-1]
                }
                
            }
            BMLog("🟩🟩🟩🟩🟩🟩🟩🟩🟩 当前环境: \(self.selectedModel.title)  🟩🟩🟩🟩🟩🟩🟩🟩🟩")
        }
        
    }
    
    
      /// 添加到导航栏
    /// - Parameters:
    ///   - vc: 当前VC
    ///   - complete: 完成回调
    ///   - exitApp: 是否退出APP
    public func configWithNavBar(_ vc : UIViewController,
                                 _ exitApp : Bool? = false,
                                 _ complete : @escaping ((_ model : SwitchModel) -> Void)){
        isExitApp = exitApp
        callBack = complete
        controller = vc
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        
    }
    
}
