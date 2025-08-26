//
//  UIViewController+Extension.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/26/25.
//

import UIKit

extension UIViewController {
    func showDefaultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
