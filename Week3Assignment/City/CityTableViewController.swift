//
//  CityTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/15/25.
//

import UIKit

class CityTableViewController: UITableViewController {

    @IBOutlet var citySegmentedControl: UISegmentedControl!
    
    let list = CityInfo().city
    
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
        print(sender.selectedSegmentIndex)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CityTableViewCell.self)
        cell.configure(with: list[indexPath.row])
        return cell
    }
}
