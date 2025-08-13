//
//  ProfileImageViewModel.swift
//  Week7Assignment
//
//  Created by 김영훈 on 8/13/25.
//

import Foundation

final class ProfileImageViewModel {
    
    var images = {
        var list = [String]()
        for i in 0..<12 {
            list.append("person\(i)")
        }
        return list
    }()
}
