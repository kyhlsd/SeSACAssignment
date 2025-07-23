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
    
    init(travel: Travel) {
        self.travel = travel
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, travel: Travel) {
        self.travel = travel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let travel: Travel
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        travelImageView.layer.cornerRadius = 12
        travelImageView.kf.indicatorType = .activity
        if let image = travel.travelImage {
            let url = URL(string: image)
            travelImageView.kf.setImage(with: url, options: [
                .processor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        }
        
        travelTitleLabel.text = travel.title
        travelDescriptionLabel.text = travel.description
        
        exitButton.layer.cornerRadius = exitButton.frame.height / 2
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
