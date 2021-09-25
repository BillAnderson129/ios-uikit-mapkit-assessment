//
//  FeatureCollection.swift
//  AcmeMap
//
//  Created by Bill Anderson on 9/24/21.
//

import Foundation
import MapKit

struct FeatureCollection: Decodable {
    let features: [GeoFeature]
    let type: String
}

struct GeoFeature: Decodable {
    let id: String
    let type: String
    let properties: [String: String]
    let geometry: Geometry
    var name: String { properties["name"] ?? "Unknown" }
    
    func pointAnnotation() -> AcmePointAnnotation {
        let annotation = AcmePointAnnotation()
        annotation.coordinate = .init(
            latitude: geometry.latitude,
            longitude: geometry.longitude)
        annotation.title = properties["name"]
        annotation.id = id
        return annotation
    }
    
    func distance(to toFeature: GeoFeature) -> Double {
        
        let degreesToRadians: Double = .pi / 180
        let earthRadius: Double = 3958.8 // Miles, tho earth isn't a sphere so...
        
        let fromLat: Double  = geometry.latitude
        let fromLong: Double = geometry.longitude
        let toLat: Double  = toFeature.geometry.latitude
        let toLong: Double = toFeature.geometry.longitude
        
        let latitudeArc  = (fromLat - toLat) * degreesToRadians
        let longitudeArc = (fromLong - toLong) * degreesToRadians
        let latitudeH  = pow(sin(latitudeArc * 0.5), 2)
        let longitudeH = pow(sin(longitudeArc * 0.5), 2)
        let result = cos(fromLat * degreesToRadians) * cos(toLat * degreesToRadians)
        return (earthRadius * 2.0) * asin(sqrt(latitudeH + (result * longitudeH)))
    }
}

struct Geometry: Decodable {
    let type: String
    let coordinates: [Double]  // Longitude, Latitude
    var latitude: Double {
        coordinates[1]
    }
    var longitude: Double {
        coordinates[0]
    }
}

class AcmePointAnnotation: MKPointAnnotation {
    var id: String = ""
}
