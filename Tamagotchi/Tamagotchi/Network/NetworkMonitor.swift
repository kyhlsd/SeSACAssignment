//
//  NetworkMonitor.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/26/25.
//

import UIKit
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private init() {}
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    private(set) var isConnected = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            if path.status == .satisfied {
                isConnected = true
            } else {
                if isConnected {
                    presentDisconnectedAlert()
                }
                isConnected = false
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func topViewController(base: UIViewController? = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    private func presentDisconnectedAlert() {
        DispatchQueue.main.async { [weak self] in
            let topViewController = self?.topViewController()
            if let topViewController {
                topViewController.showDefaultAlert(title: "네트워크 연결 끊김", message: "네트워크 연결 상태를 확인해주세요.")
            }
        }
    }
}
