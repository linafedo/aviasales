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
            latitude: AirplaneMovementUtility.startLatitude,
            longitude: AirplaneMovementUtility.startLongitude,
            zoom: 1
        )
        return GMSMapView(frame: .zero, camera: camera)
    }()
    
    private var timerAnimation: Timer!
    private var points: [CLLocationCoordinate2D] = []
    private let appearance: Appearence
    
    init(appearance: Appearence = Appearence()) {
        self.appearance = appearance
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: MapViewModel) {
        moveCamera(with: model)
        creatRoute(with: model)
        createMarkers(with: model)
        movePlane(marker: createPlaneMarker(with: model.fromLocation))
    }
}

// MARK: - Appearance

extension GoogleMapView {
    struct Appearence {
        let planeIcon: UIImage? = UIImage(named: "plane")
        let markerGroundAnchor: CGPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        let cameraPadding: CGFloat = 50
        let routStrokeWidth: CGFloat = 2
        let animationDuration: Double = 0.05
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
    
    func moveCamera(with model: MapViewModel) {
        let northEast = CLLocationCoordinate2D(latitude: model.fromLocation.latitude, longitude: model.fromLocation.longitude)
        let southWest = CLLocationCoordinate2D(latitude: model.toLocation.latitude, longitude: model.toLocation.longitude)
        let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let update = GMSCameraUpdate.fit(bounds, withPadding: appearance.cameraPadding)
        mapView.moveCamera(update)
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
        polyline.geodesic = true
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
    
    func createPlaneMarker(with model: MapViewLocationModel) -> GMSMarker {
        let planeIcon = appearance.planeIcon
        
        let position = CLLocationCoordinate2D(
            latitude: model.latitude,
            longitude: model.longitude
        )
        let marker = GMSMarker(position: position)
        marker.groundAnchor = appearance.markerGroundAnchor
        marker.icon = planeIcon
        marker.map = mapView
        marker.zIndex = 1

        return marker
    }
    
    func movePlane(marker: GMSMarker) {
        self.timerAnimation = Timer.scheduledTimer(
            withTimeInterval: appearance.animationDuration,
            repeats: true
        ) { timer in
            guard let point = self.points.first else {
                self.timerAnimation.invalidate()
                return
            }
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.appearance.animationDuration)
            
            marker.rotation = GoogleLocationHealper.bearing(
                fromLocation: marker.position,
                toLocation: point
            )
            marker.position = point

            CATransaction.commit()
            self.points.removeFirst()
        }
    }
}
