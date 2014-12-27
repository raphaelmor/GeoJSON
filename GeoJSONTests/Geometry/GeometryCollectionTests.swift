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
    
    override func setUp() {
        super.setUp()
        
        geoJSON = geoJSONfromString("{ \"type\": \"GeometryCollection\", \"geometries\": [ { \"type\": \"Point\", \"coordinates\": [0.0, 0.0] } , { \"type\": \"LineString\", \"coordinates\": [ [1.0 , 2.0], [3.0 , 4.0] ] } ] }")
    }
    
    override func tearDown() {
        geoJSON = nil
        
        super.tearDown()
    }
    
    // MARK: Nominal cases
    
    func testBasicGeometryCollectionShouldBeRecognisedAsSuch() {
        XCTAssertEqual(geoJSON.type, GeoJSONType.GeometryCollection)
    }
    
    func testGeometryCollectionShouldBeAGeometry() {
        XCTAssertTrue(geoJSON.isGeometry)
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
    
    // MARK: Error cases
    
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