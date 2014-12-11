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
	case Point = "Point"
	case MultiPoint = "MultiPoint"
	case LineString = "LineString"
	case Null = "Null"
	case Unknown = ""
}

public typealias Position = [Double]
public typealias PositionList = [Position]

// MARK: - GeoJSON Base

public final class GeoJSON {
	
	/// Internal type
	var _type: GeoJSONType = .Null
	/// Internal object
	var _object: AnyObject = NSNull()
	/// Internal error
	var _error: NSError?
	
	/// GeoJSON object type
	public var type: GeoJSONType { return _type }
	
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
			case let lineString as LineString:
				_type = .LineString
			case let multiPoint as MultiPoint:
				_type = .MultiPoint
			default:
				_object = NSNull()
			}
		}
	}
	
	/// Error in GeoJSON
	public var error: NSError? { return _error }
	
	public init(json: JSON) {
		
		if let typeString = json["type"].string {
			if let type = GeoJSONType(rawValue: typeString) {
				switch type {
				case .Point :
					object = Point(json: json) ?? NSNull()
				case .MultiPoint :
					object = MultiPoint(json: json) ?? NSNull()
				case .LineString :
					object = LineString(json: json) ?? NSNull()
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
		}
	}
}
