//
//  LottoViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class LottoViewController: UIViewController {

    private let lottoView = LottoView()
    
    private var isFetching = false {
        didSet {
            isFetching ? lottoView.indicatorView.startAnimating() : lottoView.indicatorView.stopAnimating()
            lottoView.pickerView.isUserInteractionEnabled = !isFetching
        }
    }
    private var error: Error? {
        didSet {
            setErrorLabel()
        }
    }
    
    private let maxRound = {
        let referenceRound = 1181
        guard let referenceDate = DateFormatters.yyyyMMddDashFormatter.date(from: "2025-07-19") else { return referenceRound }
        
        let dateGap = Calendar.current.getDateGap(from: referenceDate, to: Date())
        
        let calculatedRound = (dateGap - 1) / 7 + referenceRound
        return max(calculatedRound, referenceRound)
    }()
    
    private let recentDate = {
        let referenceDateString = "2025-07-19"
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        // 지난주 토요일 만들기: weekday는 일요일이 1, 토요일이 7
        let daysToSubtract = (weekday - 1 + 7) % 7 + 1
        guard let lastSaturday = calendar.date(byAdding: .day, value: -daysToSubtract, to: Date()) else { return referenceDateString }
        
        return DateFormatters.yyyyMMddDashFormatter.string(from: lastSaturday)
    }()
    
    private var lottoResult: LottoResult? {
        didSet {
            showLottoNumbers()
        }
    }
    
    override func loadView() {
        self.view = lottoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoView.pickerView.delegate = self
        lottoView.pickerView.dataSource = self
        lottoView.inputTextField.delegate = self
        
        setTapGesture()
        
        fetchData(targetRound: maxRound)
        updateViewsWithRoundNumber(with: maxRound)
    }
    
    private func fetchData(targetRound: Int) {
        if isFetching { return }
        
        isFetching = true
        LottoAPIManager.shared.fetchData(targetRound: targetRound, successHandler: { value in
            self.lottoResult = value
            self.error = nil
            self.isFetching = false
        }, failureHandler: { error in
            self.lottoResult = nil
            self.error = error
            self.isFetching = false
        })
    }
    
    private func updateViewsWithRoundNumber(with number: Int) {
        let numberString = "\(number)"
        lottoView.inputTextField.text = numberString
        lottoView.resultLabel.setAttributedTextlWithKeyword(text: numberString + "회 당첨결과", keyword: numberString + "회", pointColor: .systemYellow)
        
        let formatter = DateFormatters.yyMMddDashFormatter
        if let recentDate = formatter.date(from: recentDate),
           let date = Calendar.current.date(byAdding: .day, value: -(maxRound - number) * 7, to: recentDate) {
            lottoView.dateLabel.text = formatter.string(from: date) + " 추첨"
        }
    }
    
    private func showLottoNumbers() {
        let numbers = lottoResult?.numbers ?? [Int](repeating: 0, count: 6)
        let bonusNumber = lottoResult?.bonusNumber ?? 0
        var numberIndex = 0
        
        for subview in lottoView.resultStackView.arrangedSubviews {
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
        for subview in lottoView.resultStackView.arrangedSubviews {
            UIView.animate(withDuration: 0.5, delay: delay, animations: {
                subview.alpha = 1
            })
            delay += 0.07
        }
    }
    
    private func setErrorLabel() {
        if let error {
            lottoView.errorLabel.text = "오류가 발생했습니다.\n" + error.localizedDescription
            lottoView.errorLabel.isHidden = false
        } else {
            lottoView.errorLabel.isHidden = true
        }
    }
}

// MARK: PickerView
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxRound
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fetchData(targetRound: maxRound - row)
        updateViewsWithRoundNumber(with: maxRound - row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(maxRound - row)"
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

// MARK: Views
final fileprivate class LottoView: UIView {
    fileprivate let inputTextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    fileprivate let pickerView = UIPickerView()
    fileprivate let winningInfoLabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    fileprivate let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    fileprivate let separatorLine = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    fileprivate let resultLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    fileprivate let resultStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        return stackView
    }()
    fileprivate let errorLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.isHidden = true
        return label
    }()
    fileprivate let indicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        indicatorView.color = .systemGray
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LottoView: ViewDesignProtocol {
    func configureHierarchy() {
        [inputTextField, winningInfoLabel, dateLabel, separatorLine, resultLabel, resultStackView, errorLabel, indicatorView].forEach {
            addSubview($0)
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
        let safeArea = safeAreaLayoutGuide
        
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
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(resultStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.height.equalTo(60)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
        }
    }
    
    func configureView() {
        backgroundColor = .white
        inputTextField.inputView = pickerView
    }
}
