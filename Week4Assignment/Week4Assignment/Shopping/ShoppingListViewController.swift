//
//  ShoppingListViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/25/25.
//

import UIKit
import SkeletonView

final class ShoppingListViewController: UIViewController {
    
    private let shoppingListView = ShoppingListView()
    
    private var shoppingItems: [ShoppingItem] = []
    private let searchText: String
    private var prevIndex = 0
    private var start = 1
    private var isEnd = true
    
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
        
        fetchData()
        
        navigationItem.title = searchText
    }
    
    private func configureDelegates() {
        shoppingListView.collectionView.delegate = self
        shoppingListView.collectionView.dataSource = self
//        shoppingListView.collectionView.prefetchDataSource = self
        shoppingListView.optionStackView.delegate = self
    }
    
    private func showSkeletonView() {
        let animation
        = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        shoppingListView.collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray2), animation: animation, transition: .crossDissolve(0.5))
    }
    
    private func fetchData(sortOption: SortOption = .accuracy, start: Int = 1) {
        showSkeletonView()
        
        ShoppingAPIManager.shared.fetchData(searchText: searchText, display: 10, sortOption: sortOption, start: start, successHandler: { value in
            self.shoppingItems.append(contentsOf: value.items)
            self.updateViewsAfterFetching(value)
            self.isEnd = value.isEnd
        }, failureHandler: { error in
            self.showDefaultAlert(title: "데이터 가져오기 실패", message: error.localizedDescription)
            self.updateViewsAfterFetching(nil)
            self.isEnd = true
        })
    }
    
    private func updateViewsAfterFetching(_ shoppingResult: ShoppingResult?) {
        
        shoppingListView.collectionView.stopSkeletonAnimation()
        shoppingListView.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))

        let totalCount = NumberFormatters.demicalFormatter.string(from: (shoppingResult?.total ?? 0) as NSNumber) ?? ""
        shoppingListView.totalCountLabel.text = totalCount + "개의 검색 결과"
        
        shoppingListView.emptyLabel.isHidden = !(shoppingResult?.items ?? []).isEmpty
    }
}

// MARK: OptionStackView
extension ShoppingListViewController: OptionDidSelectDelegate {
    func didSelectButton(index: Int) {
        if index != prevIndex {
            shoppingItems.removeAll()
            start = 1
            fetchData(sortOption: SortOption.allCases[index])
            prevIndex = index
        }
    }
}

// MARK: CollectionView
extension ShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource/*, UICollectionViewDataSourcePrefetching*/ {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: ShoppingListCollectionViewCell.self, for: indexPath)
        cell.shoppingItem = shoppingItems[indexPath.item]
        cell.configureData()
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        guard let shoppingResult, let maxItem = indexPaths.map({ $0.item }).max() else { return }
//        
//        if maxItem > shoppingResult.items.count - 6, !shoppingResult.isEnd {
//            print("2")
//            fetchData(sortOption: SortOption.allCases[prevIndex], start: shoppingResult.start + 1)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item > shoppingItems.count - 2, !isEnd {
            start += 1
            print(start)
            fetchData(sortOption: SortOption.allCases[prevIndex], start: start)
        }
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
