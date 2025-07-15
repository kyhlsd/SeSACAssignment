//
//  CityTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

class CityTableViewController: UITableViewController {

    @IBOutlet var citySegmentedControl: UISegmentedControl!
    
    private let list = CityInfo().city
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 140
        registerCell()
    }
    
    private func registerCell() {
        let xib = UINib(nibName: CityTableViewCell.identifier, bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: CityTableViewCell.identifier)
    }
    
    @IBAction func citySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getSelectedList().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CityTableViewCell.self)
        cell.configure(with: getSelectedList()[indexPath.row])
        return cell
    }
    
    private func getSelectedList() -> [City] {
        switch citySegmentedControl.selectedSegmentIndex {
        case 0:
            return list
        case 1:
            return list.filter { $0.domesticTravel }
        case 2:
            return list.filter { !$0.domesticTravel }
        default:
            return []
        }
    }
}
