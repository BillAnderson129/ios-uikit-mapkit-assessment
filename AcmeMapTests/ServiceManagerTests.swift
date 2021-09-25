//
//  ServiceManagerTests.swift
//  AcmeMapTests
//
//  Created by Bill Anderson on 9/26/21.
//

import XCTest
@testable import AcmeMap

class ServiceManagerTests: XCTestCase {

    func testDownloadGeoJSON() throws {
        
        // Test with standard url
        let goodServiceManager = ServiceManager()
        let goodExpectation = expectation(description: "Good URL")
        goodServiceManager.downloadGeoJSON { features, errorMessage in
            XCTAssertEqual(features?.count, 11)
            XCTAssertNil(errorMessage)
            goodExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0)
        
        // Test with empty url
        let emptyServiceManager = ServiceManager(urlString: "")
        let emptyExpectation = expectation(description: "Empty URL")
        emptyServiceManager.downloadGeoJSON { features, errorMessage in
            XCTAssertNil(features?.count)
            XCTAssertEqual(errorMessage, "Error: Invalid URL")
            emptyExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0)
        
        // Test with bad url
        let badServiceManager = ServiceManager(urlString: "https://myradar.com")
        let badExpectation = expectation(description: "Bad URL")
        badServiceManager.downloadGeoJSON { features, errorMessage in
            XCTAssertNil(features?.count)
            XCTAssertEqual(errorMessage, "Error: The data couldn’t be read because it isn’t in the correct format.")
            badExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0)
    }
    
}
