//
//  ChatListViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit

class ChatListViewController: UIViewController {

    @IBOutlet var chatListSearchBar: UISearchBar!
    @IBOutlet var chatListCollectionView: UICollectionView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    private let debounce = Debounce<String>()
    
    private var totalList = [ChatRoom]()
    private var searchedList = [ChatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureSearchBar()
        
        tapGestureRecognizer.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalList = ChatList.list
        updateSearchedList(chatListSearchBar.text)
        chatListCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        chatListCollectionView.layer.addBorder([.top], color: .lightGray, width: 0.5)
    }
    
    private func configureCollectionView() {
        let xib = UINib(nibName: ChatListCollectionViewCell.identifier, bundle: nil)
        chatListCollectionView.register(xib, forCellWithReuseIdentifier: ChatListCollectionViewCell.identifier)
        
        chatListCollectionView.delegate = self
        chatListCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        let deviceWidth = Double(view.bounds.width)
        let cellWidth = deviceWidth - 24 * 2
        layout.itemSize = CGSize(width: cellWidth, height: 48)
        
        chatListCollectionView.collectionViewLayout = layout
    }
    
    private func configureSearchBar() {
        chatListSearchBar.backgroundImage = UIImage()
        chatListSearchBar.delegate = self
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

// MARK: CollectionView
extension ChatListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ChatListCollectionViewCell.self)
        cell.configure(with: searchedList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TravelTalk", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType: ChatViewController.self)
        viewController.chatRoom = searchedList[indexPath.item]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: SearchBar
extension ChatListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounce.input(searchText, comparedAgainst: self.chatListSearchBar.text ?? "", timeInterval: 0.5) { [weak self] _ in
            self?.updateSearchedList(searchText)
            self?.chatListCollectionView.reloadData()
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
