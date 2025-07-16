//
//  CityDetailViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/16/25.
//

import UIKit
import Kingfisher

class CityDetailViewController: UIViewController, Identifying {

    @IBOutlet var cityImageView: UIImageView!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityExplainLabel: UILabel!
    @IBOutlet var exitButton: UIButton!
    
    private let city: City
    
    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, city: City) {
        self.city = city
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        cityImageView.kf.indicatorType = .activity
        cityImageView.layer.cornerRadius = 12
        let url = URL(string: city.cityImage)
        cityImageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        
        cityNameLabel.text = "\(city.cityName) | \(city.cityEnglishName)"
        cityExplainLabel.text = city.cityExplain
        
        exitButton.layer.cornerRadius = exitButton.frame.height / 2
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
