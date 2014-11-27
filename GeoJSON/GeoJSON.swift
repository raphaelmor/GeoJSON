//
//  GeoJSON.swift
//  GeoJSON
//
//  Created by Raphael MOR on 27/11/2014.
//  Copyright (c) 2014 RAMO Apps. All rights reserved.
//

import Foundation

// MARK: - Error

///Error domain

//public let ErrorDomain: String! = "GeoJSONErrorDomain"
//
//public let ErrorUnsupportedType: Int! = 999

// MARK: - GeoJSON Type

/**
GeoJSON's type definitions.

See http://geojson.org/geojson-spec.html
*/
public enum GeoJSONType :Int{
    
    case Point
    case Null
    case Unknown
}

// MARK: - GeoJSON Base

public class GeoJSON {
    
    /// Private type
    private var _type: GeoJSONType = .Null
    /// Private object
    private var _object: AnyObject = NSNull()
    /// Private error
    private var _error: NSError?
    
    
    /// GeoJSON object type
    public var type: GeoJSONType { get { return _type } }
    
    /// GeoJSON Object
    public var object: AnyObject {
        get {
            return _object
        }
        set {
            _object = newValue
            switch newValue {
            case let point as Point:
                _type = .Point
            default:
                _type = .Unknown
                _object = NSNull()
                _error = NSError(domain: ErrorDomain, code: ErrorUnsupportedType, userInfo: [NSLocalizedDescriptionKey: "It is a unsupported type"])
            }
        }
    }
    
    /// Error in GeoJSON
    public var error: NSError? { get { return self._error } }
    
    public init(json: JSON) {
        
        let jsonType = json["type"]
        
        if jsonType != JSON.nullJSON {
            let type = jsonType.stringValue
            println("json type : \(type)")
        }
        else {
            
        }
    }

}

// MARK: - Position Type

public struct Position {
    
    /// Coordinates
    private var coordinates: [Double] = [0.0,0.0,0.0]
    
    public var longitude: Double {
        get { return coordinates[0] }
        set { coordinates[0] = newValue }
    }
    
    public var latitude: Double {
        get { return coordinates[1] }
        set { coordinates[1] = newValue }
    }
    
    public var altitude: Double {
        get { return coordinates[2] }
        set { coordinates[2] = newValue }
    }
    
    subscript(index: Int) -> Double {
        get { return coordinates[index] }
        set { coordinates[index] = newValue }
    }
}

// MARK: - Point Type

public class Point {
    
    /// Private coordinates
    private var _coordinates: Position = Position()
    
    /// Public coordinates
    public var coordinates: Position { get { return _coordinates } }
}

public extension GeoJSON {
    
    //Optional string
    public var point: Point? {
        get {
            switch self.type {
            case .Point:
                return self.object as? Point
            default:
                return nil
            }
        }
        set {
            if newValue != nil {
                self._object = newValue!
            } else {
                self._object = NSNull()
            }
        }
    }
}
