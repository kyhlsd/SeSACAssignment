//
//  UpDownHomeViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit

class UpDownHomeViewController: UIViewController {

    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var warningLabel: UILabel!
    
    private enum UpDownNumberError: Error {
        case empty
        case nonNatural
        case outOfRange
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        configureNumberTextField()
    }

    private func configureNumberTextField() {
        numberTextField.layer.addBorder([.bottom], color: .white, width: 2)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        do {
            let number = try getValidNumber()
            presentUpDownGameViewController(number: number)
        } catch UpDownNumberError.empty {
            warningLabel.text = "입력창이 비었습니다."
        } catch UpDownNumberError.nonNatural {
            warningLabel.text = "자연수만 입력해주세요."
        } catch UpDownNumberError.outOfRange {
            warningLabel.text = "1 ~ 1,000의 수만 입력 가능합니다."
        } catch {
            warningLabel.text = "알 수 없는 에러가 발생했습니다."
        }
    }
    
    private func getValidNumber() throws -> Int  {
        let trimmed = numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if trimmed.isEmpty {
            throw UpDownNumberError.empty
        }
        
        guard let number = Int(trimmed) else {
            throw UpDownNumberError.nonNatural
        }
        
        if number < 1, number > 1000 {
            throw UpDownNumberError.outOfRange
        }
        
        return number
    }
    
    private func presentUpDownGameViewController(number: Int) {
        let storyboard = UIStoryboard(name: "UpDown", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: UpDownGameViewController.identifier) { coder -> UpDownGameViewController in
            return .init(coder: coder, targetNumber: Int.random(in: 1...number)) ?? .init(targetNumber: Int.random(in: 1...number))
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // numberTextFieldDidEndOnExit, TapGegsture
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
