//
//  ProfileSettingViewController.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import UIKit
import SnapKit

final class ProfileSettingViewController: UIViewController {
    
    private let profileImageButton = BadgeLayerButton(mainImage: UIImage(systemName: "person"), badgeImage: UIImage(systemName: "camera.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white, .enabledButton])), color: .enabledButton, borderWidth: 6, badgeSize: 32)
    
    private let nicknameTextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        textField.borderStyle = .none
        return textField
    }()
    
    private let nicknameStatusLabel = {
        let label = UILabel()
        label.text = " "
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let mbtiLabel = {
        let label = UILabel()
        label.text = "MBTI"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let mbtiCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.register(cellType: MBTICollectionViewCell.self)
        return collectionView
    }()
    
    private let completeButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = .disabledButton
        return button
    }()
    
    private let viewModel = ProfileSettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        setupDelegates()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height / 2
        completeButton.layer.cornerRadius = completeButton.frame.height / 2
        nicknameTextField.layer.addBorder([.bottom], color: .lightGray, width: 1)
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "PROFILE SETTING"
        navigationItem.backButtonTitle = " "
        
        [profileImageButton, nicknameTextField, nicknameStatusLabel, mbtiLabel, mbtiCollectionView, completeButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let verticalPadding = 20
        let horizontalPadding = 24
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(verticalPadding)
            make.centerX.equalTo(safeArea)
            make.size.equalTo(100)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(verticalPadding)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalPadding)
            make.height.equalTo(44)
        }
        
        nicknameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(nicknameTextField)
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(safeArea).inset(horizontalPadding)
        }
        
        mbtiCollectionView.snp.makeConstraints { make in
            let cellSize = 60
            let cellPadding = 8
            
            make.top.equalTo(mbtiLabel)
            make.trailing.equalTo(safeArea).inset(horizontalPadding)
            make.width.equalTo(cellSize * 4 + (cellPadding * 3))
            make.height.equalTo(cellSize * 2 + cellPadding)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).inset(verticalPadding)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalPadding)
            make.height.equalTo(44)
        }
    }
    
    private func setupActions() {
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldEditingChanged), for: .editingChanged)
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        mbtiCollectionView.delegate = self
        mbtiCollectionView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.output.isEnableComplete.bind(isLazy: false) { [weak self] isEnabled in
            self?.completeButton.isEnabled = isEnabled
            self?.completeButton.backgroundColor = isEnabled ? .enabledButton : .disabledButton
        }
        viewModel.output.nicknameStatusText.bind { [weak self] text in
            self?.nicknameStatusLabel.text = text
        }
        viewModel.output.isEnableNickname.bind { [weak self] isEnabled in
            self?.nicknameStatusLabel.textColor = isEnabled ? .enabledButton : .systemRed
        }
        viewModel.output.mbti.bind { [weak self] _ in
            self?.mbtiCollectionView.reloadData()
        }
        
        viewModel.output.alertTrigger.bind { [weak self] title, message in
            self?.showDefaultAlert(title: title, message: message)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func nicknameTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.input.nickname.value = sender.text
    }
    
    @objc private func profileImageButtonTapped() {
        let viewController = ProfileImageViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func completeButtonTapped() {
        viewModel.input.completeButtonTrigger.value = ()
    }
}

extension ProfileSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.mbtiCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.mbtiCases[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: MBTICollectionViewCell.self, for: indexPath)
        cell.configureCell(viewModel.mbtiCases[indexPath.section][indexPath.item], isSelected: viewModel.getIsSelected(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        case viewModel.mbtiCases.count - 1:
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.selectMBTITrigger.value = indexPath
    }
}
