//
//  LottoViewController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class LottoViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
     
    private let viewModel = LottoViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        let input = LottoViewModel.Input(
            searchButtonClick: searchBar.rx.searchButtonClicked
                .withLatestFrom(searchBar.rx.text.orEmpty))
        let output = viewModel.transform(input: input)
        
        output.lottoResult
            .map { $0.numbers }
            .bind(to: tableView.rx.items(cellIdentifier: SimpleTableViewCell.identifier, cellType: SimpleTableViewCell.self)) { row, element, cell in
                cell.usernameLabel.text = "\(row + 1)번째 번호: \(element)"
            }
            .disposed(by: disposeBag)
        
        output.errorToastMessage
            .bind(with: self) { owner, errorMessage in
                owner.view.makeToast(errorMessage, duration: 1, position: .bottom)
            }
            .disposed(by: disposeBag)
        
        output.networkAlert
            .bind(with: self) { owner, alert in
                owner.showDefaultAlert(title: alert.0, message: alert.1)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 80
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.placeholder = "로또 회차 -> ex) 1181"
    }
}
 

