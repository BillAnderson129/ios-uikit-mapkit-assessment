//
//  DetailViewModelTests.swift
//  AcmeMapTests
//
//  Created by Bill Anderson on 9/26/21.
//

import XCTest
@testable import AcmeMap

class DetailViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    let mockView = MockDetailView()
    
    // MARK: - Tests
    
    func testDidLoad() throws {
        
        // Setup
        let serviceManager = MockServiceManager()
        let detailInfo = DetailInfo(
            geoFeatures: serviceManager.sampleGeoFeatures,
            selectedFeatureID: "1"
        )
        
        let detailViewModel = DetailViewModel(detailInfo: detailInfo)
        detailViewModel.didLoad(detailView: mockView)
        
        // Ensure cell count is one less than geoFeatures count
        XCTAssertEqual(mockView.cellModels.count, serviceManager.sampleGeoFeatures.count - 1)
        
        // Ensure cell models don't contain selected
        let selectedFeature = detailInfo.geoFeatures.filter { $0.id == detailInfo.selectedFeatureID }.first
        let selected = mockView.cellModels.filter { $0.name == selectedFeature?.name }
        XCTAssertEqual(selected.count, 0)
    }

}
