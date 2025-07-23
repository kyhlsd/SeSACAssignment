//
//  Keyboard.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/22/25.
//

import Foundation

@objc
protocol UpdateBottomConstraintProtocol: AnyObject {
    @objc func handleKeyboardWillShow(_ notification: Notification)
    @objc func handleKeyboardWillHide(_ notification: Notification)
    func updateBottomConstraint(with constant: CGFloat, animationDuration: TimeInterval)
}
