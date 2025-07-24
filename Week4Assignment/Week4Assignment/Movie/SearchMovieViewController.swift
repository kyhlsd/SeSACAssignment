//
//  SearchMovieViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit
import Alamofire
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
        textField.attributedPlaceholder = NSAttributedString(string: "날짜를 입력하세요. ex) 20250723", attributes: [.foregroundColor: UIColor.darkGray])
        textField.textColor = .white
        textField.returnKeyType = .search
        textField.clearButtonMode = .always
        textField.overrideUserInterfaceStyle = .dark
        return textField
    }()
    private let nonValidDateLabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
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
    
    private var boxOfficeList = [BoxOffice]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let lastDate = "20250723"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewDesign()
        
        setTapGesture()
        searchButton.addTarget(self, action: #selector(searchMovie), for: .touchUpInside)
        
        fetchData(targetDate: lastDate)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTextField.layer.addBorder([.bottom], color: .white, width: 2)
    }
    
    private func fetchData(targetDate: String) {
        let url = MovieAPIInfo.getURL(type: .daily, targetDate: targetDate)
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoxOfficeResult.self) { response in
                switch response.result {
                case .success(let value):
                    self.boxOfficeList = value.boxOfficeResult.dailyBoxOfficeList
                case .failure(let error):
                    print(error)
                    self.boxOfficeList.removeAll()
                }
            }
    }
    
    @objc
    private func searchMovie() {
        do {
            let targetDate = try getValidDate()
            nonValidDateLabel.text = ""
            dismissKeyboard()
            
            fetchData(targetDate: targetDate)
        } catch {
            setNonValidDateLabel(with: error)
        }
    }
    
    private func getValidDate() throws -> String {
        let trimmed = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmed.isEmpty { return lastDate }
        
        guard let _ = DateFormatters.yyyyMMddFormatter.date(from: trimmed) else {
            throw NonValidDateError.nonDateFormat
        }
        
        if trimmed > lastDate {
            throw NonValidDateError.futureDate
        }
        
        return trimmed
    }
    
    private func setNonValidDateLabel(with error: Error) {
        switch error {
        case NonValidDateError.futureDate:
            nonValidDateLabel.text = "어제까지의 날짜만 조회 가능합니다."
        case NonValidDateError.nonDateFormat:
            nonValidDateLabel.text = "올바른 날짜 형식이 아닙니다. ex) 20250723"
        default:
            nonValidDateLabel.text = "알 수 없는 오류가 발생했습니다."
        }
    }
}


// MARK: UI Design
extension SearchMovieViewController: ViewDesignProtocol {
    func configureHierarchy() {
        [backgroundImageView, searchTextField, nonValidDateLabel, searchButton, tableView].forEach {
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
        
        nonValidDateLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.horizontalEdges.equalTo(searchTextField)
            make.height.equalTo(16)
        }
        
        searchButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchTextField)
            make.trailing.equalTo(safeArea).inset(20)
            make.width.equalTo(80)
            make.leading.equalTo(searchTextField.snp.trailing).offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(nonValidDateLabel.snp.bottom).offset(4)
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
}

// MARK: TableView
extension SearchMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if boxOfficeList.isEmpty {
            return 1
        }
        
        return boxOfficeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if boxOfficeList.isEmpty {
            return tableView.dequeueReusableCell(cellType: EmptyListTableViewCell.self, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(cellType: SearchMovieTableViewCell.self, for: indexPath)
        cell.configureData(with: boxOfficeList[indexPath.row])
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
