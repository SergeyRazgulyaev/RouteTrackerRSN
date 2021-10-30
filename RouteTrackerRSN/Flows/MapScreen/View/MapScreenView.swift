//
//  MapScreenView.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 07.04.2021.
//

import UIKit
import GoogleMaps

class MapScreenView: UIView, UIComponentsMakeable {
    private(set) lazy var mapView: GMSMapView = {
        makeMapView()
    }()
    
    private(set) lazy var showHomelandButton: UIButton = {
        makeButton(title: "",
                   font: .systemFont(ofSize: 17),
                   backgroundColor: .white,
                   cornerRadius: 20.0)
    }()
    
    private(set) lazy var showCurrentLocationButton: UIButton = {
        makeButton(title: "",
                   font: .systemFont(ofSize: 17),
                   backgroundColor: .white,
                   cornerRadius: 20.0)
    }()
    
    private(set) lazy var startTrackingLocationButton: UIButton = {
        makeButton(title: "",
                   font: .systemFont(ofSize: 17),
                   backgroundColor: .white,
                   cornerRadius: 20.0)
    }()
    
    private(set) lazy var showPreviousPathButton: UIButton = {
        makeButton(title: "",
                   font: .systemFont(ofSize: 17),
                   backgroundColor: .white,
                   cornerRadius: 20.0)
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        showHomelandButton.setBackgroundImage(UIImage(systemName: "house.circle"), for: .normal)
        showHomelandButton.setBackgroundImage(UIImage(systemName: "house.circle.fill"), for: .highlighted)
        
        showCurrentLocationButton.setBackgroundImage(UIImage(systemName: "location.circle"), for: .normal)
        showCurrentLocationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .highlighted)
        
        startTrackingLocationButton.setBackgroundImage(UIImage(systemName: "car.circle"), for: .normal)
        startTrackingLocationButton.tag = 0
        
        showPreviousPathButton.setBackgroundImage(UIImage(systemName: "arrow.uturn.backward.circle"), for: .normal)
        showPreviousPathButton.setBackgroundImage(UIImage(systemName: "arrow.uturn.backward.circle.fill"), for: .highlighted)
        
        self.addSubview(mapView)
        mapView.addSubview(showHomelandButton)
        mapView.addSubview(showCurrentLocationButton)
        mapView.addSubview(startTrackingLocationButton)
        mapView.addSubview(showPreviousPathButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            
            showHomelandButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 30.0),
            showHomelandButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30.0),
            showHomelandButton.heightAnchor.constraint(equalToConstant: 40.0),
            showHomelandButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            showCurrentLocationButton.topAnchor.constraint(equalTo: showHomelandButton.bottomAnchor, constant: 10.0),
            showCurrentLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30.0),
            showCurrentLocationButton.heightAnchor.constraint(equalToConstant: 40.0),
            showCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            startTrackingLocationButton.topAnchor.constraint(equalTo: showCurrentLocationButton.bottomAnchor, constant: 10.0),
            startTrackingLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30.0),
            startTrackingLocationButton.heightAnchor.constraint(equalToConstant: 40.0),
            startTrackingLocationButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            showPreviousPathButton.topAnchor.constraint(equalTo: startTrackingLocationButton.bottomAnchor, constant: 10.0),
            showPreviousPathButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30.0),
            showPreviousPathButton.heightAnchor.constraint(equalToConstant: 40.0),
            showPreviousPathButton.widthAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
