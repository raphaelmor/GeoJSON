// FeatureCollectionTests.swift
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

class FeatureCollectionTests: XCTestCase {
    
    var geoJSON: GeoJSON!
    
    override func setUp() {
        super.setUp()
        
        geoJSON = geoJSONfromString("{ \"type\": \"FeatureCollection\", \"features\" : [ { \"type\": \"Feature\", \"properties\" : null, \"geometry\": null, \"id\":\"first\" }, { \"type\": \"Feature\", \"properties\" : null, \"geometry\": null, \"id\":\"second\" } ] }")
    }
    
    override func tearDown() {
        geoJSON = nil
        
        super.tearDown()
    }
    
    // MARK: - Nominal cases
    // MARK: Decoding
    func testBasicFeatureCollectionShouldBeRecognisedAsSuch() {
        XCTAssertEqual(geoJSON.type, GeoJSONType.FeatureCollection)
    }
    
    func testFeatureCollectionShouldNotBeAGeometry() {
        XCTAssertFalse(geoJSON.isGeometry())
    }
    
    func testBasicFeatureCollectionShouldBeParsedCorrectly() {
        if let featureCollection = geoJSON.featureCollection {
            XCTAssertEqual(featureCollection.count, 2)
            if let identifier = featureCollection[0].feature?.identifier {
                XCTAssertEqual(identifier, "first")
            } else { XCTFail("FeatureCollection not parsed properly") }
            if let identifier = featureCollection[1].feature?.identifier {
                XCTAssertEqual(identifier, "second")
            } else { XCTFail("FeatureCollection not parsed properly") }
        } else {
            XCTFail("FeatureCollection not parsed properly")
        }
    }
	
	// MARK: Encoding
	func testBasicFeatureCollectionShouldBeEncoded() {
		
		var first = Feature(identifier: "id1")!
		let second = Feature(identifier: "id2")!

		let geoJSONFeatureArray = [first,second].map { GeoJSON(feature: $0) }
		let featureCollection = FeatureCollection(features: geoJSONFeatureArray)
		
		XCTAssertNotNil(featureCollection,"Valid GeometryCollection should be encoded properly")
		
		if let jsonString = stringFromJSON(featureCollection!.json()) {
			checkForSubstring("\"type\":\"FeatureCollection\"", jsonString)
			checkForSubstring("\"id\":\"id1\"", jsonString)
			checkForSubstring("\"properties\":null", jsonString)
			checkForSubstring("\"type\":\"Feature\"", jsonString)
			checkForSubstring("\"id\":\"id2\"", jsonString)
			checkForSubstring("\"geometry\":null", jsonString)
		} else {
			XCTFail("Valid GeometryCollection should be encoded properly")
		}
	}
	
    // MARK: - Error Cases
	// MARK: Decoding
    func testFeatureCollectionShouldOnlyContainFeatures() {
        
        geoJSON = geoJSONfromString("{ \"type\": \"FeatureCollection\", \"features\" : [ { \"type\": \"Point\", \"coordinates\": [0.0, 0.0] } ] }")
     
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid FeatureCollection should raise an invalid object error")
        }
    }
    
    func testFeatureCollectionWithoutFeatureShouldRaiseAnError() {
        geoJSON = geoJSONfromString("{ \"type\": \"FeatureCollection\" }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid FeatureCollection should raise an invalid object error")
        }
    }
    
    func testIllFormedFeatureCollectionShouldRaiseAnError() {
        geoJSON = geoJSONfromString("{ \"type\": \"FeatureCollection\", \"features\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid FeatureCollection should raise an invalid object error")
        }
    }
    // MARK: Encoding    
}
