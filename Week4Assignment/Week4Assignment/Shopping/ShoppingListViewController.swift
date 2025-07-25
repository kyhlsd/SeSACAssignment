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
    
    override func loadView() {
        self.view = shoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shoppingListView.collectionView.delegate = self
        shoppingListView.collectionView.dataSource = self
        
        fetchData(query: "캠핑카")
    }
    
    private func fetchData(query: String) {
        let url = ShoppingAPIHelper.getURL(query: query)
        let headers = ShoppingAPIHelper.headers
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResult.self) { response in
                switch response.result {
                case .success(let value):
                    self.shoppingResult = value
                    self.shoppingListView.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}

//MARK: CollectionView
extension ShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingResult?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: ShoppingListCollectionViewCell.self, for: indexPath)
        if let shoppingResult {
            cell.configureData(with: shoppingResult.items[indexPath.item])
        }
        return cell
    }
}

// MARK: Views
final fileprivate class ShoppingListView: UIView {
    fileprivate let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
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
        [collectionView].forEach {
            addSubview($0)
        }
    }
    
    func configureLayout() {
        let safeArea = safeAreaLayoutGuide
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    func configureView() {
        backgroundColor = .black
    }
}
