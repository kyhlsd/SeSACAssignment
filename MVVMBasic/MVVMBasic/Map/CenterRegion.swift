//
//  CenterRegion.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/12/25.
//

import Foundation

struct CenterRegion {
    let latitude: Double
    let longitude: Double
    let latitudinalMeters: Double
    let longitudinalMeters: Double
    
    static let seoulStation = CenterRegion(latitude: 37.5547, longitude: 126.9706, latitudinalMeters: 2000, longitudinalMeters: 2000)
}
