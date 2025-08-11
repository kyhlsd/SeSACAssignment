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
    
    func bind(action: @escaping (T) -> Void) {
        action(value)
        self.action = action
    }
}
