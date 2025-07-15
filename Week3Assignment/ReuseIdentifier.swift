//
//  ReuseIdentifier.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    final func dequeueReusableCell<T: ReuseIdentifying>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self)"
            )
        }
        return cell
    }
}
