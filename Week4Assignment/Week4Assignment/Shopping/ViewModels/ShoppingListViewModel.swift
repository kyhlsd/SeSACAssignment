//
//  ShoppingListViewModel.swift
//  Week4Assignment
//
//  Created by 김영훈 on 8/12/25.
//

import Foundation

final class ShoppingListViewModel {
    
    let searchText: String
    
    let inputViewDidLoadTrigger = Observable(())
    let inputOptionTappedTrigger = Observable(0)
    let inputPagingTrigger = Observable(0)
    let inputImageDownloadTrigger = Observable([IndexPath]())
    let inputImageRemoveTrigger = Observable([IndexPath]())
    
    let outputSearchedItems = Observable([ShoppingItem]())
    let outputRecommendedItems = Observable([ShoppingItem]())
    
    let outputSearchSkeletonTrigger = Observable(false)
    let outputRecommendedSkeletonTrigger = Observable(false)
    let outputListCount = Observable(0)
    let outputScrollToTopTrigger = Observable(())
    
    let outputErrorMessage = Observable("")
    
    private var prevIndex = 0
    private var start = 1
    private var isEnd = true
    
    private let recommendWord = "북극곰"
    
    init(searchText: String) {
        self.searchText = searchText
        
        inputViewDidLoadTrigger.bind { _ in
            self.fetchDataWithSearchText()
            self.fetchDataWithRecommended()
        }
        
        inputOptionTappedTrigger.bind { _ in
            self.changeSortOption()
        }
        
        inputPagingTrigger.bind { index in
            self.fetchNextPage(index)
        }
        
        inputImageDownloadTrigger.bind { indexPaths in
            self.downloadImages(indexPaths: indexPaths)
        }
        
        inputImageRemoveTrigger.bind { indexPaths in
            self.cancelDownloadImages(indexPaths: indexPaths)
            self.removeImages(indexPaths: indexPaths)
        }
    }
    
    private func fetchNextPage(_ index: Int) {
        if index == outputSearchedItems.value.count - 6, !isEnd {
            start += 1
            isEnd = true
            fetchDataWithSearchText(sortOption: SortOption.allCases[prevIndex], start: start)
        }
    }
    
    private func changeSortOption() {
        let index = inputOptionTappedTrigger.value
        if index != prevIndex {
            start = 1
            isEnd = true
            fetchDataWithSearchText(sortOption: SortOption.allCases[index])
            prevIndex = index
        }
    }
    
    private func fetchDataWithSearchText(sortOption: SortOption = .accuracy, start: Int = 1) {
        if start == 1 {
            outputSearchSkeletonTrigger.value = true
            if !outputSearchedItems.value.isEmpty {
                self.outputScrollToTopTrigger.value = ()
            }
        }
        
        let url = ShoppingRouter.getItems(searchText: searchText, display: 10, sortOption: sortOption, start: start)
        
        NetworkManager.shared.fetchData(url: url, type: ShoppingResult.self) { value in
            if start == 1 {
                self.outputSearchedItems.value = value.items
                self.outputSearchSkeletonTrigger.value = false
            } else {
                self.outputSearchedItems.value.append(contentsOf: value.items)
            }
            self.outputListCount.value = value.total
            self.isEnd = value.isEnd
        } failureHandler: { error in
            if start == 1 {
                self.outputSearchSkeletonTrigger.value = false
                self.outputListCount.value = 0
                self.outputSearchedItems.value.removeAll()
            }
            switch error {
            case .network(let networkError):
                self.outputErrorMessage.value = networkError.localizedDescription
            case .server(let serverError):
                do {
                    let serverError = try JSONDecoder().decode(NaverServerError.self, from: serverError)
                    self.outputErrorMessage.value = serverError.errorMessage
                } catch {
                    self.outputErrorMessage.value = error.localizedDescription
                }
            }
            self.isEnd = true
            self.start = 1
        }
    }
    
    private func fetchDataWithRecommended() {
        outputRecommendedSkeletonTrigger.value = true
        
        let url = ShoppingRouter.getItems(searchText: recommendWord, display: 10, sortOption: .accuracy, start: 1)
        
        NetworkManager.shared.fetchData(url: url, type: ShoppingResult.self) { value in
            self.outputRecommendedItems.value = value.items
            self.outputRecommendedSkeletonTrigger.value = false
        } failureHandler: { error in
            switch error {
            case .network(let networkError):
                self.outputErrorMessage.value = networkError.localizedDescription
            case .server(let serverError):
                do {
                    let serverError = try JSONDecoder().decode(NaverServerError.self, from: serverError)
                    self.outputErrorMessage.value = serverError.errorMessage
                } catch {
                    self.outputErrorMessage.value = error.localizedDescription
                }
            }
            self.outputRecommendedSkeletonTrigger.value = false
        }
    }
    
    private func downloadImages(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            ImageCacheHelper.shared.download(with: outputSearchedItems.value[indexPath.item].image)
        }
    }
    
    private func cancelDownloadImages(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            ImageCacheHelper.shared.cancel(with: outputSearchedItems.value[indexPath.item].image)
        }
    }
    
    private func removeImages(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            ImageCacheHelper.shared.remove(forKey: outputSearchedItems.value[indexPath.item].image)
        }
    }
}
