//
//  SearchShoppingViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/26/25.
//

import UIKit

final class SearchShoppingViewController: UIViewController {

    private let searchShoppingView = SearchShoppingView()
    private let viewModel = SearchShoppingViewModel()
    
    override func loadView() {
        self.view = searchShoppingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegates()
        configureNavigationItem()
        
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchShoppingView.searchBar.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "영캠러의 쇼핑쇼핑"
        navigationItem.backButtonTitle = " "
    }
    
    private func configureDelegates() {
        searchShoppingView.searchBar.delegate = self
    }
    
    private func configureBindings() {
        viewModel.outputSearchTrigger.bind { [weak self] text in
            let viewController = ShoppingListViewController()
            viewController.viewModel.searchText = text
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        viewModel.outputAlertTrigger.bind { [weak self] title, message in
            self?.showDefaultAlert(title: title, message: message, isDark: true)
        }
    }
}

extension SearchShoppingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchBarText.value = searchBar.text
    }
}


