//
//  AcmeMocks.swift
//  AcmeMapTests
//
//  Created by Bill Anderson on 9/26/21.
//

import XCTest
import Foundation
@testable import AcmeMap
import MapKit

class MockMainView: MainViewProtocol {
    
    var errorMessage: String?
    var detailInfoArray = [DetailInfo]()
    var acmeAnnotations = [AcmePointAnnotation]()
    var expecation: XCTestExpectation?
    
    func addFeatureAnnotations(annotations: [AcmePointAnnotation]) {
        acmeAnnotations = annotations
        expecation?.fulfill()
    }
    
    func presentDetailView(with detailInfo: DetailInfo) {
        detailInfoArray.append(detailInfo)
    }
    
    func showNetworkAlert(message: String) {
        errorMessage = message
        expecation?.fulfill()
    }
}

class MockDetailView: DetailViewProtocol {
    
    var cellModels = [CellModel]()
    
    func updateView(with models: [CellModel]) {
        cellModels = models
    }
}

class MockServiceManager: ServiceManagerProtocol {
    
    enum DownloadResultType {
        case good
        case empty
        case error
    }
    
    var resultType: DownloadResultType = .good
    let sampleGeoFeatures: [GeoFeature] = {
        
        let geoAlpha = GeoFeature(
            id: "1",
            type: "Feature",
            properties: ["name": "Alpha"],
            geometry: Geometry(type: "Point", coordinates: [149.98458041136354, -34.98520411042454])
        )
        
        let geoBravo = GeoFeature(
            id: "2",
            type: "Feature",
            properties: ["name": "Bravo"],
            geometry: Geometry(type: "Point", coordinates: [-67.09898354941409, 45.042099781891125])
        )
        
        let geoCharlie = GeoFeature(
            id: "3",
            type: "Feature",
            properties: ["name": "Charlie"],
            geometry: Geometry(type: "Point", coordinates: [-115.42362, -57.98449])
        )
        
        let geoDelta = GeoFeature(
            id: "4",
            type: "Feature",
            properties: ["name": "Delta"],
            geometry: Geometry(type: "Point", coordinates: [81.9140625, 56.75272287205736])
        )
        
        return [geoAlpha, geoBravo, geoCharlie, geoDelta]
    }()
    
    func downloadGeoJSON(completion: @escaping ([GeoFeature]?, String?) -> ()) {
        
        switch resultType {
        case .good:
            completion(sampleGeoFeatures, nil)
        case .empty:
                    completion([GeoFeature](), nil)
        case .error:
            completion(nil, "Error: Testing error")
        }
        
    }
    
}
