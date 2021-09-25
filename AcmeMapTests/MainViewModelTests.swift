//
//  MainViewModelTests.swift
//  AcmeMapTests
//
//  Created by Bill Anderson on 9/26/21.
//

import XCTest
@testable import AcmeMap
import MapKit

class MainViewModelTests: XCTestCase {

    // MARK: - Properties
    
    let mockServiceManager = MockServiceManager()
    let mockView = MockMainView()
    
    // MARK: - Lifecycle
    
    override func setUpWithError() throws {
        mockView.errorMessage = nil
        mockView.detailInfoArray = [DetailInfo]()
        mockView.acmeAnnotations = [AcmePointAnnotation]()
        mockView.expecation = nil
    }
    
    // MARK: - Tests
    
    func testDidLoad() throws {
        
        // Setup
        let mainViewModel = MainViewModel(serviceManager: mockServiceManager)
        
        let asyncExpectation = expectation(description: "Async")
        mockView.expecation = asyncExpectation
        
        // Happy path with good data, no error messages
        mainViewModel.didLoad(mainView: mockView)
        waitForExpectations(timeout: 1.0)
        
        // Ensure view exists
        XCTAssertNotNil(mainViewModel.view)
        
        // Ensure updateGeoJSON() was called
        XCTAssertEqual(mockView.acmeAnnotations.count, mockServiceManager.sampleGeoFeatures.count)
    }
    
    func testDidSelect() throws {
        
        // Setup
        let mainViewModel = MainViewModel(serviceManager: mockServiceManager)
        mainViewModel.didLoad(mainView: mockView)
        
        let annotations = mockServiceManager.sampleGeoFeatures.map { $0.pointAnnotation() }
        mainViewModel.didSelect(annotation: annotations.first!)
        
        // Ensure view adds correct DetailInfo
        XCTAssertEqual(mockView.detailInfoArray.count, 1)
        
        let detailInfo = mockView.detailInfoArray.first
        XCTAssertEqual(detailInfo?.geoFeatures.count, mockServiceManager.sampleGeoFeatures.count)
        
        XCTAssertEqual(detailInfo?.selectedFeatureID, detailInfo?.geoFeatures.first?.id)
        
        // Ensure non-AcmePointAnnotation returns without adding detailInfo to view
        let point = MKPointAnnotation()
        mainViewModel.didSelect(annotation: point)
        
        XCTAssertEqual(mockView.detailInfoArray.count, 1)
    }
    
    func testUpdateGeoJSON() throws {
        
        // Setup
        let mainViewModel = MainViewModel(serviceManager: mockServiceManager)
        
        let goodExpectation = expectation(description: "Good")
        mockView.expecation = goodExpectation
        
        // Happy path with good data, no error messages
        mainViewModel.didLoad(mainView: mockView)
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(mockView.acmeAnnotations.count, mockServiceManager.sampleGeoFeatures.count)
        XCTAssertNil(mockView.errorMessage)
        
        // Empty geofeatures
        let emptyExpectation = expectation(description: "Empty")
        mockView.expecation = emptyExpectation
        mockServiceManager.resultType = .empty
        mockView.acmeAnnotations.removeAll()
        mainViewModel.updateGeoJSON()
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(mockView.acmeAnnotations.count, 0)
        XCTAssertEqual(mockView.errorMessage, "Error: Feature collection has no features")
        
        // Error message returned
        let errorExpectation = expectation(description: "Error")
        mockView.expecation = errorExpectation
        mockServiceManager.resultType = .error
        mockView.acmeAnnotations.removeAll()
        mainViewModel.updateGeoJSON()
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(mockView.acmeAnnotations.count, 0)
        XCTAssertEqual(mockView.errorMessage, "Error: Testing error")
    }

}
