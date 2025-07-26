//
//  OptionStackView.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/26/25.
//

import UIKit

protocol OptionDidSelectDelegate: AnyObject {
    func didSelectButton(index: Int)
}

class OptionStackView: UIStackView {

    private let list: [String]
    weak var delegate: OptionDidSelectDelegate?
    
    init(list: [String]) {
        self.list = list
        super.init(frame: .zero)
        
        setStackView()
        setupButtons()
        
        if let button = subviews.first as? UIButton {
            setButtonDesign(button, isSelected: true)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStackView() {
        axis = .horizontal
        distribution = .fill
        spacing = 8
    }
    
    private func setupButtons() {
        for (i, title) in list.enumerated() {
            let button = UIButton()

            button.layer.cornerRadius = 8
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
            button.clipsToBounds = true
            
            var config = UIButton.Configuration.filled()
            config.title = title
            config.titlePadding = 4
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                return outgoing
            }
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .clear
            
            button.configuration = config
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            button.tag = i
            button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
            addArrangedSubview(button)
        }
    }

    @objc
    private func buttonDidTapped(_ sender: UIButton) {
        for subview in subviews {
            if let button = subview as? UIButton {
                setButtonDesign(button, isSelected: false)
            }
        }
        setButtonDesign(sender, isSelected: true)
        delegate?.didSelectButton(index: sender.tag)
    }
    
    private func setButtonDesign(_ button: UIButton, isSelected: Bool) {
        button.configuration?.baseForegroundColor = isSelected ? .black : .white
        button.configuration?.baseBackgroundColor = isSelected ? .white : .clear
    }
}
