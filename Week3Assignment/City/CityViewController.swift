//
//  CityTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet var citySegmentedControl: UISegmentedControl!
    @IBOutlet var citySearchBar: UISearchBar!
    @IBOutlet var cityCollectionView: UICollectionView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    // list - segmentedControl - searchBar 순으로 filter
    private let list = CityInfo().city
    private var selectedList = [City]()
    private var searchedList = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSelectedList()
        updateSearchedList("")
        
        configureTableView()
        
        citySearchBar.delegate = self
        citySearchBar.backgroundImage = UIImage()
        
        tapGestureRecognizer.cancelsTouchesInView = false
    }
    
    private func configureTableView() {
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let deviceWidth = Double(view.bounds.width)
        let countsInRow: Double = 2
        let cellWidth = (deviceWidth - (24 * 2) - (24 * (countsInRow - 1))) / countsInRow
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 74) // + 66 이상 보장
        cityCollectionView.collectionViewLayout = layout
        
        let xib = UINib(nibName: CityCollectionViewCell.identifier, bundle: nil)
        cityCollectionView.register(xib, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
    }
    
    // MARK: SegmentedControl
    @IBAction func citySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        updateSelectedList()
        updateSearchedList(citySearchBar.text)
        cityCollectionView.reloadData()
    }
    
    private func updateSelectedList() {
        switch citySegmentedControl.selectedSegmentIndex {
        case 0:
            return selectedList = list
        case 1:
            return selectedList = list.filter { $0.domesticTravel }
        case 2:
            return selectedList = list.filter { !$0.domesticTravel }
        default:
            return selectedList = []
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: SearchBar
extension CityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Debounce<String>.input(searchText, comparedAgainst: self.citySearchBar.text ?? "", timeInterval: 0.5) { [weak self] _ in
            self?.updateSearchedList(searchText)
            self?.cityCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func updateSearchedList(_ searchText: String?) {
        guard let searchText = searchText else {
            searchedList = selectedList
            return
        }
        
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            searchedList = selectedList
        } else {
            searchedList = selectedList.filter { $0.matches(keyword: trimmed) }
        }
    }
}

// MARK: CollectionView
extension CityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CityCollectionViewCell.self)
        let trimmed = citySearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.configure(with: searchedList[indexPath.row], searchText: trimmed)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = searchedList[indexPath.item]
        
        let storyboard = UIStoryboard(name: "City", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: CityDetailViewController.identifier) { coder -> CityDetailViewController in
                .init(coder: coder, city: selected) ?? .init(city: selected)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
