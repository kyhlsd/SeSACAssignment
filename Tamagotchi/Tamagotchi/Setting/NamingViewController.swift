//
//  NamingViewController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class NamingViewController: UIViewController {
    
    private var saveButton = {
        let barButtonItem = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
        barButtonItem.tintColor = .systemIndigo
        return barButtonItem
    }()
    
    private var textField = {
        let textField = UITextField()
        textField.placeholder = "사용할 이름을 입력하세요"
        return textField
    }()
    
    private let viewModel = NamingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        textField.layer.addBorder([.bottom], color: .lightGray, width: 1)
    }
    
    private func bind() {
        let input = NamingViewModel.Input(
            saveButtonTap: saveButton.rx.tap
                .withLatestFrom(textField.rx.text))
        let output = viewModel.transform(input: input)
        
        output.username
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        output.toastMessage
            .bind(with: self) { owner, message in
                owner.navigationController?.view.makeToast(message, duration: 1, position: .bottom)
            }
            .disposed(by: disposeBag)
        
        output.popVC
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        navigationItem.title = "대장님 이름 정하기"
        navigationItem.rightBarButtonItem = saveButton
        view.backgroundColor = .background
        view.addSubview(textField)
    }
    
    private func setupLayout() {
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(32)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
