//
//  WordCounterViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/5/25.
//

import UIKit
import SnapKit
 
class WordCounterViewController: UIViewController {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        return textView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "현재까지 0글자 작성중"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
    
    private let viewModel = WordCounterViewModel()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateView = { [weak self] count in
            self?.countLabel.text = "현재까지 \(count)글자 작성중"
        }
        
        setupUI()
        setupConstraints()
        setupTextView()
    }
     
    private func setupUI() {
        view.backgroundColor = .white
        
        [textView, countLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(view.snp.width)
        }
    }
    
    private func setupTextView() {
        textView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
 
extension WordCounterViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.inputText = textView.text
    }
}
