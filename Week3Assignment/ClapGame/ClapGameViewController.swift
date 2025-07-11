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
    
    private let clap = "👏"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func inputTextFieldDidEndOnExit(_ sender: UITextField) {
        guard let text = inputTextField.text else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                                              
        let number: Int
        do {
            number = try getValidatedInt(from: text)
        } catch {
            switch error {
            case ValidateIntError.empty:
            case ValidateIntError.nonNumeric:
            case ValidateIntError.nonNatural:
            default:
                break
            }
            return
        }
        
        let result = getClapCountsAndString(number)
        
        numbersLabel.text = result.1
        resultLabel.text = "숫자 \(trimmedText))까지 총 박수는\n\(result.0)번 입니다."
    }
    
    private func getValidatedInt(from text: String) throws -> Int {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            throw ValidateIntError.empty
        }
        guard let number = Int(trimmedText) else {
            throw ValidateIntError.nonNumeric
        }
        if number <= 0 {
            throw ValidateIntError.nonNatural
        }
        
        return number
    }
    
    private func getClapCountsAndString(_ number: Int) -> (Int, String) {
        var numbersString = ""
        var count = 0
        for i in 1...number {
            for numberChar in String(i) {
                if ["3", "6", "9"].contains(numberChar) {
                    count += 1
                    numbersString += clap + "\u{2060}"
                } else {
                    numbersString += String(numberChar) + "\u{2060}"
                }
            }
            numbersString += ", "
        }
        numbersString.removeLast(2)
        return (count, numbersString)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

enum ValidateIntError: Error {
    case empty
    case nonNumeric
    case nonNatural
}
