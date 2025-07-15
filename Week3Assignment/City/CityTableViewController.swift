//
//  CityTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

class CityTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var citySegmentedControl: UISegmentedControl!
    @IBOutlet var citySearchBar: UISearchBar!
    
    private let list = CityInfo().city
    private var selectedList = [City]()
    private var searchedList = [City]()
    private var resultList = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 140
        registerCell()
        
        citySearchBar.delegate = self
        citySearchBar.backgroundImage = UIImage()
        
        updateSelectedList()
        updateSearchedList("")
    }
    
    private func registerCell() {
        let xib = UINib(nibName: CityTableViewCell.identifier, bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: CityTableViewCell.identifier)
    }
    
    private func updateResultList() {
        
    }
    
    // MARK: SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchedList(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func updateSearchedList(_ searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            searchedList = list
        } else {
            searchedList = list.filter { City.matches(target: $0, keyword: trimmed) }
        }
    }
    
    // MARK: SegmentedControl
    @IBAction func citySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        view.endEditing(true)
        updateSelectedList()
        tableView.reloadData()
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
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CityTableViewCell.self)
        cell.configure(with: resultList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        print(resultList[indexPath.row])
    }
}
