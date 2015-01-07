// PointTests.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Raphaël Mor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import XCTest
import GeoJSON

class PointTests: XCTestCase {
	
	var geoJSON: GeoJSON!
	
	override func setUp() {
		super.setUp()
		
		geoJSON = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [42.0, 24.0] }")
	}
	
	override func tearDown() {
		geoJSON = nil
		
		super.tearDown()
	}
	
	// MARK: - Nominal cases
	
	// MARK: Decoding
	func testBasicPointShouldBeRecognisedAsSuch() {
		XCTAssertEqual(geoJSON.type, GeoJSONType.Point)
	}
    
    func testPointShouldBeAGeometry() {
        XCTAssertTrue(geoJSON.isGeometry)
    }
	
	func testBasicPointShouldBeParsedCorrectly() {
		if let geoPoint = geoJSON.point {
			XCTAssertEqualWithAccuracy(geoPoint.longitude, 42.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.latitude, 24.0, 0.000001)
		}
		else {
			XCTFail("Point not parsed Properly")
		}
	}
	
	func testComplexPointShouldBeParsedCorrectly() {
		geoJSON = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0] }")
		
		if let geoPoint = geoJSON.point {
			XCTAssertEqualWithAccuracy(geoPoint.longitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.latitude, 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.altitude, 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint[3], 3.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint[4], 4.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint[5], 5.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint[6], 6.0, 0.000001)
		}
		else {
			XCTFail("Point not parsed Properly")
		}
	}
	
	func testShortcutsShouldWork() {
		if let geoPoint = geoJSON.point {
			XCTAssertEqualWithAccuracy(geoPoint.longitude, geoPoint.easting, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.latitude, geoPoint.northing, 0.000001)
		}
		else {
			XCTFail("Point not parsed Properly")
		}
	}
	
	// MARK: Encoding 
	func testBasicPointShouldBeEncoded() {
		
		if let point = Point(coordinates:[0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
		{
			if let jsonString = stringFromJSON(point.json()) {
				XCTAssertEqual(jsonString, "{\"coordinates\":[0,1,2,3,4,5,6],\"type\":\"Point\"}")
			} else {
				XCTFail("Valid Point should be encoded properly")
			}
		} else {
			XCTFail("Valid Point should be encoded properly")
		}
	}
	
	// MARK: Point Equality
	
	func testTwoPointsWithEqualCoordinatesShouldBeEqual() {
		let lhs = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 0.0] }")
		let rhs = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 0.0] }")
		
		XCTAssertEqual(lhs.point!,rhs.point!)
	}
	
	func testTwoPointsWithDifferentCoordinatesShouldNotBeEqual() {
		let lhs = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 0.0] }")
		let rhs = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 1.0] }")
		
		XCTAssertNotEqual(lhs.point!,rhs.point!)
	}
	
	func testTwoPointsWithDifferentNumberOfCoordinatesShouldNotBeEqual() {
		let lhs = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 0.0] }")
		let rhs = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 0.0, 0.0] }")
		
		XCTAssertNotEqual(lhs.point!,rhs.point!)
	}
	
	// MARK: - Error cases
	
	// MARK: Decoding
	func testBasicPointShouldNotHaveAltitude() {
		if let geoPoint = geoJSON.point {
			XCTAssertEqual(geoPoint.count, 2)
		}
		else {
			XCTFail("Point not parsed Properly")
		}
	}
	
	func testPointWithoutCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"Point\" }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid Point should raise an invalid object error")
		}
	}
	
	func testPointWithLessThanTwoCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid Point should raise an invalid object error")
		}
	}
	
	// MARK: Encoding
	func testEncodingPointWithoutCoordinatesShouldRaiseAnError() {
		
		let point = Point(coordinates:[])
		
		XCTAssertNil(point, "Invalid Point should not be encoded")
	}
	
	func testEncodingPointWithLessThanTwoCoordinatesShouldRaiseAnError() {
		
		let point = Point(coordinates:[0.0])
		
		XCTAssertNil(point, "Invalid Point should not be encoded")
	}
}
