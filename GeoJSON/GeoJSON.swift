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
    case Null = "Null"
    case Unknown = ""
}

public typealias Position = [Double]

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
			case let multiPoint as MultiPoint:
				_type = .MultiPoint
            default:
				_object = NSNull()
            }
        }
    }
    
    /// Error in GeoJSON
    public var error: NSError? { get { return self._error } }
    
    public init(json: JSON) {
        
        if let typeString = json["type"].string {
            if let type = GeoJSONType(rawValue: typeString) {
                switch type {
                case .Point :
					self.object = Point(json: json) ?? NSNull()
				case .MultiPoint :
					self.object = MultiPoint(json: json) ?? NSNull()
                default :
					println("foo")
                }
				
				if let object = self.object as? NSNull {
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

// MARK: - Point Type

public class Point {
    
    /// Private coordinates
    private var _coordinates: Position = [0.0,0.0]
    
    /// Public coordinates
    public var coordinates: Position { get { return _coordinates } }
    
    public init?(json: JSON) {
        let optCoord = json["coordinates"]
        if let coordinates =  optCoord.array {
            if coordinates.count < 2 { return nil }
			
            _coordinates = coordinates.map {
                Double($0.doubleValue)
            }
        } else {
            return nil
        }
    }
}

public extension GeoJSON {
    
    /// Optional Point
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

// MARK: - MultiPoint Type

public class MultiPoint {
	
	/// Private coordinates
	private var _coordinates: [Position] = []
	
	/// Public coordinates
	public var coordinates: [Position] { get { return _coordinates } }
	
	public init?(json: JSON) {
		let optCoord = json["coordinates"]
		if let coordinatesArray =  optCoord.array {
			let validCoordinates = coordinatesArray.filter {
				if let coordinatesArray = $0.array {
					return coordinatesArray.count >= 2
				}
				else {
					return false
				}
			}
			
			if validCoordinates.count != coordinatesArray.count { return nil }
			
			_coordinates = validCoordinates.map {
				if let coordinatesArray = $0.array {
					return coordinatesArray.map { Double($0.doubleValue) }
				}
				else {
					return []
				}
			}
		}
		else{
			return nil
		}
	}
}

public extension GeoJSON {
	
	/// Optional Point
	public var multiPoint: MultiPoint? {
		get {
			switch self.type {
			case .MultiPoint:
				return self.object as? MultiPoint
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
