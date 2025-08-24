//
//  SelectTamagotchiAlertController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/24/25.
//

import UIKit
import SnapKit

final class SelectTamagotchiAlertController: UIAlertController {

    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = InsetLabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.blue.cgColor
        return label
    }()
    
    private let line = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let introduceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var type: TamagotchiType?
    weak var delegate: VCTransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    func setData(type: TamagotchiType) {
        imageView.image = UIImage(named: type.defaultImage)
        nameLabel.text = type.rawValue
        introduceLabel.text = type.introduce
        self.type = type
    }
    
    private func setupUI() {
        [imageView, nameLabel, line, introduceLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(1)
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    
    private func setupActions() {
        addAction(UIAlertAction(title: "취소", style: .cancel))
        addAction(UIAlertAction(title: "시작하기", style: .default, handler: { [weak self] _ in
            guard let self, let type else { return }
            let tamagotchi = UserDefaultManager.tamagotchi
            UserDefaultManager.tamagotchi = Tamagotchi(type: type, meal: tamagotchi.meal, water: tamagotchi.water)
            delegate?.performTransition(isInit: type == .unready)
        }))
    }
}
