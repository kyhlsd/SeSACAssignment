//
//  SearchMovieViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import SnapKit

final class SearchMovieViewController: UIViewController {

    private let backgroundImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .searchMovieBackground
        imageView.alpha = 0.2
        return imageView
    }()
    private let searchTextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "이름 또는 개봉일로 검색하세요.", attributes: [.foregroundColor: UIColor.darkGray])
        textField.textColor = .white
        textField.returnKeyType = .search
        textField.clearButtonMode = .always
        textField.overrideUserInterfaceStyle = .dark
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.register(cellType: SearchMovieTableViewCell.self)
        tableView.register(cellType: EmptyListTableViewCell.self)
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
        searchButton.addTarget(self, action: #selector(searchMovie), for: .touchUpInside)
        
        updateSearchedList(nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTextField.layer.addBorder([.bottom], color: .white, width: 2)
    }
    
    @objc
    private func searchMovie() {
        updateSearchedList(searchTextField.text)
        tableView.reloadData()
        dismissKeyboard()
    }
}


// MARK: UI Design
extension SearchMovieViewController: ViewDesignProtocol {
    func configureHierarchy() {
        [backgroundImageView, searchTextField, searchButton, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(20)
            make.height.equalTo(44)
        }
        
        searchButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchTextField)
            make.trailing.equalTo(safeArea).inset(20)
            make.width.equalTo(80)
            make.leading.equalTo(searchTextField.snp.trailing).offset(20)
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
    }
}

// MARK: TextField
extension SearchMovieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovie()
        return true
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

// MARK: TableView
extension SearchMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedList.isEmpty {
            return 1
        }
        
        return min(searchedList.count, 10)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchedList.isEmpty {
            return tableView.dequeueReusableCell(cellType: EmptyListTableViewCell.self, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(cellType: SearchMovieTableViewCell.self, for: indexPath)
        let trimmed = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.configureData(with: searchedList[indexPath.row], index: indexPath.row + 1, searchText: trimmed)
        return cell
    }
}

// MARK: TapGesture - DismissKeyboard
extension SearchMovieViewController: UseKeyboardProtocol {
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
