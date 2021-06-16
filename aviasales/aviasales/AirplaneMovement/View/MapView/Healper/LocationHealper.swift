//
//  LocationHealper.swift
//  aviasales
//
//  Created by Galina Fedorova on 15.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation
import GoogleMaps

class GoogleLocationHealper {
    struct PathData {
        let path: GMSMutablePath
        let points: [CLLocationCoordinate2D]
    }

    static func getRoutePath(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) -> PathData {
        let p1 = CGPoint(x: fromLocation.latitude, y: fromLocation.longitude)
        let p2 = CGPoint(x: toLocation.latitude, y: toLocation.longitude)
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let d = sqrt(dx * dx + dy * dy)
        let a = atan2(dy, dx)
        let cosa = cos(a)
        let sina = sin(a)
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(p1.x), longitude: CLLocationDegrees(p1.y)))
        
        var points: [CLLocationCoordinate2D] = []

        let nPoints = 100
        for t in 0 ... nPoints {
            let tx = CGFloat(t) / CGFloat(nPoints)
            let ty = 0.1 * sin(tx * -2 * CGFloat.pi )

            let x = p1.x + d * (tx * cosa - ty * sina)
            let y = p1.y + d * (tx * sina + ty * cosa)

            points.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(x), longitude: CLLocationDegrees(y)))
            path.add(CLLocationCoordinate2D(latitude: CLLocationDegrees(x), longitude: CLLocationDegrees(y)))
        }
        
        return .init(path: path, points: points)
    }
    
    static func bearing(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) -> Double {
        GMSGeometryHeading(fromLocation, toLocation) - 90
    }
}
