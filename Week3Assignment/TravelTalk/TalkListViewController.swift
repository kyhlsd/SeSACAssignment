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
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    private let debounce = Debounce<String>()
    
    private let totalList = ChatList.list
    private var searchedList = [ChatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureSearchBar()
        
        updateSearchedList("")
        
        tapGestureRecognizer.cancelsTouchesInView = false
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
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        let deviceWidth = Double(view.bounds.width)
        let cellWidth = deviceWidth - 24 * 2
        layout.itemSize = CGSize(width: cellWidth, height: 48)
        
        talkListCollectionView.collectionViewLayout = layout
    }
    
    private func configureSearchBar() {
        talkListSearchBar.backgroundImage = UIImage()
        talkListSearchBar.delegate = self
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

// MARK: CollectionView
extension TalkListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TalkListCollectionViewCell.self)
        cell.configure(with: searchedList[indexPath.item])
        return cell
    }
}

// MARK: SearchBar
extension TalkListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounce.input(searchText, comparedAgainst: self.talkListSearchBar.text ?? "", timeInterval: 0.5) { [weak self] _ in
            self?.updateSearchedList(searchText)
            self?.talkListCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func updateSearchedList(_ searchText: String?) {
        guard let searchText = searchText else {
            searchedList = totalList
            return
        }
        
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            searchedList = totalList
        } else {
            searchedList = totalList.filter { $0.matches(keyword: trimmed) }
        }
    }
}
