//
//  ExampleProvider.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 2017/2/9.
//  Copyright © 2018年 Egg Swift. All rights reserved.
//

import UIKit
//import ESTabBarController

enum ExampleProvider {
    
    
    
    static func customBouncesStyle() -> ExampleNavigationController {
        let tabBarController = ESTabBarController()
        let v1 = HomeViewController()
        let v2 = KeFuViewController()
        let v3 = YuCeViewController()
        let v4 = MeViewController()
        v1.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "大厅", image: UIImage(named: "me"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "客服", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "预测", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "Example"
        return navigationController
    }
    
}
