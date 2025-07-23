//
//  UITableView+Extension.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit

extension UITableView {
    func register<T: Identifying>(cellType: T.Type = T.self) {
        register(cellType, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: Identifying>(cellType: T.Type = T.self, for indexPath: IndexPath) -> T {
        let bareCell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self)"
            )
        }
        return cell
    }
}
