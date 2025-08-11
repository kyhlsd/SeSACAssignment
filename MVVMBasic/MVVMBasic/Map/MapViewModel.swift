//
//  MapViewModel.swift
//  MVVMBasic
//
//  Created by 김영훈 on 8/11/25.
//

import Foundation

final class MapViewModel {
    private let totalList = RestaurantList.restaurantArray
    private(set) var selectedList = Observable([Restaurant]())
    private(set) var centerRegion = Observable(CenterRegion.seoulStation)
    
    let options = ["한식", "양식", "분식", "전체보기"]
    private(set) var selectedOption = Observable(3)
    
    init() {
        selectedList.bind { _ in
            self.updateCenterRegion()
        }
        
        selectedOption.bind { index in
            if index == self.options.count - 1 {
                self.selectedList.value = self.totalList
            } else {
                self.selectedList.value = self.totalList.filter { $0.category == self.options[index] }
            }
        }
    }
    
    private func updateCenterRegion() {
        var totalLatitude = 0.0
        var totalLongitude = 0.0
        selectedList.value.forEach { restaurant in
            totalLatitude += restaurant.latitude
            totalLongitude += restaurant.longitude
        }
        let averageLatitude = totalLatitude / Double(selectedList.value.count)
        let averageLongitude = totalLongitude / Double(selectedList.value.count)
        
        centerRegion.value = CenterRegion(latitude: averageLatitude, longitude: averageLongitude, latitudinalMeters: 2000, longitudinalMeters: 2000)
    }
    
    func selectOption(_ option: String) {
        if let index = options.firstIndex(of: option) {
            selectedOption.value = index
        }
    }
}
