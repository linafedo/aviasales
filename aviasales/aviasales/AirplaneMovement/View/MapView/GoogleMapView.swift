//
//  MapView.swift
//  aviasales
//
//  Created by Galina Fedorova on 12.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

final class GoogleMapView: UIView, MapViewProtocol {
    
    private var mapView: GMSMapView = {
        let camera = GMSCameraPosition(
            latitude: Utility.startLatitude,
            longitude: Utility.startLongitude,
            zoom: 5
        )
        return GMSMapView(frame: .zero, camera: camera)
    }()
    
    private var timerAnimation: Timer?
    private var points: [CLLocationCoordinate2D] = []
    private let appearance: Appearence
    
    private let planeMarker: GMSMarker = GMSMarker()
    
    init(appearance: Appearence = Appearence()) {
        self.appearance = appearance
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: MapViewModel) {
        creatRoute(with: model)
        createMarkers(with: model)
        moveCameraIfNeeded(with: model)
        configurePlaneMarker(with: model.fromLocation)
        let containsLocation = containsLocation(location: model.toLocation)
        movePlane(moveCamera: !containsLocation)
    }
    
    func reset() {
        timerAnimation?.invalidate()
        timerAnimation = nil
    }
}

// MARK: - Appearance

extension GoogleMapView {
    struct Appearence {
        let planeIcon: UIImage? = UIImage(named: "plane")
        let markerGroundAnchor: CGPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        let cameraPadding: CGFloat = 50
        let routStrokeWidth: CGFloat = 2
        let animationDuration: Double = 0.2
        let borderColor: UIColor = UIColor(red: 73, green: 188, blue: 217)
    }
}

// MARK: - setup

private extension GoogleMapView {
    
    func setup() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func moveCameraIfNeeded(with model: MapViewModel) {
        let northEast = CLLocationCoordinate2D(latitude: model.fromLocation.latitude, longitude: model.fromLocation.longitude)
        let southWest = CLLocationCoordinate2D(latitude: model.toLocation.latitude, longitude: model.toLocation.longitude)

        if needMoveCamera(fromLocation: northEast, toLocation: southWest) {
            let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            let update = GMSCameraUpdate.fit(bounds, withPadding: appearance.cameraPadding)
            mapView.moveCamera(update)
        }
    }
    
    func creatRoute(with model: MapViewModel) {
        let pathData = GoogleLocationHealper.getRoutePath(
            fromLocation:
                .init(
                    latitude: model.fromLocation.latitude,
                    longitude: model.fromLocation.longitude
                ),
            toLocation: .init(
                latitude: model.toLocation.latitude,
                longitude: model.toLocation.longitude
            )
        )
        points = pathData.points
        let polyline = GMSPolyline(path: pathData.path)
        
        let styles: [GMSStrokeStyle] = [.solidColor(appearance.borderColor), .solidColor(.clear)]
        let scale = 1.0 / mapView.projection.points(forMeters: 1, at: mapView.camera.target)
        let solidLine = NSNumber(value: 5 * Float(scale))
        let gap = NSNumber(value: 3 * Float(scale))
        
        polyline.spans = GMSStyleSpans(pathData.path, styles, [solidLine, gap], GMSLengthKind.rhumb)
        polyline.strokeWidth = appearance.routStrokeWidth
        polyline.map = mapView
    }
    
    func createMarkers(with model: MapViewModel) {
        let fromMarker = GMSMarker()
        fromMarker.position = CLLocationCoordinate2D(
            latitude: model.fromLocation.latitude,
            longitude: model.fromLocation.longitude
        )
        fromMarker.iconView = CityLabelView(title: model.fromLocation.iata)
        fromMarker.groundAnchor = appearance.markerGroundAnchor
        fromMarker.map = mapView
        
        let toMarker = GMSMarker()
        toMarker.position = CLLocationCoordinate2D(
            latitude: model.toLocation.latitude,
            longitude: model.toLocation.longitude
        )
        toMarker.iconView = CityLabelView(title: model.toLocation.iata)
        toMarker.groundAnchor = appearance.markerGroundAnchor
        toMarker.map = mapView
    }
    
    func configurePlaneMarker(with model: MapViewLocationModel) {
        let planeIcon = appearance.planeIcon
        
        let position = CLLocationCoordinate2D(
            latitude: model.latitude,
            longitude: model.longitude
        )
        planeMarker.position = position
        if let point = points[safe: 1] {
            setPlaneRotatin(toLocation: point)
        }
        planeMarker.groundAnchor = appearance.markerGroundAnchor
        planeMarker.icon = planeIcon
        planeMarker.map = mapView
        planeMarker.zIndex = 1
    }
    
    func movePlane(moveCamera: Bool) {
        timerAnimation = Timer.scheduledTimer(
            withTimeInterval: appearance.animationDuration,
            repeats: true
        ) { [weak self] timer in
            guard let point = self?.points.first else {
                self?.timerAnimation?.invalidate()
                return
            }
            if let point = self?.points[safe: 2] {
                self?.setPlaneRotatin(toLocation: point)
            }
            self?.planeMarker.position = point

            if moveCamera {
                self?.mapView.animate(toLocation: point)
            }
            self?.points.removeFirst()
        }
    }
    
    func setPlaneRotatin(toLocation: CLLocationCoordinate2D) {
        planeMarker.rotation = GoogleLocationHealper.bearing(
            fromLocation: planeMarker.position,
            toLocation: toLocation
        )
    }
    
    func containsLocation(location: MapViewLocationModel) -> Bool {
        let region = self.mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: region)
        
        let location: CLLocationCoordinate2D = .init(
            latitude: location.latitude,
            longitude: location.longitude
        )
        return bounds.contains(location)
    }
    
    func needMoveCamera(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) -> Bool {
        let first = mapView.projection.point(for: fromLocation).x
        let second = mapView.projection.point(for: toLocation).x
        
        return abs(first.distance(to: second)) < frame.width
    }
}
