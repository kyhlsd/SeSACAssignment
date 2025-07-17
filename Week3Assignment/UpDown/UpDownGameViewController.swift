//
//  UpDownGameViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit

class UpDownGameViewController: UIViewController, Identifying {

    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var numberCollectionView: UICollectionView!
    @IBOutlet var showResultButton: UIButton!
    
    private let maxNumber: Int
    
    init(maxNumber: Int) {
        self.maxNumber = maxNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, maxNumber: Int) {
        self.maxNumber = maxNumber
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }

    private func configureCollectionView() {
        numberCollectionView.delegate = self
        numberCollectionView.dataSource = self
        
        let xib = UINib(nibName: UpDownGameCollectionViewCell.identifier, bundle: nil)
        numberCollectionView.register(xib, forCellWithReuseIdentifier: UpDownGameCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let deviceWidth = Double(view.bounds.width)
        let cellCountInRow: Double = 6
        let cellWidth = (deviceWidth - (4 * 2) - (4 * (cellCountInRow - 1))) / cellCountInRow
        
        let collectionViewHeight = Double(numberCollectionView.bounds.height)
        let cellCountInCol = Double(Int((collectionViewHeight + 4) / (cellWidth + 4)))
        let verticalEdge = (collectionViewHeight - (cellWidth * cellCountInCol) - (4 * (cellCountInCol - 1))) / 2
        print(cellWidth)
        print(collectionViewHeight)
        print(cellCountInCol)
        print(verticalEdge)
        
        layout.sectionInset = UIEdgeInsets(top: verticalEdge, left: 4, bottom: verticalEdge, right: 4)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        numberCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func popViewController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension UpDownGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(for: indexPath, cellType: UpDownGameCollectionViewCell.self)
        cell.configure(indexPath.item + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}
