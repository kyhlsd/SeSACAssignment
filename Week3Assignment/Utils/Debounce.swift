//
//  Debounce.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/16/25.
//

import Foundation
import Dispatch

class Debounce<T: Equatable> {
    func input(_ input: T, comparedAgainst current: @escaping @autoclosure () -> (T), timeInterval: TimeInterval, perform: @escaping (T) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            if input == current() { perform(input) }
        }
    }
}
