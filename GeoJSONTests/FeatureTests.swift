// FeatureTests.swift
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

class FeatureTests: XCTestCase {
    
    var geoJSON: GeoJSON!
    
    override func setUp() {
        super.setUp()
        
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : [], \"geometry\": { \"type\": \"Point\", \"coordinates\": [0.0, 0.0] } }")
    }
    
    override func tearDown() {
        geoJSON = nil
        
        super.tearDown()
    }
    
    // MARK: - Nominal cases
    // MARK: Decoding
    func testBasicFeatureShouldBeRecognisedAsSuch() {
        XCTAssertEqual(geoJSON.type, GeoJSONType.Feature)
    }
    
    func testFeatureShouldNotBeAGeometry() {
        XCTAssertFalse(geoJSON.isGeometry())
    }
    
    func testBasicFeatureShouldBeParsedCorrectly() {
        
        if let geoFeature = geoJSON.feature {
            if let geometry = geoFeature.geometry {
                XCTAssertEqual(geometry.type, GeoJSONType.Point)
            } else {
                XCTFail("Feature not parsed properly")
            }
            
        } else {
            XCTFail("Feature not parsed properly")
        }
    }
    
    func testFeatureWithNullGeometryShouldBeRecognised() {
        
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : [], \"geometry\": null }")
        
        if let geoFeature = geoJSON.feature {
            XCTAssertNil(geoFeature.geometry)
        } else {
            XCTFail("Feature with null Geometry should be valid feature")
        }
    }
    
    func testFeatureWithArrayPropertyShouldBeRecognised() {
        
        if let geoFeature = geoJSON.feature {
            XCTAssertTrue(geoFeature.properties.type == .Array)
        } else {
            XCTFail("Feature with Array properties should be valid")
        }
    }
    
    func testFeatureWithDictionaryPropertyShouldBeRecognised() {
        
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : {}, \"geometry\": null }")

        if let geoFeature = geoJSON.feature {
            XCTAssertTrue(geoFeature.properties.type == .Dictionary)
        } else {
            XCTFail("Feature with Dictionary properties should be valid")
        }
    }
    
    func testFeatureWithIdShouldBeRecognised() {
        
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"id\" : \"anyIdentifier\" , \"properties\" : null, \"geometry\": null }")
        
        if let geoFeature = geoJSON.feature {
            if let identifier = geoFeature.identifier {
                XCTAssertEqual(identifier, "anyIdentifier")
            } else {
                XCTFail("Feature identifier should be parsed correctly")
            }
        } else {
            XCTFail("Feature with identifier should be parsed")
        }
    }
    
    func testFeatureWithoutIdShouldBeRecognised() {
        
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : null, \"geometry\": null }")
		
        if let geoFeature = geoJSON.feature {
            XCTAssertNil(geoFeature.identifier)
        }
    }
	// MARK: Encoding
	func testEmptyFeatureShouldBeEncoded() {
		
		let feature = Feature()
		
		if let jsonString = stringFromJSON(feature!.json()) {
			checkForSubstring("\"type\":\"Feature\"", jsonString)
			checkForSubstring("\"properties\":null", jsonString)
			checkForSubstring("\"geometry\":null", jsonString)
		} else {
			XCTFail("Empty Feature should be encoded properly")
		}
	}
	
	func testBasicFeatureShouldBeEncoded() {
		let point = Point(coordinates:[0.0, 1.0])
		let geoJSONPoint = GeoJSON(point: point!)
		let feature = Feature(geometry:geoJSONPoint)
		
		XCTAssertNotNil(feature,"Valid Feature should be encoded properly")
		
		if let jsonString = stringFromJSON(feature!.json()) {
			checkForSubstring("\"type\":\"Feature\"", jsonString)
			checkForSubstring("\"properties\":null", jsonString)
			checkForSubstring("\"type\":\"Point\"", jsonString)
			checkForSubstring("\"coordinates\":[0,1]", jsonString)
		} else {
			XCTFail("Valid Feature should be encoded properly")
		}
	}
	
	func testBasicFeatureWithDictionaryPropertiesShouldBeEncoded() {

		let json = JSONfromString("{\"key\":\"value\"}")
		let feature = Feature(properties:json)
	
		if let jsonString = stringFromJSON(feature!.json()) {
			checkForSubstring("\"properties\":{\"key\":\"value\"}", jsonString)
		} else {
			XCTFail("Valid Feature should be encoded properly")
		}
	}
	
	func testBasicFeatureWithArrayPropertiesShouldBeEncoded() {
		
		let json = JSONfromString("[\"value1\",\"value2\"]")
		let feature = Feature(properties:json)
		
		if let jsonString = stringFromJSON(feature!.json()) {
			checkForSubstring("\"properties\":[\"value1\",\"value2\"]", jsonString)
		} else {
			XCTFail("Valid Feature should be encoded properly")
		}
	}
	func testBasicFeatureWithIdentifierShouldBeEncoded() {
		
		let feature = Feature(identifier:"anyID")
		
		if let jsonString = stringFromJSON(feature!.json()) {
			checkForSubstring("\"type\":\"Feature\"", jsonString)
			checkForSubstring("\"id\":\"anyID\"", jsonString)
		} else {
			XCTFail("Feature with identifier should be encoded properly")
		}
	}
	
	func testBasicFeatureInGeoJSONShouldBeEncoded() {
		let point = Point(coordinates:[0.0, 1.0])
		let geoJSONPoint = GeoJSON(point: point!)
		let feature = Feature(geometry:geoJSONPoint)
		let geoJSONFeature = GeoJSON(feature: feature!)
		
		if let jsonString = stringFromJSON(geoJSONFeature.json()) {
			checkForSubstring("\"type\":\"Feature\"", jsonString)
			checkForSubstring("\"properties\":null", jsonString)
			checkForSubstring("\"type\":\"Point\"", jsonString)
			checkForSubstring("\"coordinates\":[0,1]", jsonString)
		} else {
			XCTFail("Valid Feature should be encoded properly")
		}
	}

	
    // MARK: - Error cases
	// MARK: Decoding
    func testFeatureWithoutGeometryShouldRaiseAnError() {
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : [] }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid Feature should raise an invalid object error")
        }
    }
    
    func testIllFormedFeatureShouldRaiseAnError() {
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : [], \"geometry\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid Feature should raise an invalid object error")
        }
    }
    
    func testFeatureShouldNotContainAFeature() {
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : [], \"geometry\": { \"type\": \"Feature\", \"properties\" : [], \"geometry\": { \"type\": \"Point\", \"coordinates\": [0.0, 0.0] } } }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid Feature should raise an invalid object error")
        }
    }
    
    func testFeatureWithInvalidJSONPropertiesShouldBeInvalid() {
        
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"properties\" : {invalid}, \"geometry\": null }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid Feature should raise an invalid object error")
        }
    }

	func testFeatureWithoutPropertiesShouldBeInvalid() {
        
        geoJSON = geoJSONfromString("{ \"type\": \"Feature\", \"geometry\": null }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid Feature should raise an invalid object error")
        }
    }

	// MARK: Encoding
	func testBasicFeatureWithAFeatureShouldRaiseAnError() {
		let innerFeature = Feature()
		let geoJSONFeature = GeoJSON(feature:innerFeature!)
		let feature = Feature(geometry:geoJSONFeature)
		
		XCTAssertNil(feature,"Invalid Feature should be encoded properly")
	}
}