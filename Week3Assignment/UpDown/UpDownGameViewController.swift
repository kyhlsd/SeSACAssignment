//
//  UpDownGameViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit

class UpDownGameViewController: UIViewController, Identifying {

    private let targetNumber: Int
    
    init(targetNumber: Int) {
        self.targetNumber = targetNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, targetNumber: Int) {
        self.targetNumber = targetNumber
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(targetNumber)
    }

    
    @IBAction func popViewController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
