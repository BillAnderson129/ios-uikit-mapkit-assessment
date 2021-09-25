//
//  MainViewModel.swift
//  AcmeMap
//
//  Created by Bill Anderson on 9/24/21.
//

import Foundation
import MapKit

protocol MainViewProtocol {
    func addFeatureAnnotations(annotations: [AcmePointAnnotation])
    func presentDetailView(with detailInfo: DetailInfo)
    func showNetworkAlert(message: String)
}

class MainViewModel: MainViewModelProtocol {
    
    // MARK: - Initializers
    
    init(serviceManager: ServiceManagerProtocol) {
        self.serviceManager = serviceManager
    }
    
    // MARK: - Properties
    
    var view: MainViewProtocol?
    let serviceManager: ServiceManagerProtocol
    private var geoFeatures = [GeoFeature]()
    private var selectedFeatureID = ""
    private var detailInfo: DetailInfo {
        DetailInfo(geoFeatures: geoFeatures, selectedFeatureID: selectedFeatureID)
    }
    
    // MARK: - MainViewModelProtocol
    
    func didLoad(mainView: MainViewProtocol) {
        view = mainView
        updateGeoJSON()
    }
    
    func didSelect(annotation: MKAnnotation?) {
        guard let acmeAnnotation = annotation as? AcmePointAnnotation else {
            return
        }
        selectedFeatureID = acmeAnnotation.id
        view?.presentDetailView(with: detailInfo)
    }
    
    func updateGeoJSON() {
        
        serviceManager.downloadGeoJSON { [weak self] features, errorMessage in
            
            guard errorMessage == nil else {
                let message = errorMessage ?? "Error: Feature collection unavailable"
                self?.displayNetwork(errorMessage: message)
                return
            }
            
            guard let features = features, !features.isEmpty else {
                self?.displayNetwork(errorMessage: "Error: Feature collection has no features")
                return
            }
            
            self?.geoFeatures = features
            self?.updateView()
            
        }
    }
    
    // MARK: - Private
    
    private func displayNetwork(errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showNetworkAlert(message: errorMessage)
        }
    }
    
    private func updateView() {
        let annotations = geoFeatures.map { $0.pointAnnotation() }
        DispatchQueue.main.async { [weak self] in
            self?.view?.addFeatureAnnotations(annotations: annotations)
        }
    }
}
