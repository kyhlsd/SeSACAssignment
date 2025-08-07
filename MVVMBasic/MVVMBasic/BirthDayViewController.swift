//
//  BirthDayViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

class BirthDayViewController: UIViewController {
    let yearTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "년도를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "년"
        return label
    }()
    let monthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "월을 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        return label
    }()
    let dayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "일을 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        return label
    }()
    let resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle( "클릭", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "여기에 결과를 보여주세요"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    func configureHierarchy() {
        view.addSubview(yearTextField)
        view.addSubview(yearLabel)
        view.addSubview(monthTextField)
        view.addSubview(monthLabel)
        view.addSubview(dayTextField)
        view.addSubview(dayLabel)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        yearTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField)
            make.leading.equalTo(yearTextField.snp.trailing).offset(12)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(monthTextField)
            make.leading.equalTo(monthTextField.snp.trailing).offset(12)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(monthTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayTextField)
            make.leading.equalTo(dayTextField.snp.trailing).offset(12)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(dayTextField.snp.bottom).offset(20)
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
        validateBirthday(year: yearTextField.text, month: monthTextField.text, day: dayTextField.text) { value in
            let dateDifference = getDateDifference(from: value, to: Date())
            
            if dateDifference == 0 {
                resultLabel.text = "D-Day입니다."
            } else {
                resultLabel.text = "D+\(dateDifference)일입니다."
            }
            view.endEditing(true)
        } failureHandler: { errorMessage in
            resultLabel.text = errorMessage
        }
    }
    
    private func getValidInteger(_ text: String?, min: Int, max: Int) throws(InputValidationError) -> Int {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.getIntegerFromText(trimmed)
        try InputValidationHelper.validateRange(number, min: min, max: max)
        return number
    }
    
    private func getMaxDay(year: Int, month: Int) -> Int {
        switch month {
        case 1,3,5,7,8,10,12:
            return 31
        case 4,6,9,11:
            return 30
        case 2:
            return isLeapYear(year: year) ? 29 : 28
        default:
            return -1
        }
    }
    
    private func isLeapYear(year: Int) -> Bool {
        if year % 4 == 0 {
            if year % 100 == 0 {
                return year % 400 == 0
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    private func getDateDifference(from firstDate: Date, to secondDate: Date) -> Int {
        let component = Calendar.current.dateComponents([.day], from: firstDate, to: secondDate)
        return component.day ?? 9999999
    }
    
    private func validateBirthday(year: String?, month: String?, day: String?, successHandler: (Date) -> Void, failureHandler: (String) -> Void) {
        let calendar = Calendar.current
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        let currentDay = calendar.component(.day, from: today)
        
        var wrongField = "연도는 "
        do {
            let year = try getValidInteger(yearTextField.text, min: 1900, max: currentYear)
            
            wrongField = (year == currentYear) ? "해당 연도에서 달은 " : "달은 "
            let maxMonth = (year == currentYear) ? currentMonth : 12
            let month = try getValidInteger(monthTextField.text, min: 1, max: maxMonth)
            
            wrongField = (year == currentYear && month == currentMonth) ? "해당 연도와 달에서 일은 " : "일은 "
            let maxDay = (year == currentYear && month == currentMonth) ? currentDay : getMaxDay(year: year, month: month)
            let day = try getValidInteger(dayTextField.text, min: 1, max: maxDay)
            
            var dateString = String(year)
            dateString += String(format: "%02d", month)
            dateString += String(format: "%02d", day)
            
            guard let date = Formatters.DateFormatters.yyyyMMddFormatter.date(from: dateString) else {
                throw InputValidationError.unknown
            }
            
            successHandler(date)
        } catch let error as InputValidationError {
            let errorMessage = wrongField + error.errorMessage
            failureHandler(errorMessage)
        } catch { }
    }
}
