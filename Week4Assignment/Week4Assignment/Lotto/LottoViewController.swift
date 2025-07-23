//
//  LottoViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class LottoViewController: UIViewController {

    private let inputTextField = {
        let textField = UITextField()
        textField.placeholder = "회차를 선택하세요"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let winningInfoLabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.text = "추첨 날짜"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    private let separatorLine = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let resultLabel = {
        let label = UILabel()
        label.text = "당첨 결과"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let resultStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        return stackView
    }()
    
    private let maxNumber = 1181
    private let recentDate = "2025-07-19"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewDesign()
        
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateViewsWithRoundNumber(with number: Int) {
        let numberString = "\(number)"
        inputTextField.text = numberString
        resultLabel.setAttributedTextlWithKeyword(text: numberString + "회 당첨결과", keyword: numberString + "회", pointColor: .systemYellow)
        
        let formatter = DateFormatters.yyMMddDashFormatter
        if let recentDate = formatter.date(from: recentDate) {
            let calendar = Calendar.current
            if let date = calendar.date(byAdding: .day, value: -(maxNumber - number) * 7, to: recentDate) {
                dateLabel.text = formatter.string(from: date) + " 추첨"
            }
        }
    }
    
    private func getLottoNumbers() -> [Int] {
        var totalNumbers = [Int](1...45)
        var selectedNumbers = [Int]()
        
        for _ in 0..<7 {
            if let number = totalNumbers.randomElement() {
                selectedNumbers.append(number)
                totalNumbers.removeAll { $0 == number }
            }
        }
        
        return selectedNumbers
    }
    
    private func showLottoNumbers() {
        let lottoNumbers = getLottoNumbers()
        var numberIndex = 0
        
        for subview in resultStackView.arrangedSubviews {
            if let lottoBall = subview as? LottoBall {
                lottoBall.setNumber(number: lottoNumbers[numberIndex])
                numberIndex += 1
            } else if let bonusLottoBall = subview as? BonusLottoBall {
                bonusLottoBall.setNumber(number: lottoNumbers[numberIndex])
                numberIndex += 1
            }
        }
    }
}

extension LottoViewController: ViewDesignProtocol {
    func configureHierarchy() {
        [inputTextField, winningInfoLabel, dateLabel, separatorLine, resultLabel, resultStackView].forEach {
            view.addSubview($0)
        }
        
        let lottoBall = LottoBall(number: 1)
        let lottoBall2 = LottoBall(number: 2)
        let lottoBall3 = LottoBall(number: 3)
        let lottoBall4 = LottoBall(number: 4)
        let lottoBall5 = LottoBall(number: 5)
        let lottoBall6 = LottoBall(number: 6)
        
        resultStackView.addArrangedSubview(lottoBall)
        resultStackView.addArrangedSubview(lottoBall2)
        resultStackView.addArrangedSubview(lottoBall3)
        resultStackView.addArrangedSubview(lottoBall4)
        resultStackView.addArrangedSubview(lottoBall5)
        resultStackView.addArrangedSubview(lottoBall6)
        
        let plusImageView = UIImageView(image: UIImage(systemName: "plus"))
        plusImageView.tintColor = .black
        plusImageView.contentMode = .center
        let config = UIImage.SymbolConfiguration(weight: .bold)
        plusImageView.preferredSymbolConfiguration = config
        plusImageView.snp.makeConstraints { make in
            make.height.equalTo(plusImageView.snp.width)
        }
        
        resultStackView.addArrangedSubview(plusImageView)
        
        let bonusLottoBall = BonusLottoBall(number: 7)
        resultStackView.addArrangedSubview(bonusLottoBall)
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(20)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.height.equalTo(44)
        }
        
        winningInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(20)
            make.leading.equalTo(safeArea).inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea).inset(16)
            make.bottom.equalTo(winningInfoLabel.snp.bottom)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(winningInfoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(0.5)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine).offset(20)
            make.centerX.equalTo(safeArea)
        }
        
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        inputTextField.inputView = pickerView
        inputTextField.delegate = self
    }
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateViewsWithRoundNumber(with: maxNumber - row)
        showLottoNumbers()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(maxNumber - row)"
    }
}

extension LottoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
