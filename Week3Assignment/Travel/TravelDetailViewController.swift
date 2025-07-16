//
//  TravelDetailViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit
import Kingfisher

class TravelDetailViewController: UIViewController, Identifying {

    @IBOutlet var travelImageView: UIImageView!
    @IBOutlet var travelTitleLabel: UILabel!
    @IBOutlet var travelDescriptionLabel: UILabel!
    @IBOutlet var exitButton: UIButton!
    
    var travel: Travel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        travelImageView.layer.cornerRadius = 12
        exitButton.layer.cornerRadius = exitButton.frame.height / 2
        
        travelImageView.kf.indicatorType = .activity
        
        if let travel = travel {
            configure(with: travel)
        }
    }

    func configure(with travel: Travel) {
        if let image = travel.travelImage {
            let url = URL(string: image)
            travelImageView.kf.setImage(with: url)
        }
        
        travelTitleLabel.text = travel.title
        travelDescriptionLabel.text = travel.description
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
