//
//  ClapGameViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/11/25.
//

import UIKit
import Toast

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
                view.makeToast("입력창이 비었습니다.")
            case ValidateIntError.nonNatural:
                view.makeToast("자연수만 입력 가능합니다.")
            default:
                view.makeToast("알 수 없는 에러가 발생했습니다.")
                print(error.localizedDescription)
            }
            return
        }
        
        let result = getClapCountsAndString(number)
        
        numbersLabel.text = result.1
        resultLabel.text = "숫자 \(trimmedText)까지 총 박수는\n\(result.0)번 입니다."
    }
    
    private func getValidatedInt(from text: String) throws -> Int {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            throw ValidateIntError.empty
        }
        guard let number = Int(trimmedText), number > 0 else {
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
    case nonNatural
}
