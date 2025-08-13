//
//  OnboardingViewController.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    private let button = {
        let button = UIButton()
        button.setTitle("Set Profile", for: .normal)
        button.backgroundColor = .enabledButton
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
        
        navigationItem.title = "Onboarding"
        navigationItem.backButtonTitle = " "
        
        button.addTarget(self, action: #selector(pushSettingVC), for: .touchUpInside)
    }
    
    @objc
    private func pushSettingVC() {
        navigationController?.pushViewController(ProfileSettingViewController(), animated: true)
    }
}
