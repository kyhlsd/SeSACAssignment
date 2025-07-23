//
//  UITableView+Extension.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/22/25.
//

import UIKit

extension UITableView {
    final func dequeueReusableCell<T: Identifying>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = self.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self)"
            )
        }
        return cell
    }
    
    final func register<T: Identifying>(cellType: T.Type = T.self) {
        let xib = UINib(nibName: T.identifier, bundle: nil)
        register(xib, forCellReuseIdentifier: T.identifier)
    }
}
