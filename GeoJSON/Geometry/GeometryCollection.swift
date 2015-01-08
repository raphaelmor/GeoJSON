// GeometryCollection.swift
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

public final class GeometryCollection : GeoJSONEncodable {
    
    /// Public geometries
    public var geometries: [GeoJSON] { return _geometries }
    
   	/// Prefix used for GeoJSON Encoding
    public var prefix: String { return "geometries" }
    
    /// Private var to store geometries
    private var _geometries: [GeoJSON] = []
    
    /**
    Designated initializer for creating a GeometryCollection from a SwiftyJSON object
    
    :param: json The SwiftyJSON Object.
    :returns: The created GeometryCollection object.
    */
    public init?(json: JSON) {
        if let jsonGeometries =  json.array {
            _geometries = jsonGeometries.map { jsonObject in
                return GeoJSON(json: jsonObject)
                } ?? []
            
            let validGeometries = _geometries.filter { geoJSON in
                return geoJSON.type != .Unknown
            }
            
            if validGeometries.count != _geometries.count {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /**
    Designated initializer for creating a GeometryCollection from [GeoJSON]
    
    :param: lineStrings The LineString array.
    :returns: The created MultiLineString object.
    */
    public init?(geometries: [GeoJSON]) {
        _geometries = geometries
    }
    
    /**
    Build a object that can be serialized to JSON
    
    :returns: Representation of the GeometryCollection Object
    */
    public func json() -> AnyObject {
        return _geometries.map { $0.json() }
    }
}

/// Array forwarding methods
public extension GeometryCollection {
    
    /// number of GeoJSON objects
    public var count: Int { return geometries.count }
    
	/// subscript to access the Nth GeoJSON
    public subscript(index: Int) -> GeoJSON {
        get { return geometries[index] }
        set(newValue) { _geometries[index] = newValue }
    }
}

/// GeometryCollection related methods on GeoJSON
public extension GeoJSON {
    
    /// Optional GeometryCollection
    public var geometryCollection: GeometryCollection? {
        get {
            switch type {
            case .GeometryCollection:
                return object as? GeometryCollection
            default:
                return nil
            }
        }
        set {
            _object = newValue ?? NSNull()
        }
    }
    
    /**
    Convenience initializer for creating a GeoJSON Object from a GeometryCollection
    
    :param: geometryCollection The GeometryCollection object.
    :returns: The created GeoJSON object.
    */
    convenience public init(geometryCollection: GeometryCollection) {
        self.init()
        object = geometryCollection
    }
}