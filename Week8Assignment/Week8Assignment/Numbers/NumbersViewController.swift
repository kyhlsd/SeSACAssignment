//
//  NumbersViewController.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NumbersViewController: UIViewController {
    
    private let firstTextField = UITextField()
    private let secondTextField = UITextField()
    private let thirdTextField = UITextField()
    private let imageView = UIImageView()
    private let line = UIView()
    private let resultLabel = UILabel()
    
    private let viewModel = NumbersViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    private func bind() {
        let input = NumbersViewModel.Input(firstText: firstTextField.rx.text.orEmpty, secondText: secondTextField.rx.text.orEmpty, thirdText: thirdTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.result
            .bind(with: self) { owner, result in
                owner.resultLabel.text = result
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = "Numbers"
        
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .black
        
        resultLabel.backgroundColor = .white
        resultLabel.textAlignment = .right
        
        line.backgroundColor = .systemGray

        [firstTextField, secondTextField, thirdTextField].forEach {
            view.addSubview($0)
            $0.borderStyle = .roundedRect
            $0.textAlignment = .right
        }
        view.addSubview(imageView)
        view.addSubview(line)
        view.addSubview(resultLabel)
        
        firstTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.width.equalTo(180)
        }
        secondTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.width.equalTo(180)
        }
        thirdTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
            make.width.equalTo(180)
        }
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(thirdTextField)
            make.size.equalTo(24)
            make.trailing.equalTo(thirdTextField.snp.leading).offset(-20)
        }
        line.snp.makeConstraints { make in
            make.leading.equalTo(imageView)
            make.trailing.equalTo(thirdTextField)
            make.centerY.equalToSuperview().offset(45)
            make.height.equalTo(1)
        }
        resultLabel.snp.makeConstraints { make in
            make.size.equalTo(firstTextField)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(70)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
