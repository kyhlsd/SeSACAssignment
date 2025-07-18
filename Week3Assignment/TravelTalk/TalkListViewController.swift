//
//  TalkListViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit

class TalkListViewController: UIViewController {

    @IBOutlet var talkListSearchBar: UISearchBar!
    @IBOutlet var talkListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
