//
//  AdDetailViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

class AdDetailViewController: UIViewController, Identifying {

    @IBOutlet var adTitleLabel: UILabel!
    
    var selectedAd: Travel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedAd = selectedAd {
            configure(with: selectedAd)
        }
    }

    func configure(with ad: Travel) {
        adTitleLabel.text = ad.title
    }
    
    @IBAction func exitBarButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
