//
//  BMIViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit

class BMIViewController: UIViewController {
    let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "키를 입력해주세요.(cm)"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "몸무게를 입력해주세요. (kg)"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("클릭", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "여기에 결과를 보여주세요"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    func configureHierarchy() {
        view.addSubview(heightTextField)
        view.addSubview(weightTextField)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func resultButtonTapped() {
        var wrongField = "키는 "
        do {
            let height = try getValidNumber(heightTextField.text, min: 100, max: 300) / 100
            wrongField = "몸무게는 "
            let weight = try getValidNumber(weightTextField.text, min: 20, max: 250)
            
            let bmi = getBMI(height: height, weight: weight)
            
            let formatted = Formatters.NumberFormatters.twoDemicalFormatter.string(from: NSNumber(value: bmi)) ?? ""
            resultLabel.text = "BMI : " + formatted
            
            view.endEditing(true)
        } catch {
            let message = wrongField + error.errorMessage
            resultLabel.text = message
            showDefaultAlert(title: "입력 오류", message: message)
        }
    }
    
    private func getValidNumber(_ text: String?, min: Double, max: Double) throws(InputValidationError) -> Double {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.getNumber(trimmed)
        try InputValidationHelper.validateRange(number, min: min, max: max)
        return number
    }
    
    // height : m , weight : kg 기준
    private func getBMI(height: Double, weight: Double) -> Double {
        return weight / (height * height)
    }
}
