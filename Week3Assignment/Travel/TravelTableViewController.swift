//
//  TravelTableViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/12/25.
//

import UIKit

class TravelTableViewController: UITableViewController {
    
    private var list = TravelInfo().travel
    private var isOdd = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    private func registerCells() {
        let travelCellXib = UINib(nibName: TravelTableViewCell.identifier, bundle: nil)
        let adCellXib = UINib(nibName: AdTableViewCell.identifier, bundle: nil)
        tableView.register(travelCellXib, forCellReuseIdentifier: TravelTableViewCell.identifier)
        tableView.register(adCellXib, forCellReuseIdentifier: AdTableViewCell.identifier)
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
            
            cell.heartButton.addAction(UIAction { [weak self] _ in
                if let like = self?.list[indexPath.row].like {
                    self?.list[indexPath.row].like?.toggle()
                    cell.configureHeartButton(!like)
                }
            }, for: .touchUpInside)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = list[indexPath.row]
        
        if list[indexPath.row].ad {
            presentAdDetailViewController(selected)
        } else {
            pushTravelDetailViewController(selected)
        }
    }
    
    private func presentAdDetailViewController(_ selectedAd: Travel) {
        let storyboard = UIStoryboard(name: "Travel", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: AdDetailViewController.identifier) { coder -> AdDetailViewController in
                .init(coder: coder, ad: selectedAd) ?? .init(ad: selectedAd)
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.view.tintColor = .black
        
        present(navigationController, animated: true)
    }
    
    private func pushTravelDetailViewController(_ selectedTravel: Travel) {
        let storyboard = UIStoryboard(name: "Travel", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: TravelDetailViewController.identifier) {
            coder -> TravelDetailViewController in
                .init(coder: coder, travel: selectedTravel) ?? .init(travel: selectedTravel)
        }
        
        navigationController?.pushViewController(viewController, animated: true)
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
