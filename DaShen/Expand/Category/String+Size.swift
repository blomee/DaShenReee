

import Foundation
import UIKit

// MARK: -  尺寸计算
extension String {
    
    /// 计算字符串尺寸
    ///
    /// - Parameters:
    ///   - size: 限定的size
    ///   - font: 字体
    /// - Returns: 计算出的尺寸
    public func bm_size(with size: CGSize, font: UIFont) -> CGSize {
        if isEmpty {
            return .zero
        }
        let attributes = [NSAttributedString.Key.font: font]
        return (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    /// 计算字符串的高度
    ///
    /// - Parameters:
    ///   - width: 限定的宽度
    ///   - font: 字体
    /// - Returns: 计算出的高度
    public func bm_height(with width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return bm_size(with: size, font: font).height
    }
    
    /// 计算字符串的宽度
    ///
    /// - Parameter font: 字体
    /// - Returns: 计算出的宽度
    public func bm_width(with font: UIFont) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        return bm_size(with: size, font: font).width
    }
    
    
    
    /// String计算文字区域
    public func getRect(_ font: UIFont, _ width: CGFloat) -> CGRect {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect
    }
    
}




