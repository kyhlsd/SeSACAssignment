//
//  ProfileImageViewController.swift
//  Week7Assignment
//
//  Created by 김영훈 on 8/13/25.
//

import UIKit
import SnapKit

final class ProfileImageViewController: UIViewController {

    private let profileImageButton = {
        let button = BadgeLayerButton(mainImage: UIImage(systemName: "person"), badgeImage: UIImage(systemName: "camera.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white, .enabledButton])), color: .enabledButton, borderWidth: 6, badgeSize: 32)
        button.isEnabled = false
        return button
    }()
    
    private let imageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.register(cellType: ProfileImageCollectionViewCell.self)
        return collectionView
    }()
    
    private let viewModel = ProfileImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        setupDelegates()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "PROFILE SETTING"
        
        [profileImageButton, imageCollectionView].forEach {
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
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(verticalPadding)
            make.horizontalEdges.equalTo(safeArea).inset(horizontalPadding)
            make.bottom.equalTo(safeArea).inset(verticalPadding)
        }
    }
    
    private func setupDelegates() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func setupBindings() {
        
    }
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: ProfileImageCollectionViewCell.self, for: indexPath)
        cell.configureData(viewModel.images[indexPath.item])
        return cell
    }
}
