//
//  ViewDesignProtocol.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/23/25.
//

import Foundation

protocol ViewDesignProtocol: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}

extension ViewDesignProtocol {
    func configureViewDesign() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
}
