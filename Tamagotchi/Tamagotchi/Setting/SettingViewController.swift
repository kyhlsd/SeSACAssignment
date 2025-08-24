//
//  SettingViewController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: UIViewController {

    private let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private let viewModel = SettingViewModel()
    private let resetData: PublishRelay<Void> = PublishRelay()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
        bind()
    }
    
    private func bind() {
        let input = SettingViewModel.Input(cellTap: tableView.rx.modelSelected(SettingViewModel.SettingType.self), resetData: resetData)
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(to: tableView.rx.items) { [weak self] tableView, row, element in
                self?.getBasicCell(type: element) ?? UITableViewCell()
            }
            .disposed(by: disposeBag)
        
        output.resetAlert
            .bind(with: self) { owner, _ in
                owner.presentResetAlert()
            }
            .disposed(by: disposeBag)
        
        output.pushSelectVC
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SelectTamagotchiViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.transitionToRootVC
            .bind(with: self) { owner, _ in
                owner.performTransition()
            }
            .disposed(by: disposeBag)
    }
    
    private func getBasicCell(type: SettingViewModel.SettingType) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BasicCell")
        cell.accessoryType = .disclosureIndicator
        var config = cell.defaultContentConfiguration()
        config.image = UIImage(systemName: type.icon)
        config.text = type.rawValue
        if type == .username {
            config.secondaryText = viewModel.username
            config.prefersSideBySideTextAndSecondaryText = true
        }
        cell.contentConfiguration = config
        cell.selectionStyle = .none
        return cell
    }
    
    private func presentResetAlert() {
        let alert = UIAlertController(title: "데이터 초기화", message: "정말 다시 처음부터 시작하실 건가용?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아냐!", style: .cancel))
        alert.addAction(UIAlertAction(title: "응", style: .default) { [weak self] _ in
            self?.resetData.accept(())
        })
        present(alert, animated: true)
    }
    
    private func performTransition() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.navigationController?.viewControllers = [SelectTamagotchiViewController()]
        }
    }

    private func setupUI() {
        view.backgroundColor = .background
        navigationItem.title = "설정"
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
