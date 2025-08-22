//
//  HomeworkDetailViewController.swift
//  Week8Assignment
//
//  Created by 김영훈 on 8/22/25.
//

import UIKit

final class HomeworkDetailViewController: UIViewController {
    
    private let name: String
    
    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        view.backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
