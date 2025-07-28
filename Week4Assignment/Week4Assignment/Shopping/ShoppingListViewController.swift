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
    
    private var shoppingResult: ShoppingResult?
    private let searchText: String
    private var prevIndex = 0
    private var prevOffset: CGPoint?
    
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
        print(#function)
        showSkeletonView()
        
        ShoppingAPIManager.shared.fetchData(searchText: searchText, sortOption: sortOption, start: start, successHandler: { value in
            
            if let _ = self.shoppingResult {
                self.shoppingResult?.items.append(contentsOf: value.items)
            } else {
                self.shoppingResult = value
            }
            
            self.updateViewsAfterFetching(value)
        }, failureHandler: { error in
            self.showDefaultAlert(title: "데이터 가져오기 실패", message: error.localizedDescription)
            self.updateViewsAfterFetching(nil)
        })
    }
    
    private func updateViewsAfterFetching(_ shoppingResult: ShoppingResult?) {
        shoppingListView.collectionView.stopSkeletonAnimation()
        shoppingListView.collectionView.hideSkeleton()
        
//        if let shoppingResult {
//            print(shoppingResult.start)
//            let itemIndex = (shoppingResult.start - 1) * shoppingResult.display + 1
//            print(itemIndex)
//            shoppingListView.collectionView.scrollToItem(at: IndexPath(item: itemIndex, section: 0), at: .top, animated: false)
//        }
        
        let totalCount = NumberFormatters.demicalFormatter.string(from: (shoppingResult?.total ?? 0) as NSNumber) ?? ""
        shoppingListView.totalCountLabel.text = totalCount + "개의 검색 결과"
        
        shoppingListView.emptyLabel.isHidden = !(shoppingResult?.items ?? []).isEmpty
    }
}

// MARK: OptionStackView
extension ShoppingListViewController: OptionDidSelectDelegate {
    func didSelectButton(index: Int) {
        if index != prevIndex {
            shoppingResult = nil
            fetchData(sortOption: SortOption.allCases[index])
            prevIndex = index
        }
    }
}

// MARK: CollectionView
extension ShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource/*, UICollectionViewDataSourcePrefetching*/ {
    
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
    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        guard let shoppingResult, let maxRow = indexPaths.map({ $0.row }).max() else { return }
//        
//        if maxRow > shoppingResult.items.count - 6 {
//            print("2")
//            fetchData(sortOption: SortOption.allCases[prevIndex], start: shoppingResult.start + 1)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let shoppingResult else { return }
        
        if indexPath.row > shoppingResult.items.count - 6 {
            fetchData(sortOption: SortOption.allCases[prevIndex], start: shoppingResult.start + 1)
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
