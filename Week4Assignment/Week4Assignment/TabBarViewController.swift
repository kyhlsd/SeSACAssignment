//
//  TabBarViewController.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers()
        setAppearance()
    }
    
    private func setViewControllers() {
        let lottoViewController = LottoViewController()
        lottoViewController.tabBarItem = UITabBarItem(title: "Lotto", image: UIImage(systemName: "die.face.5"), tag: 0)
        
        let searchMovieViewController = SearchMovieViewController()
        searchMovieViewController.tabBarItem = UITabBarItem(title: "Movie", image: UIImage(systemName: "movieclapper"), tag: 1)
        
        let shoppingNavigationViewController = UINavigationController(rootViewController: SearchShoppingViewController())
        shoppingNavigationViewController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        shoppingNavigationViewController.tabBarItem = UITabBarItem(title: "Shopping", image: UIImage(systemName: "cart"), tag: 2)
        
        setViewControllers([lottoViewController, searchMovieViewController, shoppingNavigationViewController], animated: true)
    }
    
    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.shadowColor = .lightGray
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
