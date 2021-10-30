//
//  MapScreenViewController.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 02.04.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

class MapScreenViewController: UIViewController {
    // MARK: - UI components
    private lazy var mapScreenView: MapScreenView = {
        return MapScreenView()
    }()
    
    //MARK: - Properties
    private let userLogin: String
    private let locationManager = LocationManager.instance
    private var backgroundTask: UIBackgroundTaskIdentifier?
    
    private let homelandCoordinate = CLLocationCoordinate2D(latitude: 63.570756, longitude: 53.685410)
    private var currentCoordinate = CLLocationCoordinate2D()
    private let initialMarker = GMSMarker()
    private var onMapMarker = GMSMarker()
    
    private var camera = GMSCameraPosition()
    
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private var selfieImage: UIImage?
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    //MARK: - Properties for Interaction with Database
    private var routePathsNotificationToken: NotificationToken?
    private let realmManager: RealmManager
    
    private var routePathsFromRealm: Results<RoutePaths>? {
        let routePathsFromRealm: Results<RoutePaths>? = realmManager.getObjects()
        return routePathsFromRealm
    }
    
    // MARK: - Init
    init(realmManager: RealmManager, userLogin: String) {
        self.realmManager = realmManager
        self.userLogin = userLogin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteRoutePathsFromRealm()
        configureViewController()
        configureLocationManager()
        configureBackgroundTask()
        configureMap()
        configureInitialMarker()
        configureButtons()
        configureSelfieImage()
        makeSelfieButtonOnRightBarButtonItem()
        createNotification()
    }
    
    override func loadView() {
        self.view = mapScreenView
    }
    
    //MARK: - Deinit routePathsNotificationToken
    deinit {
        routePathsNotificationToken?.invalidate()
    }
    
