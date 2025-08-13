//
//  UIViewController+Extension.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/26/25.
//

import UIKit

extension UIViewController {
    func showDefaultAlert(title: String, message: String, isDark: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = isDark ? .dark : .unspecified
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
