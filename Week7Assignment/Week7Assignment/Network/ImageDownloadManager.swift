//
//  ImageDownloadManager.swift
//  Week4Assignment
//
//  Created by 김영훈 on 8/13/25.
//

import Foundation
import Kingfisher

final class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    private init() {}
    
    func download(with url: String) {
        if let url = URL(string: url) {
            ImageDownloader.default.downloadImage(with: url)
        }
    }
    
    func cancel(with url: String) {
        if let url = URL(string: url) {
            ImageDownloader.default.cancel(url: url)
        }
    }
    
    func remove(forKey: String) {
        ImageCache.default.removeImage(forKey: forKey)
    }
}
