//
//  MainViewController.swift
//  Week7Assignment
//
//  Created by 김영훈 on 8/13/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {

    private let label = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.enabledButton.cgColor
        imageView.layer.borderWidth = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [label, imageView].forEach {
            view.addSubview($0)
        }
        
        navigationItem.title = "Main"
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(100)
            make.bottom.equalTo(label.snp.top).offset(-20)
        }
    }
    
    private func setupBindings() {
        viewModel.output.profileInfo.bind(isLazy: false) { [weak self] description, image in
            self?.label.text = description
            self?.imageView.image = UIImage(named: image)
        }
    }
}
