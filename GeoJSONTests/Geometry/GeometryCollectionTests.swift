// GeometryCollectionTests.swift
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

class GeometryCollectionTests: XCTestCase {
    
    var geoJSON: GeoJSON!
	var basicGeometryCollection: GeometryCollection!
    
    override func setUp() {
        super.setUp()
        
        geoJSON = geoJSONfromString("{ \"type\": \"GeometryCollection\", \"geometries\": [ { \"type\": \"Point\", \"coordinates\": [0.0, 0.0] } , { \"type\": \"LineString\", \"coordinates\": [ [1.0 , 2.0], [3.0 , 4.0] ] } ] }")
        
        let point = GeoJSON(point: Point(coordinates: [0.0,0.0])!)
        let lineString = GeoJSON(lineString: LineString(points: [Point(coordinates: [1.0,2.0])!,Point(coordinates: [3.0,4.0])!])!)
        
        basicGeometryCollection = GeometryCollection(geometries: [point, lineString])!
    }
    
    override func tearDown() {
        geoJSON = nil
        basicGeometryCollection = nil
        super.tearDown()
    }
    
    // MARK: - Nominal cases
    // MARK: Decoding
    func testBasicGeometryCollectionShouldBeRecognisedAsSuch() {
        XCTAssertEqual(geoJSON.type, GeoJSONType.GeometryCollection)
    }
    
    func testGeometryCollectionShouldBeAGeometry() {
        XCTAssertTrue(geoJSON.isGeometry())
    }
    
    func testBasicGeometryCollectionShouldBeParsedCorrectly() {
       
        if let geometryCollection = geoJSON.geometryCollection {
            XCTAssertEqual(geometryCollection.count, 2)
            XCTAssertEqual(geometryCollection[0].type, GeoJSONType.Point)
            XCTAssertEqual(geometryCollection[1].type, GeoJSONType.LineString)
        } else {
            XCTFail("GeometryCollection not parsed properly")
        }
    }
    
    // MARK: Encoding
    func testBasicGeometryCollectionShouldBeEncoded() {
        XCTAssertNotNil(basicGeometryCollection,"Valid GeometryCollection should be encoded properly")
        
        if let jsonString = stringFromJSON(basicGeometryCollection.json()) {
            checkForSubstring("\"type\":\"Point\"", jsonString)
            checkForSubstring("\"coordinates\":[0,0]", jsonString)
            checkForSubstring("\"type\":\"LineString\"", jsonString)
            checkForSubstring("\"coordinates\":[[1,2],[3,4]]", jsonString)
            
        } else {
            XCTFail("Valid GeometryCollection should be encoded properly")
        }
    }
    
    func testEmptyGeometryCollectionShouldBeValid() {
        let emptyGeometryCollection = GeometryCollection(geometries: [])!
        
        if let jsonString = stringFromJSON(emptyGeometryCollection.json()) {
            XCTAssertEqual(jsonString, "[]")
        }else {
            XCTFail("Empty GeometryCollection should be encoded properly")
        }
    }
    
    func testGeometryCollectionShouldHaveTheRightPrefix() {
        XCTAssertEqual(basicGeometryCollection.prefix,"geometries")
    }
    
    func testBasicGeometryCollectionInGeoJSONShouldBeEncoded() {
        let geoJSON = GeoJSON(geometryCollection: basicGeometryCollection)
        
        if let jsonString = stringFromJSON(geoJSON.json()) {
            checkForSubstring("\"type\":\"GeometryCollection\"", jsonString)
            checkForSubstring("\"geometries\":", jsonString)
            
            checkForSubstring("\"type\":\"Point\"", jsonString)
            checkForSubstring("\"coordinates\":[0,0]", jsonString)
            checkForSubstring("\"type\":\"LineString\"", jsonString)
            checkForSubstring("\"coordinates\":[[1,2],[3,4]]", jsonString)
        } else {
            XCTFail("Valid MultiPolygon in GeoJSON  should be encoded properly")
        }
    }
    
    // MARK: - Error cases
    // MARK: Decoding
    func testGeometryCollectionWithoutGeometryShouldRaiseAnError() {
        geoJSON = geoJSONfromString("{ \"type\": \"GeometryCollection\" }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid GeometryCollection should raise an invalid object error")
        }
    }
    
    func testIllFormedGeometryCollectionShouldRaiseAnError() {
        geoJSON = geoJSONfromString("{ \"type\": \"GeometryCollection\", \"geometries\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
        
        if let error = geoJSON.error {
            XCTAssertEqual(error.domain, GeoJSONErrorDomain)
            XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
        }
        else {
            XCTFail("Invalid GeometryCollection should raise an invalid object error")
        }
    }
}