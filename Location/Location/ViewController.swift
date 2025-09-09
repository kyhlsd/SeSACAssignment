//
//  ViewController.swift
//  Location
//
//  Created by 김영훈 on 9/9/25.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {

    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .white
        
        locationManager.delegate = self
        
        printLocation()
    }
    
    private func printLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async { [weak self] in
                    self?.checkLocationAuthorization()
                }
            } else {
                print("disabled")
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            openAppSettings()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default: break
        }
    }
    
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print(location.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        printLocation()
    }
}

