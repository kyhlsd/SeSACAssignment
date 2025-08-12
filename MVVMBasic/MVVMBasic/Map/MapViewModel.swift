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
    private(set) var centerLocation = Location.sesac
    
    let options = ["한식", "양식", "분식", "전체보기"]
    private(set) var selectedOption = Observable(3)
    
    init() {        
        selectedOption.bind(isLazy: false) { index in
            if index == self.options.count - 1 {
                self.selectedList.value = self.totalList
            } else {
                self.selectedList.value = self.totalList.filter { $0.category == self.options[index] }
            }
        }
    }
    
    func selectOption(_ option: String) {
        if let index = options.firstIndex(of: option) {
            selectedOption.value = index
        }
    }
}
