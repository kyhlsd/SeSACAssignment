//
//  ClapGameViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/11/25.
//

import UIKit

class ClapGameViewController: UIViewController {

    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var numbersLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func inputTextFieldDidEndOnExit(_ sender: UITextField) {
        guard let text = inputTextField.text else { return }
        
        // TODO: validate 함수로 묶기
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            print("empty")
            return
        }
        guard let number = Int(trimmedText) else {
            print("숫자만 입력")
            return
        }
        if number <= 0 {
            print("자연수만 입력")
            return
        }
        
        var count = 0
        for i in 1...number {
            let numberString = String(i)
            for numberChar in numberString {
                if ["3", "6", "9"].contains(numberChar) {
                    count += 1
                }
            }
        }
        print(count)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
