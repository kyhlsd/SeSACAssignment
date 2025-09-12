//
//  TestViewController.swift
//  Example
//
//  Created by 김영훈 on 9/12/25.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(solution([1, 328, 467, 209, 54], [2, 7, 1, 4, 3], 1723))
    }

    func solution(_ diffs:[Int], _ times:[Int], _ limit:Int64) -> Int {
        var level = 2
        let limit = limit - Int64(times[0])
            
        func checkPossiblity(level: Int) -> Bool {
            var limit = limit
                
            for i in 1..<diffs.count {
                let count = diffs[i] - level
                if count > 0 {
                    limit -= Int64((times[i - 1] + times[i]) * count)
                } else {
                    limit -= Int64(times[i])
                }
                if limit < 0 {
                    return false
                }
                    
            }
            return true
        }
            
        while true {
            if checkPossiblity(level: level) {
                break
            } else {
                level += 1
            }
        }
            
        return level
    }
}
