//
//  UICollectionView+Extension.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import UIKit

extension UICollectionView {
    func register<T: Identifying>(cellType: T.Type = T.self) {
        register(cellType, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: Identifying>(cellType: T.Type = T.self, for indexPath: IndexPath) -> T {
        let bareCell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self)"
            )
        }
        return cell
    }
}
