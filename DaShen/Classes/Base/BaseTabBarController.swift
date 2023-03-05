//
//  BaseTabBarController.swift
//  BMSwiftTools
//
//  Created by BLOM on 5/9/22.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addController()
    }
    
    
    func addController() {
        //设置自己的tabbar
        setValue(BaseTabBar(), forKey: "tabBar")
        
        //设置底部导航栏的颜色
        tabBar.barTintColor = UIColor.green
        
        addChild("大厅", "wifi", "wifi", HomeViewController.self)
        addChild("客服", "wifi", "wifi", KeFuViewController.self)
        addChild("预测", "thumb_pic", "thumb_pic", YuCeViewController.self)
        addChild("我的", "thumb_pic", "thumb_pic", MeViewController.self)
    }

    func addChild(_ title: String,_ image: String, _ selectedImage: String,_ type: UIViewController.Type) {
        let child = UINavigationController(rootViewController: type.init())
        child.title = title
        child.tabBarItem.title = title
        //设置选中时的文字背景
        child.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .selected)
        child.tabBarItem.image = UIImage.init(named: image)
        child.tabBarItem.selectedImage = UIImage(named: selectedImage)
        addChild(child)
    }

}
