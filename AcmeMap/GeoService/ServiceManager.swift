//
//  ServiceManager.swift
//  AcmeMap
//
//  Created by Bill Anderson on 9/24/21.
//

import Foundation
import Combine

protocol ServiceManagerProtocol {
    func downloadGeoJSON(completion: @escaping ([GeoFeature]?, String?) -> ())
}

class ServiceManager: ServiceManagerProtocol {
    
    // MARK: - Initializers
    
    init(urlString: String = "https://assets.acmeaom.com/interview-project/locations.json") {
        self.geoJSONURLString = urlString
    }
    
    // MARK: - Properties
    
    private let geoJSONURLString: String
    
    // MARK: - ServiceManagerProtocol
    
    func downloadGeoJSON(completion: @escaping ([GeoFeature]?, String?) -> ()) {
        
        guard let url = URL(string: geoJSONURLString) else {
            completion(nil, "Error: Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Error: Invalid HTTP response")
                return
            }
            
            guard error == nil else {
                completion(nil, "Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            var errorMessage: String? = nil
            var featureCollection: FeatureCollection? = nil
            
            if let data = data {
                do {
                    featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
                } catch {
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            } else {
                errorMessage = "Error: No data returned"
            }
            
            completion(featureCollection?.features, errorMessage)
            
        }
        task.resume()
    }
}
