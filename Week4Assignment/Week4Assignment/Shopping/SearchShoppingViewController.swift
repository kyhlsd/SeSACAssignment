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

        navigationItem.title = "영캠러의 쇼핑쇼핑"
    }
}


