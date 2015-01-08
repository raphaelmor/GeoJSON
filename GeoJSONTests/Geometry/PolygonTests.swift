// PolygonTests.swift
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

class PolygonTests: XCTestCase {
	
	var geoJSON: GeoJSON!
	
	override func setUp() {
		super.setUp()
		
		geoJSON = geoJSONfromString("{ \"type\": \"Polygon\", \"coordinates\": [ [[0.0, 0.0], [1.0, 1.0], [2.0, 2.0], [0.0, 0.0]] ] }")
	}
	
	override func tearDown() {
		geoJSON = nil
		
		super.tearDown()
	}
	
	// MARK: Nominal cases
	
	func testBasicPolygonShouldBeRecognisedAsSuch() {
		XCTAssertEqual(geoJSON.type, GeoJSONType.Polygon)
	}
    
    func testPolygonShouldBeAGeometry() {
        XCTAssertTrue(geoJSON.isGeometry())
    }
	
	func testEmptyPolygonShouldBeParsedCorrectly() {
		
		geoJSON = geoJSONfromString("{ \"type\": \"Polygon\", \"coordinates\": [] }")
		
		if let geoPolygon = geoJSON.polygon {
			XCTAssertEqual(geoPolygon.linearRings.count, 0)
		} else {
			XCTFail("Polygon not parsed properly")
		}
	}
	
	func testBasicPolygonShouldBeParsedCorrectly() {
		
		if let geoPolygon = geoJSON.polygon {
			XCTAssertEqual(geoPolygon.linearRings.count, 1)
			XCTAssertTrue(geoPolygon.linearRings[0].isLinearRing())
			
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][0].longitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][0].latitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][1].longitude, 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][1].latitude, 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][2].longitude, 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][2].latitude, 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][3].longitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoPolygon.linearRings[0][3].latitude, 0.0, 0.000001)
		} else {
			XCTFail("Polygon not parsed Properly")
		}
	}
	
	// MARK: Error cases
	
	func testPolygonWithoutCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"Polygon\"}")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid Polygon should raise an invalid object error")
		}
	}
	
	func testPolygonWithAnInvalidLinearRingShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"Polygon\", \"coordinates\": [ [[0.0, 0.0], [1.0, 1.0], [2.0, 2.0], [3.0, 3.0]] ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid Polygon should raise an invalid object error")
		}
	}
	
	func testIllFormedMultiLineStringShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"Polygon\", \"coordinates\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid Polygon should raise an invalid object error")
		}
	}
}
