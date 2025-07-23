//
//  SearchMoviewViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class SearchMoviewViewController: UIViewController {

    private let searchTextField = UITextField()
    private let searchButton = UIButton()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewDesign()
    }

}

extension SearchMoviewViewController: ViewDesignProtocol {
    func configureHierarchy() {
        [searchTextField, searchButton, tableView].forEach {
            view.addSubview($0)
            $0.backgroundColor = .white
        }
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        searchTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(20)
            make.height.equalTo(44)
        }
        
        searchButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchTextField)
            make.trailing.equalTo(safeArea).inset(20)
            make.width.equalTo(80)
            make.leading.equalTo(searchTextField.snp.trailing).offset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.bottom.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureView() {
        view.backgroundColor = .black
    }
}
