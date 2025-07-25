//
//  ShoppingListViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import UIKit
import Alamofire
import SnapKit

final class ShoppingListViewController: UIViewController {

    private let shoppingListView = ShoppingListView()
    
    private var shoppingResult: ShoppingResult?
    private let searchText = "캠핑카"
    private var prevIndex = 0
    
    override func loadView() {
        self.view = shoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shoppingListView.collectionView.delegate = self
        shoppingListView.collectionView.dataSource = self
        shoppingListView.optionStackView.delegate = self
        
        fetchData(searchText: searchText)
        
        navigationItem.title = searchText
    }
    
    private func fetchData(searchText: String, sortOption: SortOption = .accuracy) {
        let url = ShoppingAPIHelper.getURL(searchText: searchText, sortOption: sortOption)
        let headers = ShoppingAPIHelper.headers
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResult.self) { response in
                switch response.result {
                case .success(let value):
                    self.shoppingResult = value
                    self.shoppingListView.collectionView.reloadData()
                    let totalCount = NumberFormatters.demicalFormatter.string(from: value.total as NSNumber) ?? ""
                    self.shoppingListView.totalCountLabel.text = totalCount + " 개의 검색 결과"
                case .failure(let error):
                    print(error)
                }
            }
    }
}

// MARK: OptionStackView
extension ShoppingListViewController: OptionDidSelectDelegate {
    func didSelectButton(index: Int) {
        if index != prevIndex {
            fetchData(searchText: searchText, sortOption: SortOption.allCases[index])
            prevIndex = index
        }
    }
}

// MARK: CollectionView
extension ShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingResult?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: ShoppingListCollectionViewCell.self, for: indexPath)
        if let shoppingResult {
            cell.shoppingItem = shoppingResult.items[indexPath.row]
            cell.configureData()
        }
        return cell
    }
}

// MARK: Views
final fileprivate class ShoppingListView: UIView {
    fileprivate let totalCountLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGreen
        return label
    }()
    
    fileprivate let optionStackView = {
        let list = SortOption.allCases.map { $0.rawValue }
        let optionStackView = OptionStackView(list: list)
        return optionStackView
    }()
    
    fileprivate let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        
        let deviceWidth = UIScreen.main.bounds.width
        let width = (deviceWidth - (12 * 2) - 12) / 2
        layout.itemSize = CGSize(width: width, height: width + 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: ShoppingListCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingListView: ViewDesignProtocol {
    func configureHierarchy() {
        [collectionView, optionStackView, totalCountLabel].forEach {
            addSubview($0)
        }
    }
    
    func configureLayout() {
        let safeArea = safeAreaLayoutGuide
        
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(12)
            make.height.equalTo(18)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(8)
            make.leading.equalTo(totalCountLabel)
            make.trailing.lessThanOrEqualTo(totalCountLabel)
            make.height.equalTo(36)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(optionStackView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    func configureView() {
        backgroundColor = .black
    }
}
