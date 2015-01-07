// GeoJSON.swift
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

// MARK: - Error

public let GeoJSONErrorDomain: String = "GeoJSONErrorDomain"

public let GeoJSONErrorUnsupportedType: Int = 999
public let GeoJSONErrorInvalidGeoJSONObject: Int = 998

// MARK: - GeoJSON Type definitions
// See http://geojson.org/geojson-spec.html
public enum GeoJSONType: String {
	case Point              = "Point"
	case MultiPoint         = "MultiPoint"
	case LineString         = "LineString"
	case MultiLineString    = "MultiLineString"
	case Polygon            = "Polygon"
	case MultiPolygon       = "MultiPolygon"
    case GeometryCollection = "GeometryCollection"
    case Feature            = "Feature"
    case FeatureCollection  = "FeatureCollection"
	case Unknown            = ""
}

public typealias PositionList = [[Double]]

// MARK: - GeoJSON

public final class GeoJSON {
	
	/// Object type
	public var type: GeoJSONType { return _type }
	
	/// Object
	public var object: GeoJSONEncodable {
		get {
			return _object
		}
		set {
			_object = newValue
			switch newValue {
			case let point as Point:
				_type = .Point
			case let multiPoint as MultiPoint:
				_type = .MultiPoint
			case let lineString as LineString:
				_type = .LineString
			case let multiLineString as MultiLineString:
				_type = .MultiLineString
			case let polygon as Polygon:
				_type = .Polygon
			case let multiPolygon as MultiPolygon:
				_type = .MultiPolygon
            case let geometryCollection as GeometryCollection:
                _type = .GeometryCollection
            case let feature as Feature:
                _type = .Feature
            case let featureCollection as FeatureCollection:
                _type = .FeatureCollection
			default:
				_object = NSNull()
			}
		}
	}
	
	/// Error
	public var error: NSError? { return _error }
	
	
	/// Internal type
	var _type: GeoJSONType = .Unknown
	/// Internal object
	var _object: GeoJSONEncodable = NSNull()
	/// Internal error
	var _error: NSError?
	
	/**
	Creates a GeoJSON object from a SwiftyJSON Object
	
	:param: json The SwiftyJSON object from which to create the GeoJSON Object.
	:returns: a GeoJSON object
	*/
	public init(json: JSON) {
		
		if let typeString = json["type"].string {
			if let type = GeoJSONType(rawValue: typeString) {
				
				let coordinatesField = json["coordinates"]
				
				switch type {
				case .Point:
					object = Point(json: coordinatesField) ?? NSNull()
				case .MultiPoint:
					object = MultiPoint(json: coordinatesField) ?? NSNull()
				case .LineString:
					object = LineString(json: coordinatesField) ?? NSNull()
				case .MultiLineString:
					object = MultiLineString(json: coordinatesField) ?? NSNull()
				case .Polygon:
					object = Polygon(json: coordinatesField) ?? NSNull()
				case .MultiPolygon:
					object = MultiPolygon(json: coordinatesField) ?? NSNull()
                case .GeometryCollection:
                    object = GeometryCollection(json: json["geometries"]) ?? NSNull()
                case .Feature:
                    object = Feature(json: json) ?? NSNull()
                case .FeatureCollection:
                    object = FeatureCollection(json: json["features"]) ?? NSNull()
				default :
					println("foo")
				}
				
				if let _ = object as? NSNull {
					_type = .Unknown
					_error = NSError(domain: GeoJSONErrorDomain, code: GeoJSONErrorInvalidGeoJSONObject, userInfo: [NSLocalizedDescriptionKey: "GeoJSON Object is invalid"])
				}
			}
			else {
				_type = .Unknown
				_object = NSNull()
				_error = NSError(domain: GeoJSONErrorDomain, code: GeoJSONErrorUnsupportedType, userInfo: [NSLocalizedDescriptionKey: "It is a unsupported type"])
			}
        } else {
            _type = .Unknown
            _error = NSError(domain: GeoJSONErrorDomain, code: GeoJSONErrorInvalidGeoJSONObject, userInfo: [NSLocalizedDescriptionKey: "GeoJSON Object is invalid"])
        }
    }
	
	/**
	Checks if the object is a Geometric type

	:returns: True if the contained object is of the Geometry type, false otherwise.
	*/
	public func isGeometry() -> Bool {
		switch type {
		case .Point,.MultiPoint,.LineString,.MultiLineString,.Polygon,.MultiPolygon,.GeometryCollection:
			return true
		default :
			return false
		}
	}
	
	/**
	Build a object that can be serialized to JSON
	
	:returns: Representation of the GeoJSON Object
	*/
	public func json() -> AnyObject {
		let dictionary = [
			"type" : _type.rawValue,
			_object.prefix : _object.json()
		]
		
		return dictionary
	}

	
	/**
	Creates an empty GeoJSON object
	
	:returns: an empty GeoJSON object
	*/
	init() { }
	
	
}