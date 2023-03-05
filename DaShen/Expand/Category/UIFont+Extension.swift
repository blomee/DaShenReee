//
//  UIFont+Extension.swift
//  venom
//
//  Created by steve on 2022/1/19.
//

import Foundation
import UIKit

public enum Weight {
    case medium
    case semibold
    case light
    case ultralight
    case regular
    case thin
    case Din
    case Dinbold
}


///根据屏幕自适应字体参数 16*FontFit
public let FontFit = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375


/// pingfang-sc 字体
public func FontWeight(_ size: CGFloat, weight: Weight) -> UIFont {
    var name = ""
    switch weight {
    case .medium:
        name = "PingFangSC-Medium"
    case .semibold:
        name = "PingFangSC-Semibold"
    case .light:
        name = "PingFangSC-Light"
    case .ultralight:
        name = "PingFangSC-Ultralight"
    case .regular:
        name = "PingFangSC-Regular"
    case .thin:
        name = "PingFangSC-Thin"
    case.Dinbold:
        name = "DINCondensed-Bold"
    case .Din:
        name = "DIN Condensed"
    }
    return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
}


