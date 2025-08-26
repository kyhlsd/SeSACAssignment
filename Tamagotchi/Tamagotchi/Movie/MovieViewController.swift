//
//  MovieViewController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/25/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class MovieViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
     
    private let viewModel = MovieViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        let input = MovieViewModel.Input(
            searchButtonClick: searchBar.rx.searchButtonClicked
                .withLatestFrom(searchBar.rx.text.orEmpty))
        let output = viewModel.transform(input: input)
        
        output.movieResult
            .map { $0.boxOfficeResult.dailyBoxOfficeList }
            .bind(to: tableView.rx.items(cellIdentifier: SimpleTableViewCell.identifier, cellType: SimpleTableViewCell.self)) { row, element, cell in
                cell.usernameLabel.text = "\(element.rank): \(element.name)"
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
        
        searchBar.placeholder = "영화날짜 -> ex) 20250825"
    }
}
