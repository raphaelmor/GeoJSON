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
	
	var geoJSON :GeoJSON!
	
	override func setUp() {
		super.setUp()
		
		geoJSON = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [42.0, 24.0] }")
	}
	
	override func tearDown() {
		geoJSON = nil
		
		super.tearDown()
	}
	
	// MARK: Nominal cases
	
	func testBasicPointShouldBeRecognisedAsSuch() {
		XCTAssertEqual(geoJSON.type, GeoJSONType.Point)
	}
	
	func testBasicPointShouldBeParsedCorrectly() {
		if let geoPoint = geoJSON.point {
			XCTAssertEqualWithAccuracy(geoPoint.coordinates.longitude, 42.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.coordinates.latitude, 24.0, 0.000001)
		}
		else {
			XCTFail("Point not parsed Properly")
		}
	}
	
	func testComplexPointShouldBeParsedCorrectly() {
		geoJSON = geoJSONfromString("{ \"type\": \"Point\", \"coordinates\": [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0] }")
		
		if let geoPoint = geoJSON.point {
			XCTAssertEqualWithAccuracy(geoPoint.coordinates.longitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.coordinates.latitude, 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.coordinates.altitude, 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.coordinates[3], 3.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.coordinates[4], 4.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.coordinates[5], 5.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPoint.coordinates[6], 6.0, 0.000001)
		}
		else {
			XCTFail("Point not parsed Properly")
		}
	}
	
	// MARK: Error cases
	
	func testBasicPointShouldNotHaveAltitude() {
		if let geoPoint = geoJSON.point {
			XCTAssertEqual(geoPoint.coordinates.count, 2)
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
}
