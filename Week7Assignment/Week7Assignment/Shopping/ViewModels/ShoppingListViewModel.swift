//
//  ShoppingListViewModel.swift
//  Week4Assignment
//
//  Created by 김영훈 on 8/12/25.
//

import Foundation

final class ShoppingListViewModel {
    
    var searchText = ""
    
    var input: Input
    var output: Output
    
    struct Input {
        let viewDidLoadTrigger = Observable(())
        let optionTappedTrigger = Observable(0)
        let pagingTrigger = Observable(0)
        let imageDownloadTrigger = Observable([IndexPath]())
        let imageRemoveTrigger = Observable([IndexPath]())
    }
    
    struct Output {
        let searchedItems = Observable([ShoppingItem]())
        let recommendedItems = Observable([ShoppingItem]())
        let searchSkeletonTrigger = Observable(false)
        let recommendedSkeletonTrigger = Observable(false)
        let totalCount = Observable(0)
        let scrollToTopTrigger = Observable(())
        let errorMessage = Observable("")
    }
    
    private var prevIndex = 0
    private var start = 1
    private var isEnd = true
    
    private let recommendWord = "북극곰"
    
    init() {
        input = Input()
        output = Output()
        
        input.viewDidLoadTrigger.bind { _ in
            self.fetchDataWithSearchText()
            self.fetchDataWithRecommended()
        }
        
        input.optionTappedTrigger.bind { _ in
            self.changeSortOption()
        }
        
        input.pagingTrigger.bind { index in
            self.fetchNextPage(index)
        }
        
        input.imageDownloadTrigger.bind { indexPaths in
            self.downloadImages(indexPaths: indexPaths)
        }
        
        input.imageRemoveTrigger.bind { indexPaths in
            self.cancelDownloadImages(indexPaths: indexPaths)
            self.removeImages(indexPaths: indexPaths)
        }
    }
    
    private func fetchNextPage(_ index: Int) {
        if index == output.searchedItems.value.count - 6, !isEnd {
            start += 1
            isEnd = true
            fetchDataWithSearchText(sortOption: SortOption.allCases[prevIndex], start: start)
        }
    }
    
    private func changeSortOption() {
        let index = input.optionTappedTrigger.value
        if index != prevIndex {
            start = 1
            isEnd = true
            fetchDataWithSearchText(sortOption: SortOption.allCases[index])
            prevIndex = index
        }
    }
    
    private func fetchDataWithSearchText(sortOption: SortOption = .accuracy, start: Int = 1) {
        if start == 1 {
            output.searchSkeletonTrigger.value = true
            if !output.searchedItems.value.isEmpty {
                self.output.scrollToTopTrigger.value = ()
            }
        }
        
        let url = Router.getItems(searchText: searchText, display: 10, sortOption: sortOption, start: start)
        
        NetworkManager.shared.fetchData(url: url, type: ShoppingResult.self) { value in
            if start == 1 {
                self.output.searchedItems.value = value.items
                self.output.searchSkeletonTrigger.value = false
            } else {
                self.output.searchedItems.value.append(contentsOf: value.items)
            }
            self.output.totalCount.value = value.total
            self.isEnd = value.isEnd
        } failureHandler: { error in
            if start == 1 {
                self.output.searchSkeletonTrigger.value = false
                self.output.totalCount.value = 0
                self.output.searchedItems.value.removeAll()
            }
            switch error {
            case .network(let networkError):
                self.output.errorMessage.value = networkError.localizedDescription
            case .server(let serverError):
                do {
                    let serverError = try JSONDecoder().decode(NaverServerError.self, from: serverError)
                    self.output.errorMessage.value = serverError.errorMessage
                } catch {
                    self.output.errorMessage.value = error.localizedDescription
                }
            }
            self.isEnd = true
            self.start = 1
        }
    }
    
    private func fetchDataWithRecommended() {
        output.recommendedSkeletonTrigger.value = true
        
        let url = Router.getItems(searchText: recommendWord, display: 10, sortOption: .accuracy, start: 1)
        
        NetworkManager.shared.fetchData(url: url, type: ShoppingResult.self) { value in
            self.output.recommendedItems.value = value.items
            self.output.recommendedSkeletonTrigger.value = false
        } failureHandler: { error in
            switch error {
            case .network(let networkError):
                self.output.errorMessage.value = networkError.localizedDescription
            case .server(let serverError):
                do {
                    let serverError = try JSONDecoder().decode(NaverServerError.self, from: serverError)
                    self.output.errorMessage.value = serverError.errorMessage
                } catch {
                    self.output.errorMessage.value = error.localizedDescription
                }
            }
            self.output.recommendedSkeletonTrigger.value = false
        }
    }
    
    private func downloadImages(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            ImageDownloadManager.shared.download(with: output.searchedItems.value[indexPath.item].image)
        }
    }
    
    private func cancelDownloadImages(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            ImageDownloadManager.shared.cancel(with: output.searchedItems.value[indexPath.item].image)
        }
    }
    
    private func removeImages(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            ImageDownloadManager.shared.remove(forKey: output.searchedItems.value[indexPath.item].image)
        }
    }
}
