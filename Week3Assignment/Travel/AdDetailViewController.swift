//
//  AdDetailViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

class AdDetailViewController: UIViewController, Identifying {

    @IBOutlet var adTitleLabel: UILabel!
    
    init(ad: Travel) {
        self.ad = ad
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, ad: Travel) {
        self.ad = ad
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let ad: Travel
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure(with: ad)
    }

    private func configure(with ad: Travel) {
        adTitleLabel.text = ad.title
    }
    
    @IBAction func exitBarButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
