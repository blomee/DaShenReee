//
//  MineCommon.swift
//  venom
//
//  Created by dd on 21/1/22.
//

import Foundation
//import AttributedString
//import EnzoGo

///加密
var kEN: String = "1"

public func attributeImageString (imageName : String, string : String) -> NSMutableAttributedString {
    let attributedStr = NSMutableAttributedString()
    
    let bubbleTeaAttachment = NSTextAttachment()
    bubbleTeaAttachment.image = UIImage(named: imageName)
    bubbleTeaAttachment.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
    attributedStr.append(NSAttributedString(attachment: bubbleTeaAttachment))
    let string1 = NSAttributedString(string: " ")
    attributedStr.append(string1)
    
    let string = NSAttributedString(
        string: string,
        attributes: [
            NSAttributedString.Key.font: FontWeight(12, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#333333") ?? UIColor.black
        ]
    )
    attributedStr.append(string)
    return attributedStr
}

public func attributeImageFontAndString (imageName : String, string : String, font: UIFont) -> NSMutableAttributedString {
    let attributedStr = NSMutableAttributedString()
    
    let bubbleTeaAttachment = NSTextAttachment()
    bubbleTeaAttachment.image = UIImage(named: imageName)
    bubbleTeaAttachment.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
    attributedStr.append(NSAttributedString(attachment: bubbleTeaAttachment))
    let string1 = NSAttributedString(string: " ")
    attributedStr.append(string1)
    
    let string = NSAttributedString(
        string: string,
        attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "333333", alpha: 0.8) ?? UIColor.red
        ]
    )
    attributedStr.append(string)
    return attributedStr
}


public func attributeImageStringFont (imageName : String, string : String, font : UIFont, width: Int, height: Int, color: UIColor) -> NSMutableAttributedString {
    let attributedStr = NSMutableAttributedString()
    
    let bubbleTeaAttachment = NSTextAttachment()
    bubbleTeaAttachment.image = UIImage(named: imageName)
    bubbleTeaAttachment.bounds = CGRect(x: 0, y: 0, width: width, height: height)
    attributedStr.append(NSAttributedString(attachment: bubbleTeaAttachment))
    let string1 = NSAttributedString(string: " ")
    attributedStr.append(string1)
    
    let string = NSAttributedString(
        string: string,
        attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
    )
    attributedStr.append(string)
    return attributedStr
}


//    self.delayWithSeconds(0.2) { [self] in
//    }
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

@available(iOSApplicationExtension, unavailable)
public func openAppSettings(completionHandler: ((_ success: Bool) -> Void)? = nil) {
    guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else {
        completionHandler?(false)
        return
    }
    guard UIApplication.shared.canOpenURL(appSettingsURL) else {
        completionHandler?(false)
        return
    }
    UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: completionHandler)
}






//MARK: -----去掉小数点后的0
func quXiaoShuDianHouDeLing(numberString:String) -> String {
    var outNumber = numberString
    var i = 1
    
    if numberString.contains("."){
        while i < numberString.count{
            if outNumber.hasSuffix("0") {
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                i = i + 1
            } else {
                break
            }
        }
        if outNumber.hasSuffix("."){
            outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
        }
        return outNumber
    } else {
        return numberString
    }
}

/// 传入数字 ，返回大于4个字符的加 w 字符串
/// - Parameter value: 需要转换的 数值
/// - Returns: 转换后的字符串
public func wUnitConversion(value: Int, bigChar: Bool = false) -> String {
    var string = "0"
    if value > 9999 {
        let tempValue = Float(value)/10000
        string = String(format: "%.2f%@", tempValue, bigChar == true ? "万" : "w")
    } else {
        string = "\(value)"
    }
    return string
}

/// 准确的小数尾截取 - 没有进位(不会四舍五入)    超过4位数，自动添加 【万】   ，小数点后面的0  会自动去掉
/// - Parameter base: 保留的小数点位数
/// - Returns: 返回结果字符串
func preciseConvertString(num: Double, base: Double = 2) -> String {
    
    if num > 9999 {
        let wanNum = num/10000
        let numStr = preciseConvertString(num: wanNum, base: base)
        return "\(numStr)万"
    }
    
    let tempCount: Double = pow(10, base)
    let temp = num * tempCount
    let target = Double(Int(temp))
    let stepone = target/tempCount
    if stepone.truncatingRemainder(dividingBy: 1) == 0 {
        return String(format: "%.0f", stepone)
    } else {
        return "\(stepone)"
    }
}

