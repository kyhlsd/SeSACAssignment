//
//  Identifier.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

protocol Identifying {
    static var identifier: String { get }
}

extension Identifying {
    static var identifier: String {
        return String(describing: self)
    }
}
