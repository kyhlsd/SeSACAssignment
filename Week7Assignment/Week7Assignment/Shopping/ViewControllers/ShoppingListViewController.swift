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
    let viewModel = ShoppingListViewModel()
    
    override func loadView() {
        self.view = shoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDelegates()
        
        shoppingListView.searchedCollectionView.isSkeletonable = true
        shoppingListView.recommendedCollectionView.isSkeletonable = true
        
        configureBindings()
        
        viewModel.input.viewDidLoadTrigger.value = ()
        
        navigationItem.title = viewModel.searchText
    }
    
    private func configureDelegates() {
        shoppingListView.searchedCollectionView.delegate = self
        shoppingListView.searchedCollectionView.dataSource = self
        shoppingListView.searchedCollectionView.prefetchDataSource = self
        
        shoppingListView.recommendedCollectionView.delegate = self
        shoppingListView.recommendedCollectionView.dataSource = self
        
        shoppingListView.optionStackView.delegate = self
    }
    
    private func configureBindings() {
        viewModel.output.searchSkeletonTrigger.bind { [weak self] visible in
            if visible {
                self?.showSearchSkeletonView()
            } else {
                self?.hideSearchSkeletonView()
            }
        }
        
        viewModel.output.recommendedSkeletonTrigger.bind { [weak self] visible in
            if visible {
                self?.showRecommendedSkeletonView()
            } else {
                self?.hideRecommendedSkeletonView()
            }
        }
        
        viewModel.output.searchedItems.bind { [weak self] value in
            self?.shoppingListView.searchedCollectionView.reloadData()
            self?.shoppingListView.emptyLabel.isHidden = !(value.isEmpty)
        }
        
        viewModel.output.recommendedItems.bind { [weak self] _ in
            self?.shoppingListView.recommendedCollectionView.reloadData()
        }
        
        viewModel.output.scrollToTopTrigger.bind { [weak self] _ in
            self?.shoppingListView.searchedCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
        viewModel.output.totalCount.bind { [weak self] count in
            self?.shoppingListView.totalCountLabel.text = count.formatted() + "개의 검색 결과"
        }
        
        viewModel.output.errorMessage.bind { [weak self] message in
            self?.showDefaultAlert(title: "데이터 가져오기 실패", message: message, isDark: true)
        }
    }
    
    private func showSearchSkeletonView() {
        let animation
        = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        shoppingListView.searchedCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray2), animation: animation, transition: .crossDissolve(0.5))
    }
    
    private func hideSearchSkeletonView() {
        shoppingListView.searchedCollectionView.stopSkeletonAnimation()
        shoppingListView.searchedCollectionView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
    }
    
    private func showRecommendedSkeletonView() {
        let animation
        = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        shoppingListView.recommendedCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray2), animation: animation, transition: .crossDissolve(0.5))
    }
    
    private func hideRecommendedSkeletonView() {
        shoppingListView.recommendedCollectionView.stopSkeletonAnimation()
        shoppingListView.recommendedCollectionView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
    }
}

// MARK: OptionStackView
extension ShoppingListViewController: OptionDidSelectDelegate {
    func didSelectButton(index: Int) {
        viewModel.input.optionTappedTrigger.value = index
    }
}

// MARK: CollectionView
extension ShoppingListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shoppingListView.searchedCollectionView {
            return viewModel.output.searchedItems.value.count
        } else {
            return viewModel.output.recommendedItems.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == shoppingListView.searchedCollectionView {
            let cell = collectionView.dequeueReusableCell(cellType: SearchedCollectionViewCell.self, for: indexPath)
            cell.shoppingItem = viewModel.output.searchedItems.value[indexPath.item]
            cell.configureData()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(cellType: RecommendedCollectionViewCell.self, for: indexPath)
            cell.configureData(with: viewModel.output.recommendedItems.value[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if collectionView == shoppingListView.searchedCollectionView {
            viewModel.input.imageDownloadTrigger.value = indexPaths
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        if collectionView == shoppingListView.searchedCollectionView {
            viewModel.input.imageRemoveTrigger.value = indexPaths
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == shoppingListView.searchedCollectionView {
            viewModel.input.pagingTrigger.value = indexPath.item
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
