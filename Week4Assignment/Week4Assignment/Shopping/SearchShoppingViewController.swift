//
//  SearchShoppingViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/26/25.
//

import UIKit

final class SearchShoppingViewController: UIViewController {

    private let searchShoppingView = SearchShoppingView()
    
    override func loadView() {
        self.view = searchShoppingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegates()
        configureNavigationItem()
        
        setTapGesture()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "영캠러의 쇼핑쇼핑"
        navigationItem.backButtonTitle = " "
    }
    
    private func configureDelegates() {
        searchShoppingView.searchBar.delegate = self
    }
}

extension SearchShoppingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if searchText.count >= 2 {
            let viewController = ShoppingListViewController(searchText: searchText)
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            showDefaultAlert(title: "검색 오류", message: "검색어를 2자 이상 입력해주세요.")
        }
    }
}

extension SearchShoppingViewController: UseKeyboardProtocol {
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


