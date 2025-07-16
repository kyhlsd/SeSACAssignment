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
    @IBOutlet var cityTableView: UITableView!
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
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.rowHeight = 140
        
        let xib = UINib(nibName: CityTableViewCell.identifier, bundle: nil)
        cityTableView.register(xib, forCellReuseIdentifier: CityTableViewCell.identifier)
    }
    
    // MARK: SegmentedControl
    @IBAction func citySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        updateSelectedList()
        updateSearchedList(citySearchBar.text)
        cityTableView.reloadData()
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
        updateSearchedList(searchText)
        cityTableView.reloadData()
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

// MARK: TableView
extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CityTableViewCell.self)
        cell.configure(with: searchedList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = searchedList[indexPath.row]
        
        let storyboard = UIStoryboard(name: "City", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: CityDetailViewController.identifier) { coder -> CityDetailViewController in
                .init(coder: coder, city: selected) ?? .init(city: selected)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
