//
//  SimpleTableViewController.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleTableViewController: UIViewController {

    private let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        return tableView
    }()
    
    private let viewModel = SimpleTableViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }
    
    private func bind() {
        let input = SimpleTableViewModel.Input(
            cellTap: tableView.rx.modelSelected(Int.self),
            accessoryTap: tableView.rx.itemAccessoryButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, element) in
                self?.getBasicCell(element: element) ?? UITableViewCell()
            }
            .disposed(by: disposeBag)
    
        output.pushVCTrigger
            .bind(with: self) { owner, index in
                owner.pushViewController(index: index)
            }
            .disposed(by: disposeBag)
        
        output.alertTrigger
            .bind(with: self) { owner, index in
                owner.presentAlert(index: index)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        navigationItem.title = "SimpleTable"
        navigationItem.backButtonTitle = " "
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func pushViewController(index: Int) {
        switch index {
        case 0:
            navigationController?.pushViewController(NumbersViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(SimpleValidationViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(HomeworkViewController(), animated: true)
        default:
            showDefaultAlert(title: "Push VC 오류", message: "잘못된 셀 선택입니다.")
        }
    }
    
    private func presentAlert(index: Int) {
        showDefaultAlert(title: "Push ViewController", message: VCForCell.getVCName(index)+"로 화면 전환됩니다.")
    }
    
    private func getBasicCell(element: Int) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .detailButton
        cell.selectionStyle = .none
        var config = UIListContentConfiguration.cell()
        config.text = VCForCell.getVCName(element)
        cell.contentConfiguration = config
        return cell
    }
    
    enum VCForCell: String, CaseIterable {
        case numbers = "NumbersViewController"
        case validation = "SimpleValidationViewController"
        case homework = "HomeworkViewController"
        
        static func getVCName(_ index: Int) -> String {
            if VCForCell.allCases.count <= index {
                return "overflow"
            }
            return VCForCell.allCases[index].rawValue
        }
    }
}
