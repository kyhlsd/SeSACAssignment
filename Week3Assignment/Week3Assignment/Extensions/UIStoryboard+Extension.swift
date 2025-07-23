//
//  UIStoryboard+Extension.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/22/25.
//

import UIKit

extension UIStoryboard {
    final func instantiateViewController<T: Identifying>(viewControllerType: T.Type = T.self) -> T {
        let bareViewController = self.instantiateViewController(withIdentifier: viewControllerType.identifier)
        guard let viewController = bareViewController as? T else {
            fatalError("Failed to instantiate a ViewController \(viewControllerType.identifier) matching type \(viewControllerType.self)")
        }
        return viewController
    }
}