//MARK: ---金额分隔符
/**
 * 将字符串每隔数位用分割符隔开
 *
 * @param source 目标字符串
 * @param gap    相隔位数，默认为3
 * @param gap    分割符，默认为逗号
 * @return       用指定分隔符每隔指定位数隔开的字符串
 *
 */
func showInComma(source: String, gap: Int=3, seperator: Character=",") -> String {
    var temp = source
    /* 获取目标字符串的长度 */
    let count = temp.count
    /* 计算需要插入的【分割符】数 */
    let sepNum = count / gap
    /* 若计算得出的【分割符】数小于1，则无需插入 */
    guard sepNum >= 1 else {
        return temp
    }
    /* 插入【分割符】 */
    for i in 1...sepNum {
        /* 计算【分割符】插入的位置 */
        let index = count - gap * i
        /* 若计算得出的【分隔符】的位置等于0，则说明目标字符串的长度为【分割位】的整数倍，如将【123456】分割成【123,456】，此时如果再插入【分割符】，则会变成【,123,456】 */
        guard index != 0 else {
            break
        }
        /* 执行插入【分割符】 */
        temp.insert(seperator, at: temp.index(temp.startIndex, offsetBy: index))
    }
    return temp
}



/// 获取拼音首字母（大写字母）
func findFirstLetterFromString(aString: String) -> String {
    if aString.isEmpty {
        return aString
    }
    //转变成可变字符串
    let mutableString = NSMutableString.init(string: aString)
    
    //将中文转换成带声调的拼音
    CFStringTransform(mutableString as CFMutableString, nil,      kCFStringTransformToLatin, false)
    
    //去掉声调
    let pinyinString = mutableString.folding(options:          String.CompareOptions.diacriticInsensitive, locale:   NSLocale.current)
    
    //将拼音首字母换成大写
    let strPinYin = polyphoneStringHandle(nameString: aString,    pinyinString: pinyinString).uppercased()
    
    //截取大写首字母
    let firstString = strPinYin.substring(to:strPinYin.index(strPinYin.startIndex, offsetBy: 1))
    
    //判断首字母是否为大写
    let regexA = "^[A-Z]$"
    let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
    return predA.evaluate(with: firstString) ? firstString : "#"
}

/// 多音字处理，根据需要添自行加
func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
    if nameString.hasPrefix("长") {return "chang"}
    if nameString.hasPrefix("沈") {return "shen"}
    if nameString.hasPrefix("厦") {return "xia"}
    if nameString.hasPrefix("地") {return "di"}
    if nameString.hasPrefix("重") {return "chong"}
    return pinyinString
}


/// 弹窗公共方法
/// - Parameters:
///   - containerView: 承载视图
///   - view: 弹窗视图
///   - isDismiss: 点击周边是否可消失， 默认不消失
func alertCommon(_ containerView: UIView, _ view: UIView, _ isDismiss: Bool = false, _ backColor: UIColor = UIColor.black.withAlphaComponent(0.5)) {
    let layout: BaseAnimator.Layout = .center(.init())
    let animator: PopupViewAnimator = ZoomInOutAnimator(layout: layout)
    
    let popupView = PopupView(containerView: containerView, contentView: view, animator: animator)
    //配置交互
    popupView.isDismissible = isDismiss
    popupView.isInteractive = true
    //可以设置为false，再点击弹框中的button试试？
    //        popupView.isInteractive = false
    popupView.isPenetrable = false
    
    let backgroundStyle: PopupView.BackgroundView.BackgroundStyle = .solidColor
    let backgroundEffectStyle = UIBlurEffect.Style.light
    let backgroundColor = backColor
    //- 配置背景
    popupView.backgroundView.style = backgroundStyle
    popupView.backgroundView.blurEffectStyle = backgroundEffectStyle
    popupView.backgroundView.color = backgroundColor
    popupView.display(animated: true, completion: nil)
}

/// 生成一个1~365的随机数 包括1和365
///
/// - Returns: 随机生成的数
func getRandomNum() -> NSInteger {
    let randomNum = NSInteger(arc4random()%365) + 1;
    return randomNum;
}



/// 判断是不是当天首次进入APP
func isFirstIntoAppToday() -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    let sendDate = Date()
    //今天时间
    let locationString = dateFormatter.string(from: sendDate)
    //上次存入时间
    let lastString = UserDefaults.standard.object(forKey: "QDAOFIRSTINAPP") as? String
    //更新存入的时间
    UserDefaults.standard.setValue(locationString, forKey: "QDAOFIRSTINAPP")
    UserDefaults.standard.synchronize()
    BMLog("todayTime--->\(locationString)\nlastTime------->\(String(describing: lastString))")
    if locationString != lastString {
        return true
    } else {
        return false
    }
}
