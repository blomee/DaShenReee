//
//  TimeManager.swift
//  venom
//
//  Created by BLOM on 9/8/22.
//  Copyright © 2022 Venom. All rights reserved.
//

import UIKit
import Foundation



class TimeManager: NSObject {
    
    
    /// 计算当天跟某一天的天数差
    /// - Parameter dateStr: 固定日期
    /// - Returns: 返回相差天数
    static func checkDiff(dateStr: String) -> Int {
      // 计算两个日期差，返回相差天数
      let formatter = DateFormatter()
      let calendar = Calendar.current
      formatter.dateFormat = "yyyy-MM-dd"

      // 当天
      let today = Date()
      let startDate = formatter.date(from: formatter.string(from: today))
      
      // 固定日期
      let endDate = formatter.date(from: dateStr)
      
      let diff: DateComponents = calendar.dateComponents([.day], from: startDate!, to: endDate!)
      return diff.day!
    }
    
    
    /// 计算两个字符串形式的日期的天数差
    /// - Parameter dateStr: 固定日期
    /// - Returns: 返回相差天数
    static func dateDiff(dateStr1: String, dateStr2: String) -> Int {
      // 计算两个日期差，返回相差天数
      let formatter = DateFormatter()
      let calendar = Calendar.current
      formatter.dateFormat = "yyyy-MM-dd"
      let today = Date()
      
      // 开始日期
      let startDate = formatter.date(from: dateStr1)
      
      // 结束日期
      let endDate = formatter.date(from: dateStr2)
      let diff:DateComponents = calendar.dateComponents([.day], from: startDate!, to: endDate!)
      return diff.day!
    }
    
    
}



//MARK: --- UTC 和本地时间转换
enum TimeStyleWithUTC {
    case dateWithYMD  //年月日时分
    case dateYMD  //年月日
    case dateWithHM    //时分
}

/// 指定年月的开始日期
public func startOfMonth(year: Int, month: Int) -> Date {
    let calendar = NSCalendar.current
    var startComps = DateComponents()
    startComps.day = 1
    startComps.month = month
    startComps.year = year
    let startDate = calendar.date(from: startComps)!
    return startDate
}

/// 指定年月的结束日期
public func endOfMonth(year: Int, month: Int, returnEndTime: Bool = false) -> Date {
    let calendar = NSCalendar.current
    var components = DateComponents()
    components.month = 1
    if returnEndTime {
        components.second = -1
    } else {
        components.day = -1
    }

    let endOfYear = calendar.date(byAdding: components,
                                  to: startOfMonth(year: year, month: month))!
    return endOfYear
}

/// 本月开始日期
public func startOfCurrentMonth() -> Date {
    let date = Date()
    let calendar = NSCalendar.current
    let components = calendar.dateComponents(
        Set<Calendar.Component>([.year, .month]), from: date
    )
    let startOfMonth = calendar.date(from: components)!
    return startOfMonth
}

/// 本月结束日期
public func endOfCurrentMonth(returnEndTime: Bool = false) -> Date {
    let calendar = NSCalendar.current
    var components = DateComponents()
    components.month = 1
    if returnEndTime {
        components.second = -1
    } else {
        components.day = -1
    }

    let endOfMonth = calendar.date(byAdding: components, to: startOfCurrentMonth())!
    return endOfMonth
}

//MARK: --- 获取当前日期
public func getCurrentDate() -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    let dateString = formatter.string(from: Date())
    return dateString
}

//MARK: ----- 根据日期得到星期几
public func getDayOfWeek(_ today:String) -> String? {
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    guard let todayDate = formatter.date(from: today) else { return nil }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday,from: todayDate)
    var week:String?
    switch weekDay {
    case 1:
        week = "星期日"
    case 2:
        week = "星期一"
    case 3:
        week = "星期二"
    case 4:
        week = "星期三"
    case 5:
        week = "星期四"
    case 6:
        week = "星期五"
    case 7:
        week = "星期六"
    default:
        break
    }
    return week
}



func getLocalDate(from UTCDate: String, type:TimeStyleWithUTC) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    let yourDate = dateFormatter.date(from: UTCDate)

    // change to local time zone from your format
    if type == .dateWithYMD {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    } else if type == .dateYMD {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    } else {
        dateFormatter.dateFormat = "HH:mm"
    }
    dateFormatter.timeZone = TimeZone.current
    let dateString = dateFormatter.string(from: yourDate!)
    
    return dateString
}

//MARK: ---时间字符串转化为date格式
func stringConvertDate(string: String, dateFormat: String="yyyy-MM-dd HH:mm:ss") -> Date {
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: string)
    return date!
}

///日期 -> 字符串
func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: date)
    return date
}





// MARK: - ******************* 时间戳 *******************
/// 获取当前时间戳
/// - Returns: 时间戳
func getCurrentTimestamp() -> Int  {
    //获取当前时间
    let now = Date()
    
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//    print("当前日期时间：\(dformatter.string(from: now))")
    
    //当前时间的时间戳
    let timeInterval:TimeInterval = now.timeIntervalSince1970
    let timeStamp = Int(timeInterval)
//    print("当前时间的时间戳：\(timeStamp)")
    
    return timeStamp
}



