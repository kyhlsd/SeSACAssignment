//
//  MapViewController.swift
//  SeSAC7Week7
//
//  Created by Jack on 8/11/25.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
     
    private let mapView = MKMapView()
     
    private let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapView()
        setupBindings()
//        addSeoulStationAnnotation()
    }
     
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "지도"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "메뉴",
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
         
        view.addSubview(mapView)
         
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        setRegion(viewModel.centerLocation)
    }
    
    private func setupBindings() {
        viewModel.selectedList.bind(isLazy: false) { [weak self] location in
            self?.updateAnnotations()
        }
    }
    
//    private func addSeoulStationAnnotation() {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.5547, longitude: 126.9706)
//        annotation.title = "서울역"
//        annotation.subtitle = "대한민국 서울특별시"
//        mapView.addAnnotation(annotation)
//    }
    
    private func setRegion(_ location: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        viewModel.selectedList.value.forEach { restaurant in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            annotation.title = restaurant.name
            annotation.subtitle = restaurant.address
            mapView.addAnnotation(annotation)
        }
    }
     
    @objc private func rightBarButtonTapped() {
        let alertController = UIAlertController(
            title: "메뉴 선택",
            message: "원하는 옵션을 선택하세요",
            preferredStyle: .actionSheet
        )
        
        viewModel.options.forEach { option in
            let alertAction = UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.viewModel.selectOption(option)
            }
            alertController.addAction(alertAction)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("취소가 선택되었습니다.")
        }
        
        alertController.addAction(cancelAction)
         
        present(alertController, animated: true, completion: nil)
    }
}
 
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        print("어노테이션이 선택되었습니다.")
        print("제목: \((annotation.title ?? "제목 없음") ?? "제목 없음")")
        print("부제목: \((annotation.subtitle ?? "부제목 없음") ?? "부제목 없음")")
        print("좌표: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")
        
        // 선택된 어노테이션으로 지도 중심 이동
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("어노테이션 선택이 해제되었습니다.")
    }
}
