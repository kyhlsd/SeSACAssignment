//
//  LottoViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import Alamofire
import SnapKit

final class LottoViewController: UIViewController {

    private let inputTextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let pickerView = UIPickerView()
    private let winningInfoLabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
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
    private let indicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        indicatorView.color = .systemGray
        return indicatorView
    }()
    
    private var isFetching = false {
        didSet {
            isFetching ? indicatorView.startAnimating() : indicatorView.stopAnimating()
            pickerView.isUserInteractionEnabled = !isFetching
        }
    }
    private var error: Error?
    
    private let maxNumber = 1181
    private let recentDate = "2025-07-19"
    private var lottoResult: LottoResult? {
        didSet {
            showLottoNumbers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewDesign()
        
        setTapGesture()
        
        fetchData(targetRound: 1181)
        updateViewsWithRoundNumber(with: 1181)
    }
    
    private func fetchData(targetRound: Int) {
        if isFetching { return }
        
        let url = LottoAPIHelper.getURL(targetRound: targetRound)
        
        isFetching = true
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LottoResult.self) { response in
                switch response.result {
                case .success(let value):
                    self.lottoResult = value
                    self.error = nil
                case .failure(let error):
                    self.lottoResult = nil
                    self.error = error
                }
                self.isFetching = false
            }
    }
    
    private func updateViewsWithRoundNumber(with number: Int) {
        let numberString = "\(number)"
        inputTextField.text = numberString
        resultLabel.setAttributedTextlWithKeyword(text: numberString + "회 당첨결과", keyword: numberString + "회", pointColor: .systemYellow)
        
        let formatter = DateFormatters.yyMMddDashFormatter
        if let recentDate = formatter.date(from: recentDate),
           let date = Calendar.current.date(byAdding: .day, value: -(maxNumber - number) * 7, to: recentDate) { dateLabel.text = formatter.string(from: date) + " 추첨"
        }
    }
    
    private func showLottoNumbers() {
        guard let lottoResult else { return }
        
        let numbers = lottoResult.numbers
        let bonusNumber = lottoResult.bonusNumber
        var numberIndex = 0
        
        for subview in resultStackView.arrangedSubviews {
            subview.alpha = 0
            if let lottoBall = subview as? LottoBall {
                lottoBall.setNumber(number: numbers[numberIndex])
                numberIndex += 1
            } else if let bonusLottoBall = subview as? BonusLottoBall {
                bonusLottoBall.setNumber(number: bonusNumber)
                numberIndex += 1
            }
        }
        
        var delay = 0.0
        for subview in self.resultStackView.arrangedSubviews {
            UIView.animate(withDuration: 0.5, delay: delay, animations: {
                subview.alpha = 1
            })
            delay += 0.07
        }

    }
}

// MARK: UI Design
extension LottoViewController: ViewDesignProtocol {
    func configureHierarchy() {
        [inputTextField, winningInfoLabel, dateLabel, separatorLine, resultLabel, resultStackView, indicatorView].forEach {
            view.addSubview($0)
        }
        
        for _ in 1...6 {
            let lottoBall = LottoBall(number: 0)
            lottoBall.alpha = 0
            resultStackView.addArrangedSubview(lottoBall)
        }
        
        let plusImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "plus"))
            imageView.tintColor = .black
            imageView.contentMode = .center
            imageView.alpha = 0
            let config = UIImage.SymbolConfiguration(weight: .bold)
            imageView.preferredSymbolConfiguration = config
            imageView.snp.makeConstraints { make in
                make.height.equalTo(imageView.snp.width)
            }
            return imageView
        }()
        
        resultStackView.addArrangedSubview(plusImageView)
        
        let bonusLottoBall = BonusLottoBall(number: 0)
        bonusLottoBall.alpha = 0
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
            make.height.equalTo(16)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(winningInfoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(0.5)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine).offset(20)
            make.centerX.equalTo(safeArea)
            make.height.equalTo(24)
        }
        
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        inputTextField.inputView = pickerView
        inputTextField.delegate = self
    }
}

// MARK: PickerView
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fetchData(targetRound: maxNumber - row)
        updateViewsWithRoundNumber(with: maxNumber - row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(maxNumber - row)"
    }
}

// MARK: TextField
extension LottoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

// MARK: TapGesture - DismissKeyboard
extension LottoViewController: UseKeyboardProtocol {
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
