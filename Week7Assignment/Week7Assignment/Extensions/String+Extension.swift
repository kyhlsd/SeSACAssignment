//
//  String+Extension.swift
//  Week4Assignment
//
//  Created by 김영훈 on 7/29/25.
//

import Foundation

extension String {
    var htmlDecodedString: String {
        guard let data = self.data(using: .utf8) else { return "" }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return "" }
        
        return attributedString.string
    }
}
