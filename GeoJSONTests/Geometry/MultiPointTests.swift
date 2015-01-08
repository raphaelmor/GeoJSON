// MultiPointTests.swift
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

class MultiPointTests: XCTestCase {
	
	var geoJSON: GeoJSON!
	
	override func setUp() {
		super.setUp()
		
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [] }")
	}
	
	override func tearDown() {
		geoJSON = nil
		
		super.tearDown()
	}
	
	// MARK: - Nominal cases
	
	// MARK: Decoding
	func testBasicMultiPointShouldBeRecognisedAsSuch() {
		XCTAssertEqual(geoJSON.type, GeoJSONType.MultiPoint)
	}
    
    func testMultiPointShouldBeAGeometry() {
        XCTAssertTrue(geoJSON.isGeometry())
    }
	
	func testEmptyMultiPointShouldBeParsedCorrectly() {
		if let geoMultiPoint = geoJSON.multiPoint {
			XCTAssertEqual(geoMultiPoint.count, 0)
		} else {
			XCTFail("MultiPoint not parsed Properly")
		}
	}
	
	func testBasicMultiPointShouldBeParsedCorrectly() {
		
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [ [1.0 , 2.0], [3.0 , 4.0] ] }")
		
		if let geoMultiPoint = geoJSON.multiPoint {
			XCTAssertEqual(geoMultiPoint.count, 2)
			XCTAssertEqualWithAccuracy(geoMultiPoint.points[0].longitude, 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPoint.points[0].latitude, 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPoint.points[1].longitude, 3.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPoint.points[1].latitude, 4.0, 0.000001)
		} else {
			XCTFail("MultiPoint not parsed Properly")
		}
	}
	
	// MARK: Encoding
	
	func testBasicPointShouldBeEncoded() {
		
		let firstPoint = Point(coordinates:[0.0, 0.0])!
		let secondPoint = Point(coordinates:[1.0, 1.0])!
		
		let multiPoint = MultiPoint(points:[firstPoint,secondPoint])
		
		XCTAssertNotNil(multiPoint,"Valid Point should be encoded properly")
		
		if let jsonString = stringFromJSON(multiPoint!.json()) {
			XCTAssertEqual(jsonString, "[[0,0],[1,1]]")
		} else {
			XCTFail("Valid MultiPoint should be encoded properly")
		}
	}
	
	func testPointShouldHaveTheRightPrefix() {
		
		let firstPoint = Point(coordinates:[0.0, 0.0])!
		let secondPoint = Point(coordinates:[1.0, 1.0])!
		
		let multiPoint = MultiPoint(points:[firstPoint,secondPoint])!
		
		XCTAssertEqual(multiPoint.prefix,"coordinates")
	}
	
	func testBasicMultiPointInGeoJSONShouldBeEncoded() {
		
		let firstPoint = Point(coordinates:[0.0, 0.0])!
		let secondPoint = Point(coordinates:[1.0, 1.0])!
		
		let multiPoint = MultiPoint(points:[firstPoint,secondPoint])
		
		let geoJSON = GeoJSON(multiPoint: multiPoint!)
		
		if let jsonString = stringFromJSON(geoJSON.json()) {
			
			checkForSubstring("\"coordinates\":[[0,0],[1,1]]", jsonString)
			checkForSubstring("\"type\":\"MultiPoint\"", jsonString)
		} else {
			XCTFail("Valid MultiPoint in GeoJSON  should be encoded properly")
		}
	}

	// MARK: - Error cases
	
	// MARK: Decoding
	func testMultiPointWithoutCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\" }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPoint should raise an invalid object error")
		}
	}
	
	func testMultiPointWithAPointWithLessThanTwoCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [ [0.0, 1.0], [2.0] ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPoint should raise an invalid object error")
		}
	}
	
	func testIllFormedMultiPointShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPoint should raise an invalid object error")
		}
	}
}
