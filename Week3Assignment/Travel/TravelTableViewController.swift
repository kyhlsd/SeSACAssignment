//
//  TravelTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/12/25.
//

import UIKit

class TravelTableViewController: UITableViewController {
    
    var list = TravelInfo().travel
    var isOdd = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    private func registerCells() {
        let travelCellXib = UINib(nibName: TravelTableViewCell.reuseIdentifier, bundle: nil)
        let adCellXib = UINib(nibName: AdTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(travelCellXib, forCellReuseIdentifier: TravelTableViewCell.reuseIdentifier)
        tableView.register(adCellXib, forCellReuseIdentifier: AdTableViewCell.reuseIdentifier)
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
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AdTableViewCell.self)
            
            cell.configure(with: list[indexPath.row], isOddAd: isOddTag(cell))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TravelTableViewCell.self)
            
            cell.configure(with: list[indexPath.row])
            cell.heartButton.tag = indexPath.row
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if list[indexPath.row].ad {
            return 88
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // 번갈아 광고 색상 다르게 표기, 재사용 시에도 유지되게 하기 위함
    private func isOddTag(_ cell: AdTableViewCell) -> Bool {
        switch cell.tag {
        case 0:
            cell.tag = isOdd ? 1 : 2
            isOdd.toggle()
            return !isOdd
        case 1:
            return true
        case 2:
            return false
        default:
            print("Wrong Tag")
            return false
        }
    }
}
