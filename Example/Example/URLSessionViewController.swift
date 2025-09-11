//
//  URLSessionViewController.swift
//  Example
//
//  Created by 김영훈 on 9/11/25.
//

import UIKit

enum Nasa: String, CaseIterable {
    
    static let baseURL = "https://apod.nasa.gov/apod/image/"
    
    case one = "2308/sombrero_spitzer_3000.jpg"
    case two = "2212/NGC1365-CDK24-CDK17.jpg"
    case three = "2307/M64Hubble.jpg"
    case four = "2306/BeyondEarth_Unknown_3000.jpg"
    case five = "2307/NGC6559_Block_1311.jpg"
    case six = "2304/OlympusMons_MarsExpress_6000.jpg"
    case seven = "2305/pia23122c-16.jpg"
    case eight = "2308/SunMonster_Wenz_960.jpg"
    case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
    
    static var photo: URL {
        return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
    }
}

class URLSessionViewController: UIViewController {

    lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    var total = 0.0
    var buffer = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        callRequest()
    }

    func callRequest() {
        session.dataTask(with: Nasa.photo).resume()
    }

}

extension URLSessionViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            completionHandler(.allow)
            if let contentLengthData = response.value(forHTTPHeaderField: "Content-Length"), let contentLength = Double(contentLengthData) {
                total = contentLength
            }
        } else {
            completionHandler(.cancel)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)
        if total == 0.0 { return }
        let result = Double(buffer.count) / total
        navigationItem.title = "\(result * 100) %"
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error {
            print(error.localizedDescription)
            return
        }
        
        print("done")
    }
}
