// Point.swift
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

public final class Point : Equatable, GeoJSONEncodable {
	
	/// Shortcut property to latitude
	public var latitude: Double { return _coordinates[1] }
	/// Shortcut property to northing
	public var northing: Double { return _coordinates[1] }
	/// Shortcut property to longitude
	public var longitude: Double { return _coordinates[0] }
	/// Shortcut property to easting
	public var easting: Double { return _coordinates[0] }
	/// Shortcut property to altitude
	public var altitude: Double { return _coordinates[2] }
	
	/// Prefix used for GeoJSON Encoding
	public var prefix: String { return "coordinates" }
	
	/// Private var to store coordinates
	private var _coordinates: [Double] = [0.0, 0.0]
	
	/**
	Designated initializer for creating a Point from a SwiftyJSON object
	
	:param: json The SwiftyJSON Object.
	:returns: The created Point object.
	*/
	public init?(json: JSON) {
		if let jsonCoordinates =  json.array {
			if jsonCoordinates.count < 2 { return nil }
			
			_coordinates = jsonCoordinates.map {
				Double($0.doubleValue)
			}
		}
		else {
			return nil
		}
	}

	/**
	Designated initializer for creating a Point from coordinates
	
	:param: coordinates The coordinate array.
	:returns: The created Point object.
	*/
	public init?(coordinates: [Double]) {
		if coordinates.count < 2 { return nil }
		_coordinates = coordinates
	}
	
	/**
	Returns an object that can be serialized to JSON
	
	:returns: Representation of the Point Object
	*/
	public func json() -> AnyObject {
		return _coordinates as AnyObject
	}
}

/// Array forwarding methods on Point
public extension Point {
	
	/// number of coordinates
	public var count: Int { return _coordinates.count }

	/// subscript to access the Nth coordinates
	public subscript(index: Int) -> Double {
		get { return _coordinates[index] }
		set(newValue) { _coordinates[index] = newValue }
	}
}

/**
== Operator for Point objects

:returns: true if the two points objects have the same number of coordinates and they are all equals
*/
public func ==(lhs: Point, rhs: Point) -> Bool {

	if lhs.count != rhs.count { return false }
	
	for index in 0..<lhs.count {
		if lhs[index] != rhs[index] {
			return false
		}
	}
	
	return true
}

/// Point related methods on GeoJSON
public extension GeoJSON {
	
	/// Optional Point
	public var point: Point? {
		switch type {
		case .Point:
			return object as? Point
		default:
			return nil
		}
	}
	
	/**
	Convenience initializer for creating a GeoJSON Object from a Point
	
	:param: point The Point object.
	:returns: The created GeoJSON object.
	*/
	convenience public init(point: Point) {
		self.init()
		object = point
	}
}