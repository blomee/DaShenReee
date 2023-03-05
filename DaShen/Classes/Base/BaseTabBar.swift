//
//  BaseTabBar.swift
//  BMSwiftTools
//
//  Created by BLOM on 5/9/22.
//

import UIKit

class BaseTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for button in subviews where button is UIControl {
            var frame = button.frame
            frame.origin.y = -10
            button.frame = frame
        }
    }

}
