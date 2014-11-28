//
//  GeoJSONTests.swift
//  GeoJSON
//
//  Created by Raphael MOR on 28/11/2014.
//  Copyright (c) 2014 RAMO Apps. All rights reserved.
//

import Foundation
import XCTest
import GeoJSON


class GeoJSONTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInvalidTypeShouldNotBeParsedCorrectly() {
		let geoJSON = geoJSONfromString("{ \"type\": \"InvalidType\" }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorUnsupportedType)
		}
		else {
			XCTFail("Point not parsed Properly")
		}
	}
}

func geoJSONfromString(string: String) -> GeoJSON {
	let nsString = NSString(string:string)
	let data = nsString.dataUsingEncoding(NSUTF8StringEncoding)!
	let json = JSON(data:data)
	
	return GeoJSON(json:json)
}
