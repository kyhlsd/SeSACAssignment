//
//  ShoppingListViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import UIKit
import Alamofire
import SkeletonView

final class ShoppingListViewController: UIViewController {

    private let shoppingListView = ShoppingListView()
    
    private var shoppingResult: ShoppingResult?
    private let searchText: String
    private var prevIndex = 0
    
    init(searchText: String) {
        self.searchText = searchText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = shoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDelegates()
    
        shoppingListView.collectionView.isSkeletonable = true
        
        fetchData(searchText: searchText)
        
        navigationItem.title = searchText
    }
    
    private func configureDelegates() {
        shoppingListView.collectionView.delegate = self
        shoppingListView.collectionView.dataSource = self
        shoppingListView.optionStackView.delegate = self
    }
    
    private func showSkeletonView() {
        let animation
        = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        shoppingListView.collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray2), animation: animation, transition: .crossDissolve(0.5))
    }
    
    private func fetchData(searchText: String, sortOption: SortOption = .accuracy) {
        showSkeletonView()
        
        let url = ShoppingAPIHelper.getURL(searchText: searchText, sortOption: sortOption)
        let headers = ShoppingAPIHelper.headers
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResult.self) { response in
                switch response.result {
                case .success(let value):
                    self.shoppingResult = value
                    self.shoppingListView.collectionView.stopSkeletonAnimation()
                    self.shoppingListView.collectionView.hideSkeleton()
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

// MARK: SkeletonView
extension ShoppingListViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return ShoppingListCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
