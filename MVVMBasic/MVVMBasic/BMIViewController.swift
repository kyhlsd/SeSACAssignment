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
        getBMI(height: heightTextField.text, weight: weightTextField.text) { value in
            resultLabel.text = "BMI : " + value.formatted()
            view.endEditing(true)
        } failureHandler: { errorMessage in
            resultLabel.text = errorMessage
            showDefaultAlert(title: "입력 오류", message: errorMessage)
        }
    }
    
    private func getValidNumber(_ text: String?, min: Double, max: Double) throws(InputValidationError) -> Double {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.getNumberFromText(trimmed)
        try InputValidationHelper.validateRange(number, min: min, max: max)
        return number
    }
    
    private func getBMI(height: String?, weight: String?, successHandler: (Double) -> Void, failureHandler: (String) -> Void) {
        var wrongField = "키는 "
        do {
            // height : m , weight : kg 기준
            let height = try getValidNumber(height, min: 100, max: 300) / 100
            wrongField = "몸무게는 "
            let weight = try getValidNumber(weight, min: 20, max: 250)
            
            let bmi = weight / (height * height)
            successHandler(bmi)
        } catch {
            let message = wrongField + error.errorMessage
            failureHandler(message)
        }
    }
}
