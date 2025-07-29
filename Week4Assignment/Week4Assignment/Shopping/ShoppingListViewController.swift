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
        
        shoppingListView.searchedCollectionView.isSkeletonable = true
        
        fetchData()
        
        navigationItem.title = searchText
    }
    
    private func configureDelegates() {
        shoppingListView.searchedCollectionView.delegate = self
        shoppingListView.searchedCollectionView.dataSource = self
        shoppingListView.searchedCollectionView.prefetchDataSource = self
        
        shoppingListView.recommendedCollectionView.delegate = self
        shoppingListView.recommendedCollectionView.dataSource = self
        
        shoppingListView.optionStackView.delegate = self
    }
    
    private func showSkeletonView() {
        let animation
        = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        shoppingListView.searchedCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray2), animation: animation, transition: .crossDissolve(0.5))
    }
    
    private func fetchData(sortOption: SortOption = .accuracy, start: Int = 1) {
        if start == 1 {
            showSkeletonView()
        }
        
        let url = ShoppingRouter.getItems(searchText: searchText, display: 10, sortOption: sortOption, start: start)
        
        NetworkManager.shared.fetchData(url: url, type: ShoppingResult.self) { value in
            self.updateAfterFetching(value)
            self.isEnd = value.isEnd
        } failureHandler: { error in
            switch error {
            case .network(let networkError):
                self.showDefaultAlert(title: "네트워크 오류", message: networkError.localizedDescription)
            case .server(let serverError):
                do {
                    let serverError = try JSONDecoder().decode(NaverServerError.self, from: serverError)
                    self.showDefaultAlert(title: "데이터 가져오기 실패", message: serverError.errorMessage)
                } catch {
                    self.showDefaultAlert(title: "데이터 가져오기 실패", message: error.localizedDescription)
                }
            }
            
            self.updateAfterFetching(nil)
            self.isEnd = true
            self.start = 1
        }
    }
    
    private func updateAfterFetching(_ shoppingResult: ShoppingResult?) {
        let totalCount = shoppingResult?.total.formatted() ?? "0"
        shoppingListView.totalCountLabel.text = totalCount + "개의 검색 결과"
        
        shoppingListView.emptyLabel.isHidden = !(shoppingResult?.items ?? []).isEmpty
        
        guard let shoppingResult else {
            shoppingItems.removeAll()
            if start == 1 {
                shoppingListView.searchedCollectionView.stopSkeletonAnimation()
                shoppingListView.searchedCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            } else {
                shoppingListView.searchedCollectionView.reloadData()
            }
            return
        }
        
        if start == 1 {
            shoppingItems = shoppingResult.items
            shoppingListView.searchedCollectionView.stopSkeletonAnimation()
            shoppingListView.searchedCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            if !shoppingItems.isEmpty {
                shoppingListView.searchedCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        } else {
            let startIndex = shoppingItems.count
            let endIndex = startIndex + shoppingResult.items.count
            let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0)}
            
            shoppingItems.append(contentsOf: shoppingResult.items)
            shoppingListView.searchedCollectionView.insertItems(at: indexPaths)
        }
    }
}

// MARK: OptionStackView
extension ShoppingListViewController: OptionDidSelectDelegate {
    func didSelectButton(index: Int) {
        if index != prevIndex {
            shoppingItems.removeAll()
            start = 1
            isEnd = true
            fetchData(sortOption: SortOption.allCases[index])
            prevIndex = index
        }
    }
}

// MARK: CollectionView
extension ShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shoppingListView.searchedCollectionView {
            return shoppingItems.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == shoppingListView.searchedCollectionView {
            let cell = collectionView.dequeueReusableCell(cellType: SearchedCollectionViewCell.self, for: indexPath)
            cell.shoppingItem = shoppingItems[indexPath.item]
            cell.configureData()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(cellType: RecommendedCollectionViewCell.self, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if collectionView == shoppingListView.searchedCollectionView {
            guard let maxItem = indexPaths.map({ $0.item }).max() else { return }
            
            if maxItem > shoppingItems.count - 6, !isEnd {
                start += 1
                isEnd = true
                fetchData(sortOption: SortOption.allCases[prevIndex], start: start)
            }
        }
    }
    
    // TODO: CancelPrefetching
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        <#code#>
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == shoppingListView.searchedCollectionView {
            if indexPath.item > shoppingItems.count - 2, !isEnd {
                start += 1
                isEnd = true
                fetchData(sortOption: SortOption.allCases[prevIndex], start: start)
            }
        }
    }
}

// MARK: SkeletonView
extension ShoppingListViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        if skeletonView == shoppingListView.searchedCollectionView {
            return SearchedCollectionViewCell.identifier
        } else {
            return RecommendedCollectionViewCell.identifier
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if skeletonView == shoppingListView.searchedCollectionView {
            return 4
        } else {
            return 5
        }
    }
}
