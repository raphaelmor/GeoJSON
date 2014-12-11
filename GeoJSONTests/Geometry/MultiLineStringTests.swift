// MultiLineStringTests.swift
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

//class MultiLineStringTests: XCTestCase {
//	
//	var geoJSON :GeoJSON!
//	
//	override func setUp() {
//		super.setUp()
//		
//		geoJSON = geoJSONfromString("{ \"type\": \"MultiLineString\", \"coordinates\": [ [[0.0, 0.0], [0.0, 1.0]], [[1.0, 0.0], [1.0, 1.0]] ] }")
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
//	func testBasicMultiLineStringShouldBeRecognisedAsSuch() {
//		XCTAssertEqual(geoJSON.type, GeoJSONType.MultiLineString)
//	}
//	
//	func testEmptyMultiLineStringShouldBeParsedCorrectly() {
//		
//		geoJSON = geoJSONfromString("{ \"type\": \"MultiLineString\", \"coordinates\": [] }")
//		
//		if let geoMultiLineString = geoJSON.multiLineString {
//			XCTAssertEqual(geoMultiLineString.lineStrings.count, 0)
//		} else {
//			XCTFail("MultiLineString not parsed Properly")
//		}
//	}
//	
//	func testBasicMultiLineStringShouldBeParsedCorrectly() {
//		
//		if let geoMultiLineString = geoJSON.multiLineString {
//			XCTAssertEqual(geoMultiLineString.lineStrings.count, 2)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[0][0][0], 0.0, 0.000001)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[0][0][1], 0.0, 0.000001)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[0][1][0], 0.0, 0.000001)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[0][1][1], 1.0, 0.000001)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[1][0][0], 1.0, 0.000001)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[1][0][1], 0.0, 0.000001)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[1][1][0], 1.0, 0.000001)
//			XCTAssertEqualWithAccuracy(geoMultiLineString.lineStrings[1][1][1], 1.0, 0.000001)
//		} else {
//			XCTFail("MultiPoint not parsed Properly")
//		}
//	}
//
//	
//}