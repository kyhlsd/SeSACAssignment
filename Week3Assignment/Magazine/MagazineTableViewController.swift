//
//  MagazineTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/11/25.
//

import UIKit

class MagazineTableViewController: UITableViewController {

    let list = MagazineInfo().magazine
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "magazineCell", for: indexPath) as? MagazineTableViewCell else { return UITableViewCell() }
        cell.configure(with: list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}
