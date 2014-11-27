//
//  GeoJSONTests.swift
//  GeoJSONTests
//
//  Created by Raphaël on 25/11/2014.
//  Copyright (c) 2014 RAMO Apps. All rights reserved.
//

import UIKit
import XCTest
import GeoJSON


class GeoJSONTests: XCTestCase {
    
    var geoJSON :GeoJSON!
    
    
    override func setUp() {
        super.setUp()
        
        let string = NSString(string:"{ \"type\": \"Point\", \"coordinates\": [42.0, 24.0] }")
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)!
        let json = JSON(data:data)
        
        geoJSON = GeoJSON(json:json)
    }
    
    override func tearDown() {
        geoJSON = nil
        
        super.tearDown()
    }
    
    func testBasicPointShouldBeRecognisedAsSuch() {
        
        XCTAssertEqual(geoJSON.type,GeoJSONType.Point)
    }
    
    func testBasicPointShouldBeParsedCorrectly() {
        
        if let geoPoint = geoJSON.point {
            XCTAssertEqualWithAccuracy(geoPoint.coordinates[0], 42.0, 0.000001)
            XCTAssertEqualWithAccuracy(geoPoint.coordinates[1], 24.0, 0.000001)
        } else {
            XCTFail("Point not parsed Properly")
        }
    }
}
