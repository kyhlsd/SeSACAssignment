//
//  Observable.swift
//  Week4Assignment
//
//  Created by 김영훈 on 8/12/25.
//

import Foundation

final class Observable<T> {
    private var action: ((T) -> Void)?
    
    var value: T {
        didSet {
            action?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(isLazy: Bool = true ,action: @escaping ((T) -> Void)) {
        if !isLazy { action(value) }
        self.action = action
    }
}
