//
//  TalkListViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit

class TalkListViewController: UIViewController {

    @IBOutlet var talkListSearchBar: UISearchBar!
    @IBOutlet var talkListCollectionView: UICollectionView!
    
    let talkList = ChatList.list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        talkListCollectionView.layer.addBorder([.top], color: .lightGray, width: 0.5)
    }
    
    private func configureCollectionView() {
        let xib = UINib(nibName: TalkListCollectionViewCell.identifier, bundle: nil)
        talkListCollectionView.register(xib, forCellWithReuseIdentifier: TalkListCollectionViewCell.identifier)
        
        talkListCollectionView.delegate = self
        talkListCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        let deviceWidth = Double(view.bounds.width)
        let cellWidth = deviceWidth - 24 * 2
        layout.itemSize = CGSize(width: cellWidth, height: 48)
        
        talkListCollectionView.collectionViewLayout = layout
    }
    
    private func configureSearchBar() {
        talkListSearchBar.backgroundImage = UIImage()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension TalkListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TalkListCollectionViewCell.self)
        cell.configure(with: talkList[indexPath.item])
        return cell
    }
}
