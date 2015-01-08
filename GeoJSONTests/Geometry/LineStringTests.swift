// LineStringTests.swift
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

class LineStringTests: XCTestCase {
	
	var geoJSON: GeoJSON!
	var twoPointLineString: LineString!
	
	override func setUp() {
		super.setUp()
		
		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [1.0 , 2.0], [3.0 , 4.0] ] }")
		
		let firstPoint = Point(coordinates:[0.0, 0.0])!
		let secondPoint = Point(coordinates:[1.0, 1.0])!
		
		twoPointLineString = LineString(points:[firstPoint,secondPoint])
	}
	
	override func tearDown() {
		geoJSON = nil
		twoPointLineString = nil
		
		super.tearDown()
	}
	
	// MARK: - Nominal cases
	// MARK: Decoding
	func testBasicLineStringShouldBeRecognisedAsSuch() {
		XCTAssertEqual(geoJSON.type, GeoJSONType.LineString)
	}
    
    func testLineStringShouldBeAGeometry() {
        XCTAssertTrue(geoJSON.isGeometry())
    }
	
	func testBasicLineStringShouldBeParsedCorrectly() {
		if let lineString = geoJSON.lineString {
			XCTAssertEqual(lineString.count, 2)
			XCTAssertEqualWithAccuracy(lineString.points[0][0], 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(lineString.points[0][1], 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(lineString.points[1][0], 3.0, 0.000001)
			XCTAssertEqualWithAccuracy(lineString.points[1][1], 4.0, 0.000001)
		} else {
			XCTFail("LineString not parsed Properly")
		}
	}
	
	func testLinearRingShouldBeRecognized() {
		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [0.0 , 0.0], [1.0 , 1.0], [2.0 , 2.0], [0.0 , 0.0] ] }")
		
		if let lineString = geoJSON.lineString {
			XCTAssertTrue(lineString.isLinearRing())
		} else {
			XCTFail("LineString not parsed Properly")
		}
	}
	
	func testNonLinearRingShouldBeRecognized() {
		if let lineString = geoJSON.lineString {
			XCTAssertFalse(lineString.isLinearRing())
		} else {
			XCTFail("LineString not parsed Properly")
		}
	}
	// MARK: Encoding
	func testBasicLineStringShouldBeEncoded() {
		XCTAssertNotNil(twoPointLineString,"Valid LineString should be encoded properly")
		
		if let jsonString = stringFromJSON(twoPointLineString.json()) {
			XCTAssertEqual(jsonString, "[[0,0],[1,1]]")
		} else {
			XCTFail("Valid LineString should be encoded properly")
		}
	}
	
	func testLineStringShouldHaveTheRightPrefix() {
		XCTAssertEqual(twoPointLineString.prefix,"coordinates")
	}
	
	func testBasicLineStringInGeoJSONShouldBeEncoded() {
		let geoJSON = GeoJSON(lineString: twoPointLineString)
		
		if let jsonString = stringFromJSON(geoJSON.json()) {
			
			checkForSubstring("\"coordinates\":[[0,0],[1,1]]", jsonString)
			checkForSubstring("\"type\":\"LineString\"", jsonString)
		} else {
			XCTFail("Valid LineString in GeoJSON  should be encoded properly")
		}
	}
	
	// MARK: - Error cases
	// MARK: Decoding
	func testLineStringWithoutCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"LineString\" }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid LineString should raise an invalid object error")
		}
	}
	
	func testLineStringWithOnePointShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [0.0, 1.0] ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid LineString should raise an invalid object error")
		}
	}
	
	func testLineStringWithAPointWithLessThanTwoCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [0.0, 1.0], [2.0] ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid LineString should raise an invalid object error")
		}
	}
	
	func testIllFormedLineStringShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid LineString should raise an invalid object error")
		}
	}
	
	// MARK: Encoding
	func testZeroPointLineStringShouldBeInvalid() {
		let zeroPointLineString = LineString(points:[])
		
		XCTAssertNil(zeroPointLineString, "LineString should have at least two points")
	}
	
	func testOnePointLineStringShouldBeInvalid() {
		let firstPoint = Point(coordinates:[0.0, 0.0])!
		
		let onePointLineString = LineString(points:[firstPoint])
		
		XCTAssertNil(onePointLineString, "LineString should have at least two points")
	}
}
