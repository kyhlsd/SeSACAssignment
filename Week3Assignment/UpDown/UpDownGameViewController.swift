//
//  UpDownGameViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/17/25.
//

import UIKit
import Toast

class UpDownGameViewController: UIViewController, Identifying {

    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var numberCollectionView: UICollectionView!
    @IBOutlet var showResultButton: UIButton!
    
    private let maxNumber: Int
    private var selectedNumber: Int? {
        didSet {
            let state = (selectedNumber == nil)
            updateShowResultButton(state)
        }
    }
    private let targetNumber: Int
    private var count = 0
    private var numberList: [Int]
    private var complete = false
    
    init(maxNumber: Int) {
        self.maxNumber = maxNumber
        self.targetNumber = Int.random(in: 1...maxNumber)
        self.numberList = [Int](1...maxNumber)
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, maxNumber: Int) {
        self.maxNumber = maxNumber
        self.targetNumber = Int.random(in: 1...maxNumber)
        self.numberList = [Int](1...maxNumber)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureShowResultButton()
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
        
        layout.sectionInset = UIEdgeInsets(top: verticalEdge, left: 4, bottom: verticalEdge, right: 4)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        numberCollectionView.collectionViewLayout = layout
    }
    
    private func configureShowResultButton() {
        showResultButton.setTitleColor(.white, for: .disabled)
        showResultButton.isEnabled = true
    }
    
    private func updateShowResultButton(_ isSelectedNil: Bool) {
        if isSelectedNil {
            showResultButton.isEnabled = false
            showResultButton.backgroundColor = .gray
        } else {
            showResultButton.isEnabled = true
            showResultButton.backgroundColor = .black
        }
    }
    
    @IBAction func showResultButtonTapped(_ sender: UIButton) {
        guard let selectedNumber = selectedNumber else {
            return
        }
        
        if complete {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if selectedNumber == targetNumber {
            resultLabel.text = "GOOD!"
            complete = true
            showResultButton.setTitle("다시하기", for: .normal)
        } else if selectedNumber < targetNumber {
            resultLabel.text = "UP"
            updateNumberList(selectedNumber, removeUp: false)
        } else {
            resultLabel.text = "DOWN"
            updateNumberList(selectedNumber, removeUp: true)
        }
        
        count += 1
        countLabel.text = "시도 횟수 : \(count)"
    }
    
    private func updateNumberList(_ selectedNumber: Int, removeUp: Bool) {
        if removeUp {
            numberList = numberList.filter { $0 < selectedNumber }
        } else {
            numberList = numberList.filter { $0 > selectedNumber }
        }
        numberCollectionView.reloadData()
        self.selectedNumber = nil
    }
    
    @IBAction func popViewController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension UpDownGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(for: indexPath, cellType: UpDownGameCollectionViewCell.self)
        let number = numberList[indexPath.item]
        let isSelected = (selectedNumber == number)
        cell.configure(number, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if complete { return }
        
        var shouldReloadIndexes = [IndexPath]()
        
        if let number = selectedNumber {
            if number == numberList[indexPath.item] {
                selectedNumber = nil
            } else if let index = numberList.firstIndex(of: number) {
                let prevIndex = IndexPath(item: index, section: 0)
                shouldReloadIndexes.append(prevIndex)
                selectedNumber = numberList[indexPath.item]
            }
        } else {
            selectedNumber = numberList[indexPath.item]
        }
        
        shouldReloadIndexes.append(indexPath)
        collectionView.reloadItems(at: shouldReloadIndexes)
    }
}
