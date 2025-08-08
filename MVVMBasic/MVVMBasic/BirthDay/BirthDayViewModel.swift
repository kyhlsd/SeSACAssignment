//
//  BirthDayViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/8/25.
//

import Foundation

final class BirthDayViewModel {
    var inputTexts = BirthDayInputs(year: nil, month: nil, day: nil) {
        didSet {
            validateBirthday(year: inputTexts.year, month: inputTexts.month, day: inputTexts.day)
        }
    }
    
    var updateView: ((String) -> Void)?
    
    private var birthDay = Date() {
        didSet {
            let difference = getDateDifference(from: birthDay, to: Date())
            let resultString = getDDayText(difference: difference)
            updateView?(resultString)
        }
    }
    
    private var errorMessage = "" {
        didSet {
            updateView?(errorMessage)
        }
    }
    
    private func getValidInteger(_ text: String?, min: Int, max: Int) throws(InputValidationError) -> Int {
        let trimmed = try InputValidationHelper.getTrimmedText(text)
        let number = try InputValidationHelper.convertTypeFromText(trimmed, type: Int.self)
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
    
    private func getDDayText(difference: Int) -> String {
        if difference == 0 {
            return "D-Day입니다."
        } else {
            return "D+\(difference)일입니다."
        }
    }
    
    private func validateBirthday(year: String?, month: String?, day: String?) {
        let calendar = Calendar.current
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        let currentDay = calendar.component(.day, from: today)
        
        var wrongField = "연도는 "
        do {
            let year = try getValidInteger(year, min: 1900, max: currentYear)
            
            wrongField = (year == currentYear) ? "해당 연도에서 달은 " : "달은 "
            let maxMonth = (year == currentYear) ? currentMonth : 12
            let month = try getValidInteger(month, min: 1, max: maxMonth)
            
            wrongField = (year == currentYear && month == currentMonth) ? "해당 연도와 달에서 일은 " : "일은 "
            let maxDay = (year == currentYear && month == currentMonth) ? currentDay : getMaxDay(year: year, month: month)
            let day = try getValidInteger(day, min: 1, max: maxDay)
            
            var dateString = String(year)
            dateString += String(format: "%02d", month)
            dateString += String(format: "%02d", day)
            
            guard let date = Formatters.DateFormatters.yyyyMMddFormatter.date(from: dateString) else {
                throw InputValidationError.unknown
            }
            
            birthDay = date
        } catch let error as InputValidationError {
            errorMessage = wrongField + error.errorMessage
        } catch { }
    }
}
