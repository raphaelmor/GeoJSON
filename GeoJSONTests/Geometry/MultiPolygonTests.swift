// MultiPolygonTests.swift
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

class MultiPolygonTests: XCTestCase {
	
	var geoJSON :GeoJSON!
	
	override func setUp() {
		super.setUp()
		
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPolygon\", \"coordinates\": [ [[[0.0, 0.0], [1.0, 1.0], [2.0, 2.0], [0.0, 0.0]]], [[[10.0, 10.0], [11.0, 11.0], [12.0, 12.0], [10.0, 10.0]]] ] }")
	}
	
	override func tearDown() {
		geoJSON = nil
		
		super.tearDown()
	}
	
	// MARK: Nominal cases
	
	func testBasicMultiPolygonShouldBeRecognisedAsSuch() {
		XCTAssertEqual(geoJSON.type, GeoJSONType.MultiPolygon)
	}
    
    func testMultiPolygonShouldBeAGeometry() {
        XCTAssertTrue(geoJSON.isGeometry)
    }
	
	func testEmptyMultiPolygonShouldBeParsedCorrectly() {
		
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPolygon\", \"coordinates\": [] }")
		
		if let geoMultiPolygon = geoJSON.multiPolygon {
			XCTAssertEqual(geoMultiPolygon.polygons.count, 0)
		} else {
			XCTFail("MultiPolygon not parsed Properly")
		}
	}
	
	func testBasicMultiLineStringShouldBeParsedCorrectly() {
		
		if let geoMultiPolygon = geoJSON.multiPolygon {
			XCTAssertEqual(geoMultiPolygon.polygons.count, 2)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[0].longitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[0].latitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[1].longitude, 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[1].latitude, 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[2].longitude, 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[2].latitude, 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[3].longitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[0].linearRings[0].points[3].latitude, 0.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[0].longitude, 10.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[0].latitude, 10.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[1].longitude, 11.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[1].latitude, 11.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[2].longitude, 12.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[2].latitude, 12.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[3].longitude, 10.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPolygon.polygons[1].linearRings[0].points[3].latitude, 10.0, 0.000001)

		} else {
			XCTFail("MultiPolygon not parsed Properly")
		}
	}
	
	func testNonhomogeneousMultiPolygonShouldBeParsedCorrectly() {
		
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPolygon\", \"coordinates\": [ [[[0.0, 0.0], [1.0, 1.0], [2.0, 2.0], [0.0, 0.0]],[[0.5, 0.5], [1.5, 1.5], [2.5, 2.5], [0.5, 0.5]]], [[[10.0, 10.0], [11.0, 11.0], [12.0, 12.0], [10.0, 10.0]]] ] }")
		
		if let geoMultiPolygon = geoJSON.multiPolygon {
			XCTAssertEqual(geoMultiPolygon.polygons.count, 2)
			XCTAssertEqual(geoMultiPolygon.polygons[0].linearRings.count, 2)
			XCTAssertEqual(geoMultiPolygon.polygons[1].linearRings.count, 1)
		} else {
			XCTFail("MultiPolygon not parsed Properly")
		}
	}
	
	// MARK: Error cases
	
	func testMultiPolygonWithoutCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPolygon\"}")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPolygon should raise an invalid object error")
		}
	}
	
	func testMultiPolygonWithAnInvalidPolygonShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPolygon\", \"coordinates\": [ [[0.0, 0.0]] ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPolygon should raise an invalid object error")
		}
	}

	func testIllFormedMultiPolygonShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPolygon\", \"coordinates\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPolygon should raise an invalid object error")
		}
	}

}