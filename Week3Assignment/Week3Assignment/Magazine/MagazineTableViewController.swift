//
//  MagazineTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/11/25.
//

import UIKit

class MagazineTableViewController: UITableViewController {

    private let list = MagazineInfo().magazine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func registerCell() {
        let xib = UINib(nibName: MagazineTableViewCell.identifier, bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: MagazineTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MagazineTableViewCell.self)
        
        cell.configure(with: list[indexPath.row])
        return cell
    }
}
