//
//  Observable.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import Foundation

final class Observable<T> {
    var value: T {
        didSet {
            action?(value)
        }
    }
    
    private var action: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(isLazy: Bool = true, action: @escaping (T) -> Void) {
        if !isLazy { action(value) }
        self.action = action
    }
}
