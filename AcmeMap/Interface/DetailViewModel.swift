//
//  DetailViewModel.swift
//  AcmeMap
//
//  Created by Bill Anderson on 9/24/21.
//

import Foundation
import MapKit

protocol DetailViewProtocol {
    func updateView(with models: [CellModel])
}

struct DetailInfo {
    let geoFeatures: [GeoFeature]
    let selectedFeatureID: String
}

class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Initializers
    
    init(detailInfo: DetailInfo) {
        self.detailInfo = detailInfo
    }
    
    // MARK: - Properties
    
    var view: DetailViewProtocol?
    let detailInfo: DetailInfo
    
    // MARK: - DetailViewModelProtocol
    
    func didLoad(detailView: DetailViewProtocol) {
        view = detailView
        determineClosestFeatures()
    }
    
    // MARK: - Private
    
    private func determineClosestFeatures() {
        
        let selected   = detailInfo.geoFeatures.filter({ $0.id == detailInfo.selectedFeatureID }).first!
        let unselected = detailInfo.geoFeatures.filter { $0.id != detailInfo.selectedFeatureID }
        let cellModels: [CellModel] = unselected.map {
            CellModel(name: $0.name, distance: $0.distance(to: selected))
        }
        let sortedCellModels = cellModels.sorted { $0.distance < $1.distance }
        
        view?.updateView(with: sortedCellModels)
    }
}
