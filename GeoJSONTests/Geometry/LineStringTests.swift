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

//import Foundation
//import XCTest
//import GeoJSON
//
//class LineStringTests: XCTestCase {
//	
//	var geoJSON :GeoJSON!
//	
//	override func setUp() {
//		super.setUp()
//		
//		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [1.0 , 2.0], [3.0 , 4.0] ] }")
//	}
//	
//	override func tearDown() {
//		geoJSON = nil
//		
//		super.tearDown()
//	}
//	
//	// MARK: Nominal cases
//	
//	func testBasicLineStringShouldBeRecognisedAsSuch() {
//		XCTAssertEqual(geoJSON.type, GeoJSONType.LineString)
//	}
//	
//	func testBasicLineStringShouldBeParsedCorrectly() {
//		
//		if let lineString = geoJSON.lineString {
//			XCTAssertEqual(lineString.coordinates.count, 2)
//			XCTAssertEqualWithAccuracy(lineString.coordinates[0][0], 1.0, 0.000001)
//			XCTAssertEqualWithAccuracy(lineString.coordinates[0][1], 2.0, 0.000001)
//			XCTAssertEqualWithAccuracy(lineString.coordinates[1][0], 3.0, 0.000001)
//			XCTAssertEqualWithAccuracy(lineString.coordinates[1][1], 4.0, 0.000001)
//		} else {
//			XCTFail("LineString not parsed Properly")
//		}
//	}
//	
//	// MARK: Error cases
//	
//	func testLineStringWithoutCoordinatesShouldRaiseAnError() {
//		geoJSON = geoJSONfromString("{ \"type\": \"LineString\" }")
//		
//		if let error = geoJSON.error {
//			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
//			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
//		}
//		else {
//			XCTFail("Invalid LineString should raise an invalid object error")
//		}
//	}
//	
//	
//	func testLineStringWithOnePointShouldRaiseAnError() {
//		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [0.0, 1.0] ] }")
//		
//		if let error = geoJSON.error {
//			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
//			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
//		}
//		else {
//			XCTFail("Invalid LineString should raise an invalid object error")
//		}
//	}
//	
//	func testLineStringWithAPointWithLessThanTwoCoordinatesShouldRaiseAnError() {
//		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [0.0, 1.0], [2.0] ] }")
//		
//		if let error = geoJSON.error {
//			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
//			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
//		}
//		else {
//			XCTFail("Invalid LineString should raise an invalid object error")
//		}
//	}
//	
//	func testIllFormedLineStringShouldRaiseAnError() {
//		geoJSON = geoJSONfromString("{ \"type\": \"LineString\", \"coordinates\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
//		
//		if let error = geoJSON.error {
//			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
//			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
//		}
//		else {
//			XCTFail("Invalid LineString should raise an invalid object error")
//		}
//	}
//}
