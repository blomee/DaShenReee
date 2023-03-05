//
//  DelayedExecTimer.swift
//  venom
//
//  Created by BLOM on 6/17/22.
//  Copyright © 2022 Venom. All rights reserved.
//


/// 延时执行 可取消
/// 例如 delayExecTimer(3) { print(" 3秒后输出") }
///  取消延时执行     let task = delayExecTimer(5) { print("拨打 110") }    cancelExecTimer(task)      先保留⼀个对 Task 的引⽤，然后调⽤ cancel
import Foundation
import UIKit

typealias Task = (_ cancel: Bool) -> Void

@discardableResult
func delayExecTimer(_ time:TimeInterval, task: @escaping () -> ()) -> Task? {
    
    // later 接收一个 block 并且在 某个时间后执行
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure:(() -> Void)? = task
    var result: Task?
    
    // 创建 Task 类型封装执行逻辑
    let delayClosure: Task = { cancel in
        if let internalClosure = closure {
            if cancel == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayClosure
    
    // Later 后执行
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
}

func cancelExecTimer(_ task: Task?) {
    task?(true)
}
