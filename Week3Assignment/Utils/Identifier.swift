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
}

extension UICollectionView {
    final func dequeueReusableCell<T: Identifying>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = self.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self)"
            )
        }
        return cell
    }
}

extension UIStoryboard {
    final func instantiateViewController<T: Identifying>(viewControllerType: T.Type = T.self) -> T {
        let bareViewController = self.instantiateViewController(withIdentifier: viewControllerType.identifier)
        guard let viewController = bareViewController as? T else {
            fatalError("Failed to instantiate a ViewController \(viewControllerType.identifier) matching type \(viewControllerType.self)")
        }
        return viewController
    }
}
