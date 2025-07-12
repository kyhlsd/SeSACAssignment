//
//  TravelTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/12/25.
//

import UIKit

class TravelTableViewController: UITableViewController {
    
    var list = TravelInfo().travel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func heartButtonTapped(_ sender: UIButton) {
        if let like = list[sender.tag].like {
            list[sender.tag].like?.toggle()
            let heartImage = like ? "heart" : "heart.fill"
            sender.setImage(UIImage(systemName: heartImage), for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if list[indexPath.row].ad {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as? AdTableViewCell else { return UITableViewCell() }
            cell.configure(with: list[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as? TravelTableViewCell else { return UITableViewCell() }
            cell.configure(with: list[indexPath.row])
            cell.heartButton.tag = indexPath.row
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if list[indexPath.row].ad {
            return 88
        } else {
            return 132
        }
    }
}
