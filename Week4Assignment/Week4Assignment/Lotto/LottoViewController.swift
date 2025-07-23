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
        return textField
    }()
    private let winningInfoLabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.text = "2020-05-30 추첨"
        return label
    }()
    private let separatorLine = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let resultLabel = {
        let label = UILabel()
        label.text = "913회 당첨 결과"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewDesign()
        print(resultStackView.arrangedSubviews.count)
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
        
        let bonusLottoBall = BonusLottoBall(number: 6)
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
            make.height.equalTo(1)
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
    }
}
