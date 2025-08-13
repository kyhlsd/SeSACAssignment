//
//  ProfileImageViewModel.swift
//  Week7Assignment
//
//  Created by 김영훈 on 8/13/25.
//

import Foundation

final class ProfileImageViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        let imageSelectTrigger = Observable(0)
    }
    
    struct Output {
        let selectedImage = Observable("")
    }
    
    var images = {
        var list = [String]()
        for i in 0..<12 {
            list.append("person\(i)")
        }
        return list
    }()
    
    weak var delegate: ProfileImageTransferDelegate?
    
    init() {
        input = Input()
        output = Output()
        
        input.imageSelectTrigger.bind { index in
            self.output.selectedImage.value = self.images[index]
            self.delegate?.setProfileImage(image: self.images[index])
        }
    }
    
    func getIsSelected(index: Int) -> Bool {
        return output.selectedImage.value == images[index]
    }
}
