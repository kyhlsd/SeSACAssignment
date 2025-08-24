//
//  CareTamagotchiViewController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CareTamagotchiViewController: UIViewController {

    private let bubbleImageView = {
        let imageView = UIImageView()
        imageView.image = .bubble
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let bubbleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let tamagotchiImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = InsetLabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.blue.cgColor
        return label
    }()
    
    private let descriptLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemIndigo
        return label
    }()
    
    private let mealTextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "밥주세용"
        return textField
    }()
    
    private let waterTextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "물주세용"
        return textField
    }()
    
    private let mealButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "leaf.circle")
        config.title = "밥먹기"
        config.imagePadding = 4
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemIndigo.cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private let waterButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "drop.circle")
        config.title = "물먹기"
        config.imagePadding = 4
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemIndigo.cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private let viewModel = CareTamagotchiViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        tamagotchiImageView.layer.cornerRadius = tamagotchiImageView.frame.height / 2
        mealTextField.layer.addBorder([.bottom], color: .lightGray, width: 1)
        waterTextField.layer.addBorder([.bottom], color: .lightGray, width: 1)
    }

    private func bind() {
        let input = CareTamagotchiViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.bubbleMessage
            .bind(to: bubbleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.tamagotchi
            .map { UIImage(named: $0.image) }
            .bind(to: tamagotchiImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.tamagotchi
            .map { $0.type.rawValue }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.description
            .bind(to: descriptLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        navigationItem.title = "\(UserDefaultManager.username)님의 다마고치"
        navigationItem.backButtonTitle = " "
        
        let barButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(systemName: "person.circle")))
        barButtonItem.tintColor = .systemIndigo
        navigationItem.rightBarButtonItem = barButtonItem
        
        [bubbleImageView, bubbleLabel, tamagotchiImageView, nameLabel, descriptLabel, mealTextField, mealButton, waterTextField, waterButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        bubbleImageView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(40)
            make.width.equalTo(200)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        bubbleLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(bubbleImageView).inset(20)
            make.bottom.equalTo(bubbleImageView).offset(-40)
        }
        tamagotchiImageView.snp.makeConstraints { make in
            make.top.equalTo(bubbleImageView.snp.bottom).offset(8)
            make.size.equalTo(180)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(tamagotchiImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        descriptLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        mealTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptLabel.snp.bottom).offset(32)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().multipliedBy(0.6)
        }
        mealButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(mealTextField)
            make.leading.equalTo(mealTextField.snp.trailing).offset(8)
        }
        waterTextField.snp.makeConstraints { make in
            make.size.horizontalEdges.equalTo(mealTextField)
            make.top.equalTo(mealTextField.snp.bottom).offset(8)
        }
        waterButton.snp.makeConstraints { make in
            make.size.horizontalEdges.equalTo(mealButton)
            make.verticalEdges.equalTo(waterTextField)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
