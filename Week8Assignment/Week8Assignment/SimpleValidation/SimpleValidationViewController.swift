//
//  SimpleValidationViewController.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: UIViewController {

    private let usernameLabel = UILabel()
    private let usernameTextField = UITextField()
    private let usernameValidLabel = UILabel()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordValidLabel = UILabel()
    
    private let doSomethingButton = UIButton()
    
    private let disposeBag = DisposeBag()
    private let viewModel = SimpleValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    private func bind() {
        let input = SimpleValidationViewModel.Input(
            username: usernameTextField.rx.text,
            password: passwordTextField.rx.text,
            doSomethingButtonTap: doSomethingButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.usernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.usernameValid
            .bind(to: usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.everythingValid
            .bind(to: doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.alertTrigger
            .bind(with: self) { owner, _ in
                owner.showDefaultAlert(title: "Do Something", message: "Success")
            }
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = "Simple Validation"
        
        var offset = 0
        [usernameLabel, usernameTextField, usernameValidLabel, passwordLabel, passwordTextField, passwordValidLabel, doSomethingButton].forEach {
            view.addSubview($0)
            offset += 32
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(offset)
                make.height.equalTo(28)
            }
        }
        
        usernameLabel.text = "Username"
        passwordLabel.text = "Password"
        
        usernameTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        
        usernameValidLabel.textColor = .systemRed
        passwordValidLabel.textColor = .systemRed
        usernameValidLabel.text = "Username has to be at least \(viewModel.minimalUsernameLength) characters"
        passwordValidLabel.text = "Password has to be at least \(viewModel.minimalPasswordLength) characters"
        
        doSomethingButton.setTitle("Do something", for: .normal)
        doSomethingButton.backgroundColor = .systemGreen
    }
}
