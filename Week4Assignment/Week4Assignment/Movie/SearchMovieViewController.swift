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
    
    private let searchMovieView = SearchMovieView()
    
    private var isFetching = false {
        didSet {
            isFetching ? searchMovieView.indicatorView.startAnimating() : searchMovieView.indicatorView.stopAnimating()
        }
    }
    private var error: Error?
    
    private let lastDate = {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            print("Failed to get yesterday date")
            return "00000000"
        }
        return DateFormatters.yyyyMMddFormatter.string(from: yesterday)
    }()
    private var boxOfficeList = [BoxOffice]() {
        didSet {
            searchMovieView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = searchMovieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchMovieView.searchTextField.delegate = self
        searchMovieView.tableView.delegate = self
        searchMovieView.tableView.dataSource = self
        
        setTapGesture()
        searchMovieView.searchButton.addTarget(self, action: #selector(searchMovie), for: .touchUpInside)
        
        fetchData(targetDate: lastDate)
    }
    
    private func fetchData(targetDate: String) {
        if isFetching { return }
        
        isFetching = true
        
        MovieAPIManager.shared.fetchData(targetDate: targetDate, successHandler: { value in
            self.boxOfficeList = value.boxOfficeResult.dailyBoxOfficeList
            self.error = nil
            self.isFetching = false
        }, failureHandler: { error in
            self.boxOfficeList.removeAll()
            self.error = error
            self.isFetching = false
        })
    }
    
    @objc
    private func searchMovie() {
        do {
            let targetDate = try getValidDate()
            searchMovieView.nonValidDateLabel.text = ""
            dismissKeyboard()
            
            fetchData(targetDate: targetDate)
        } catch {
            setNonValidDateLabel(with: error)
        }
    }
    
    private func getValidDate() throws -> String {
        let trimmed = searchMovieView.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
            searchMovieView.nonValidDateLabel.text = "어제까지의 날짜만 조회 가능합니다."
        case NonValidDateError.nonDateFormat:
            searchMovieView.nonValidDateLabel.text = "올바른 날짜 형식이 아닙니다. ex) 20250723"
        default:
            searchMovieView.nonValidDateLabel.text = "알 수 없는 오류가 발생했습니다."
        }
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
            let cell = tableView.dequeueReusableCell(cellType: EmptyListTableViewCell.self, for: indexPath)
            cell.configureLabel(error)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(cellType: SearchMovieTableViewCell.self, for: indexPath)
            cell.configureData(with: boxOfficeList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if boxOfficeList.isEmpty {
            return 60
        } else {
            return 40
        }
    }
}

// MARK: TapGesture - DismissKeyboard
extension SearchMovieViewController: UseKeyboardProtocol {
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchMovieViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view as? UIButton == nil)
    }
}

// MARK: Views
final fileprivate class SearchMovieView: UIView {
    fileprivate let backgroundImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .searchMovieBackground
        imageView.alpha = 0.2
        return imageView
    }()
    fileprivate let searchTextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "날짜를 입력하세요. ex) 20250723", attributes: [.foregroundColor: UIColor.darkGray])
        textField.textColor = .white
        textField.returnKeyType = .search
        textField.clearButtonMode = .always
        textField.overrideUserInterfaceStyle = .dark
        return textField
    }()
    fileprivate let nonValidDateLabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    fileprivate let searchButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .white
        return button
    }()
    fileprivate let tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(cellType: SearchMovieTableViewCell.self)
        tableView.register(cellType: EmptyListTableViewCell.self)
        return tableView
    }()
    fileprivate let indicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        indicatorView.color = .white
        return indicatorView
    }()
    
    override func draw(_ rect: CGRect) {
        searchTextField.layer.addBorder([.bottom], color: .white, width: 2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchMovieView: ViewDesignProtocol {
    func configureHierarchy() {
        [backgroundImageView, searchTextField, nonValidDateLabel, searchButton, tableView, indicatorView].forEach {
            addSubview($0)
        }
    }
    
    func configureLayout() {
        let safeArea = safeAreaLayoutGuide
        
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
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
        }
    }
    
    func configureView() {
        backgroundColor = .black
    }
}
