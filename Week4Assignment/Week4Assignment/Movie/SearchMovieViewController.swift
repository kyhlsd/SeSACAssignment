//
//  SearchMovieViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class SearchMovieViewController: UIViewController {

    private let searchTextField = {
        let textField = UITextField()
        textField.placeholder = "이름 또는 개봉일로 검색하세요."
        textField.textColor = .white
        textField.returnKeyType = .search
        textField.clearButtonMode = .always
        return textField
    }()
    private let searchButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .white
        return button
    }()
    private let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 40
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(cellType: SearchMovieTableViewCell.self)
        return tableView
    }()
    
    private let totalList = MovieInfo.movies.sorted {
        $0.audienceCount > $1.audienceCount
    }
    private var searchedList = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewDesign()
        
        setTapGesture()
        
        updateSearchedList(nil)
    }

    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateSearchedList(_ searchText: String?) {
        guard let searchText else {
            searchedList = totalList
            return
        }
        
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            searchedList = totalList
        } else {
            searchedList = totalList.filter { $0.matches(keyword: searchText) }
        }
    }
}

extension SearchMovieViewController: ViewDesignProtocol {
    func configureHierarchy() {
        [searchTextField, searchButton, tableView].forEach {
            view.addSubview($0)
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
        
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        searchButton.addTarget(self, action: #selector(searchMovie), for: .touchUpInside)
    }
    
    @objc
    private func searchMovie() {
        updateSearchedList(searchTextField.text)
        tableView.reloadData()
        view.endEditing(true)
    }
}

extension SearchMovieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovie()
        return true
    }
}

extension SearchMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(searchedList.count, 10)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: SearchMovieTableViewCell.self, for: indexPath)
        let trimmed = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.configureData(with: searchedList[indexPath.row], index: indexPath.row + 1, searchText: trimmed)
        return cell
    }
}