    //MARK: - Configuration methods
    func configureViewController() {
        self.title = "Map"
        self.navigationController?.navigationBar.barTintColor = .rsnLightBlueColor
        self.navigationController?.navigationBar.prefersLargeTitles = false;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let self = self else { return }
                guard let location = location else { return }
                self.routePath?.add(location.coordinate)
                self.route?.path = self.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self.addOnMapMarker(currentCoordinate: location.coordinate)
                self.addOnMapRoute(currentCoordinate: location.coordinate)
                self.currentCoordinate = location.coordinate
                self.mapScreenView.mapView.animate(to: position)
            }
    }
    
    func configureBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = .invalid
        }
    }
    
    func configureMap() {
        mapScreenView.mapView.delegate = self
    }
    
    func configureInitialMarker() {
        let initialMarkerImage = UIImage(systemName: "house.fill")
        let initialMarkerView = UIImageView(image: initialMarkerImage)
        initialMarkerView.tintColor = .systemRed
        initialMarker.iconView = initialMarkerView
        initialMarker.position = homelandCoordinate
        initialMarker.title = "Homeland"
        initialMarker.map = mapScreenView.mapView
    }
    
    //MARK: - Methods
    func addOnMapMarker(currentCoordinate: CLLocationCoordinate2D) {
        let frame = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        let onMapMarkerImageView = UIImageView(frame: frame)
        onMapMarkerImageView.tintColor = .systemGreen
        if selfieImage != nil {
            onMapMarkerImageView.image = selfieImage
            onMapMarkerImageView.layer.cornerRadius = onMapMarkerImageView.bounds.width / 2
            onMapMarkerImageView.clipsToBounds = true
        } else {
            onMapMarkerImageView.image = UIImage(systemName: "mappin")
        }
        onMapMarker.iconView = onMapMarkerImageView
        onMapMarker.position = currentCoordinate
        onMapMarker.map = mapScreenView.mapView
    }
    
    func addOnMapRoute(currentCoordinate: CLLocationCoordinate2D) {
        routePath?.add(currentCoordinate)
        route?.strokeColor = .systemGreen
        route?.path = routePath
    }
    
    //MARK: - Buttons
    func configureButtons() {
        configureShowHomelandButton()
        configureShowCurrentLocationButton()
        configureStartTrackingLocationButton()
        configureShowPreviousPathButton()
    }
    
    func configureShowHomelandButton() {
        mapScreenView.showHomelandButton.addTarget(self, action: #selector(tapShowHomelandButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapShowHomelandButton(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        camera = GMSCameraPosition.camera(withTarget: homelandCoordinate, zoom: 12)
        mapScreenView.mapView.camera = camera
        mapScreenView.mapView.animate(to: mapScreenView.mapView.camera)
    }
    
    func configureShowCurrentLocationButton() {
        mapScreenView.showCurrentLocationButton.addTarget(self, action: #selector(tapShowCurrentLocationButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapShowCurrentLocationButton(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        if mapScreenView.startTrackingLocationButton.tag == 1 {
            setStartTrackingLocationButtonToStatusUntapped()
            writeRoutePathsToRealm()
        }
        route?.map = nil
        locationManager.requestLocation()
        addOnMapMarker(currentCoordinate: currentCoordinate)
        camera = GMSCameraPosition.camera(withTarget: currentCoordinate, zoom: 17)
        mapScreenView.mapView.camera = camera
        mapScreenView.mapView.animate(to: mapScreenView.mapView.camera)
    }
    
    func configureStartTrackingLocationButton() {
        mapScreenView.startTrackingLocationButton.addTarget(self, action: #selector(tapStartTrackingLocationButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapStartTrackingLocationButton(_ sender: UIButton) {
        if mapScreenView.startTrackingLocationButton.tag == 0 {
            // Run tracking
            setStartTrackingLocationButtonToStatusTapped()
            mapScreenView.mapView.animate(toZoom: 17)
            route?.map = nil
            route = GMSPolyline()
            routePath = GMSMutablePath()
            route?.map = mapScreenView.mapView
            locationManager.startUpdatingLocation()
        } else if mapScreenView.startTrackingLocationButton.tag == 1 {
            // Stop tracking
            locationManager.stopUpdatingLocation()
            setStartTrackingLocationButtonToStatusUntapped()
            writeRoutePathsToRealm()
        }
    }
    
    func setStartTrackingLocationButtonToStatusUntapped() {
        mapScreenView.startTrackingLocationButton.tag = 0
        mapScreenView.startTrackingLocationButton.setBackgroundImage(UIImage(systemName: "car.circle"), for: .normal)
    }
    
    func setStartTrackingLocationButtonToStatusTapped() {
        mapScreenView.startTrackingLocationButton.tag = 1
        mapScreenView.startTrackingLocationButton.setBackgroundImage(UIImage(systemName: "car.circle.fill"), for: .normal)
    }
    
    func configureShowPreviousPathButton() {
        mapScreenView.showPreviousPathButton.addTarget(self, action: #selector(tapShowPreviousPathButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapShowPreviousPathButton(_ sender: UIButton) {
        if mapScreenView.startTrackingLocationButton.tag == 1 {
            if routePathsFromRealm?.first?.previousPath == nil {
                showAlert(title: "Attention" , message: "There is no previous route yet", handler: nil, completion: nil)
            } else {
                showStopTrackingAlert()
            }
        } else if mapScreenView.startTrackingLocationButton.tag == 0 {
            showPreviousPath()
        }
    }
    
    func showPreviousPath() {
        if routePathsFromRealm?.first?.previousPath == nil || routePathsFromRealm?.first?.previousPath == "" {
            showAlert(title: "Attention" , message: "There is no previous route yet", handler: nil, completion: nil)
        } else {
            locationManager.stopUpdatingLocation()
            setStartTrackingLocationButtonToStatusUntapped()
            route?.map = nil
            route = GMSPolyline()
            routePath = GMSMutablePath(fromEncodedPath: routePathsFromRealm?.first?.previousPath ?? "")
            route?.path = routePath
            route?.strokeColor = .systemGreen
            route?.map = mapScreenView.mapView
            let pathBounds = GMSCoordinateBounds(path: routePath ?? GMSMutablePath())
            let camera = mapScreenView.mapView.camera(for: pathBounds, insets: UIEdgeInsets())!
            mapScreenView.mapView.camera = camera
            mapScreenView.mapView.animate(to: mapScreenView.mapView.camera)
        }
    }
    
    func configureSelfieImage() {
        selfieImage = getSelfieImage()
    }
    
    func makeSelfieButtonOnRightBarButtonItem() {
        let selfieButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera.fill"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(tapSelfieButton(_:)))
        self.navigationItem.rightBarButtonItem = selfieButtonItem
    }
    
    @objc func tapSelfieButton(_ sender: Any?) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}

extension MapScreenViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
}

//MARK: - Interaction with Realm Database
extension MapScreenViewController {
    func createNotification() {
        routePathsNotificationToken = routePathsFromRealm?.observe { [weak self] change in
            switch change {
            case let .initial(routePaths):
                print("Initialized \(routePaths.count)")
                
            case let .update(routePaths, deletions: deletions, insertions: insertions, modifications: modifications):
                print("""
                    New count: \(routePaths.count)
                    Deletions: \(deletions)
                    Insertions: \(insertions)
                    Modifications: \(modifications)
                    """)
                
            case let .error(error):
                self?.showAlert(title: "Error in Realm Data Base", message: error.localizedDescription)
            }
        }
    }
    
    func writeRoutePathsToRealm() {
        let generatedNewRoutPaths = generateNewRoutePaths()
        deleteRoutePathsFromRealm()
        try? realmManager.add(object: generatedNewRoutPaths)
    }
    
    func deleteRoutePathsFromRealm() {
        try? realmManager.deleteAllRoutePaths()
    }
    
    func generateNewRoutePaths() -> RoutePaths {
        let generatedNewRoutePaths = RoutePaths()
        guard let currentPath = routePath?.encodedPath() else {
            return RoutePaths()
        }
        generatedNewRoutePaths.currentPath = currentPath
        generatedNewRoutePaths.previousPath = routePathsFromRealm?.first?.currentPath ?? ""
        return generatedNewRoutePaths
    }
}

//MARK: - Camera interaction
extension MapScreenViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let receivedSelfieImage = extractImage(from: info) {
            if selfieImage != nil {
                deleteOldSelfieImage()
            }
            saveSelfieImage(image: receivedSelfieImage)
            selfieImage = getSelfieImage()
            addOnMapMarker(currentCoordinate: currentCoordinate)
        }
        picker.dismiss(animated: true)
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return UIImage(systemName: "nosign")
        }
    }
    
    private func saveSelfieImage(image: UIImage) {
        guard let selfieImagePath = documentsDirectory?.appendingPathComponent("selfieImage.png").path else { return }
        let data = image.pngData()
        FileManager.default.createFile(atPath: selfieImagePath, contents: data, attributes: nil)
    }
    
    private func getSelfieImage() -> UIImage {
        guard let withoutSelfieImage = UIImage(systemName: "mappin") else {
            return UIImage()
        }
        guard let selfieImagePath = documentsDirectory?.appendingPathComponent("selfieImage.png").path else { return withoutSelfieImage }
        return UIImage(contentsOfFile: selfieImagePath) ?? withoutSelfieImage
    }
    
    private func deleteOldSelfieImage() {
        guard let deletingSelfieImagePath = documentsDirectory?.appendingPathComponent("selfieImage.png").path else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: deletingSelfieImagePath) }
        catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Alerts
extension MapScreenViewController {
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   handler: ((UIAlertAction) -> ())? = nil,
                   completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
    
    func showStopTrackingAlert() {
        let alertController = UIAlertController(title: "Attention", message: "Route tracking is in progress.\nDo you want to stop tracking?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
            print("stop tracking")
            self.writeRoutePathsToRealm()
            self.showPreviousPath()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
