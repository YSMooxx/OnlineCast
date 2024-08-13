//
//  Debouncer.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

class Debouncer {
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }
    
    func debounce(block: @escaping () -> Void) {
        workItem.cancel()
        
        workItem = DispatchWorkItem {
            block()
        }
        
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}

// 使用示例
let debouncer = Debouncer(delay: 5) // 延迟时间为2秒


class Throttler {
    private var isReady = true
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval

    init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    func throttle(block: @escaping () -> Void) {
        guard isReady else { return }
        
        isReady = false
        block()
        
        queue.asyncAfter(deadline: .now() + minimumDelay) { [weak self] in
            self?.isReady = true
        }
    }
}

// 使用示例
let throttler = Throttler(minimumDelay: 0.5)
let throttler1 = Throttler(minimumDelay: 1)