//MARK: -根据后台时间戳返回几分钟前，几小时前，几天前
func updateTimeToCurrennTime(timeStamp: Double) -> String {
    ///获取当前的时间戳
    let currentTime = Date().timeIntervalSince1970
//    print(currentTime,   timeStamp, "sdsss")
    ///时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    //let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
    ///时间差
    let reduceTime : TimeInterval = currentTime - timeStamp //timeSta
    ///时间差小于60秒
    if reduceTime < 60 {
        return "刚刚"
    }
    ///时间差大于一分钟小于60分钟内
    let mins = Int(reduceTime / 60)
    if mins < 60 {
        return "\(mins)分钟前"
    }
    let hours = Int(reduceTime / 3600)
    if hours < 24 {
        return "\(hours)小时前"
    }
    let days = Int(reduceTime / 3600 / 24)
    if days < 30 {
        return "\(days)天前"
    }
    ///不满足上述条件---或者是未来日期-----直接返回日期
    let date = NSDate(timeIntervalSince1970: timeStamp)
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    //dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    dfmatter.dateFormat="MM-dd HH:mm"
    return dfmatter.string(from: date as Date)
}







extension String {
    
    /// 时间格式
    public enum TimeFormat: String {
        case normal             = "yyyy-MM-dd HH:mm:ss"
        case yyMdHm             = "yy-MM-dd HH:mm"
        case yyyyMdHm           = "yyyy-MM-dd HH:mm"
        case yMd                = "yyyy-MM-dd"
        case MdHms              = "MM-dd HH:mm:ss"
        case MdHm               = "MM-dd HH:mm"
        case Hms                = "HH:mm:ss"
        case Hm                 = "HH:mm"
        case Md                 = "MM-dd"
        case yyMd               = "yy-MM-dd"
        case YYMMdd             = "yyyyMMdd"
        case yyyyMdHms          = "yyyyMMddHHmmss"
        case yyyyMdHmsS         = "yyyy-MM-dd HH:mm:ss.SSS"
        case yyyyMMddHHmmssSSS  = "yyyyMMddHHmmssSSS"
        case yMdWithSlash       = "yyyy/MM/dd"
        case yM                 = "yyyy-MM"
        case yMdChangeSeparator = "yyyy.MM.dd"
        case yMdChinese         = "yyyy年MM月dd日"
        
        case wcMd                 = "MM/dd"
    }
    
    /// String时间戳转换为特定时间格式
    public func date(_ format: TimeFormat = .normal) -> String {
        if let timeInterval: TimeInterval = TimeInterval.init(self) {
            let date = Date(timeIntervalSince1970: timeInterval)
            let formatter = DateFormatter()
            formatter.dateFormat = format.rawValue
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    /// 将时间戳转成指定的格式
    static func dateString(millisecond: TimeInterval,dateFormatter: String) -> String {
        return DateFormatter().then({$0.dateFormat = dateFormatter}).string(from: Date(timeIntervalSince1970: millisecond/1000))
    }
    
    
    /// 根据某年某月算当月天数
    public func userMonthCalculateDay(month: String) -> [String] {
        var month1 = month
        if let i = month1.firstIndex(of: "年") {
            month1.remove(at: i)
        }
        if let j = month1.firstIndex(of: "月") {
            month1.remove(at: j)
        }
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM"
        let newDate = format.date(from: month1)
        var interval: Double = 0
        var firstDate: Date = Date()
        var lastDate: Date = Date()
        let calendar = NSCalendar.current
        if calendar.dateInterval(of: .month, start: &firstDate, interval: &interval, for: newDate ?? Date()) {
            lastDate = firstDate.addingTimeInterval(interval - 1)
        }
        let newformat = DateFormatter.init()
        newformat.dateFormat = "yyyy-MM-dd"
        let lastString = newformat.string(from: lastDate)
        let lastday = Int(String(lastString.split(separator: "-").last ?? "0"))!

        return (1...lastday).map({ (day)  in
            if day < 10 {
               return "0\(day)日"
            } else {
                return "\(day)日"
            }
        })
    }
    
    
    
    
    // MARK: - ******************* 时间戳转换 *******************
    
    
    /* 使用方法
     let newStr = String.timeIntervalChangeToTimeStr(timeInterval: Double.init(time) ?? 0, "yyyy-MM-dd")
     print("newStr == \(newStr)")
     */
    
    /// 时间戳转成字符串
    /// - Parameters:
    ///   - timeInterval: 时间戳
    ///   - dateFormat: 需要转换的时间格式， 有默认值
    /// - Returns: 返回字符串时间
    static func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        let date:Date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    
    
    /* 使用方法
     let str  = "2020-09-09"
     let time = str.timeStrChangeTotimeInterval("yyyy-MM-dd")
     print("time == \(time)")
     */
    /// 字符串转时间戳
    /// - Parameter dateFormat: 时间格式
    /// - Returns: 返回字符串时间戳
    func timeStrChangeTotimeInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        if self.isEmpty {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: self)
        return String(date!.timeIntervalSince1970)
    }
    
    
    
    
}





